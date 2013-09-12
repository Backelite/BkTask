//
// The MIT License (MIT)
//
// Copyright (c) 2013 Backelite
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "BKTURLRequestOperation.h"
#import "BKTJSONParsingOperation.h"
#import "BKTTaskContent.h"

//Categories
#import "UIApplication+BkCore.h"

@interface BKTURLRequestOperation ()

@property (strong) NSURLConnection *connection;
@property (strong) NSMutableData *downloadedData;
@property (strong, nonatomic) NSURLResponse *response;

- (void) finish;

- (void) markAsStarted;
- (void) markAsFinished;
- (void) markAsCancelled;

@end

@implementation BKTURLRequestOperation {
    BOOL isExecuting;
    BOOL isFinished;
    BOOL isCancelled;
}
@synthesize content;
@synthesize connection;
@synthesize downloadedData;
@synthesize error;
@synthesize nextStep;
@synthesize previousStep;
@synthesize request;
@synthesize response;
@synthesize task;

#pragma mark - Life Cycle


- (id)init
{
    return [self initWithRequest:nil];
}

- (id)initWithRequest:(NSURLRequest *)aRequest
{
    if (nil != (self = [super init])) {
        request = [aRequest copy];
    }
    return self;
}

+ (instancetype) operationWithRequest:(NSURLRequest *)urlRequest
{
    return [[self alloc] initWithRequest:urlRequest];
}

#pragma mark - Copy

- (id) copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithRequest:request];
}

#pragma mark -

- (BOOL) isConcurrent
{
    return YES;
}

- (void)start
{
    if (NO == [NSThread isMainThread]) {
//        BKLogE(@"BkURLRequestOperation not started on main thread (%@)", self);
        [self performSelectorOnMainThread:_cmd withObject:nil waitUntilDone:YES];
    } else {
        @synchronized (self) {
            [self markAsStarted];
            if (isCancelled) {
                [self finish];
            } else {
//                BKLogD(@"connection will start for request: %@", request);
                NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
                self.connection = conn;
                [conn start];
                [[UIApplication sharedApplication] enableNetworkActivityIndicator];
            }
        }
    }
}

- (void) finish
{
    @synchronized (self) {
        [self markAsFinished];
        self.connection = nil;
    }
}

- (void)cancel
{
    @synchronized (self) {
        [self markAsCancelled];
        if (isExecuting) {
            [self.connection cancel];
            [[UIApplication sharedApplication] disableNetworkActivityIndicator];
            [self finish];
        }
    }
}

#pragma mark - handling status codes

#pragma mark - connection delegate

- (void)connection:(NSURLConnection *)theConnection didReceiveBkHTTPResponse:(NSHTTPURLResponse *)httpResponse
{
    NSInteger statusCode = httpResponse.statusCode;
    NSInteger statusClass = statusCode / 100 % 10;
    if (statusClass >= 4) {
        NSMutableDictionary *userInfo = [NSMutableDictionary new];
        NSString *localizedDescription = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
        if (nil == localizedDescription) {
            if (statusClass == 4) {
                localizedDescription = @"Request Error";
            } else if (statusClass == 5) {
                localizedDescription = @"Server Error";
            }
        }
        if (nil != localizedDescription) {
            [userInfo setObject:localizedDescription forKey:NSLocalizedDescriptionKey];
        }
        [userInfo setObject:httpResponse.URL forKey:NSURLErrorFailingURLErrorKey];
        [userInfo setObject:[httpResponse.URL absoluteString] forKey:NSURLErrorFailingURLStringErrorKey];
        [userInfo setObject:@(statusCode) forKey:@"BkHTTPStatusCode"];
        self.error = [NSError errorWithDomain:@"BkHTTPErrorDomain" code:statusCode userInfo:userInfo];
    }
}

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)theResponse
{
    if ([theResponse isKindOfClass:[NSHTTPURLResponse class]]) {
        [self connection:theConnection didReceiveBkHTTPResponse:(NSHTTPURLResponse *)theResponse];
    }
    self.response = theResponse;
    self.downloadedData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [downloadedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)anError
{
    self.error = anError;
    [[UIApplication sharedApplication] disableNetworkActivityIndicator];
    [self finish];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.content.urlResponse = response;
    self.content.bodyData = downloadedData;
    [[UIApplication sharedApplication] disableNetworkActivityIndicator];
    [self finish];
}

#pragma mark - state

- (BOOL) isCancelled
{
    return isCancelled;
}

- (BOOL) isExecuting
{
    return isExecuting;
}

- (BOOL)isFinished
{
    return isFinished;
}

- (void) markAsStarted
{
    @synchronized (self) {
        NSAssert(isExecuting == NO, @"inconsistency detected at -%@", NSStringFromSelector(_cmd));
        [self willChangeValueForKey:@"isExecuting"];
        isExecuting = YES;
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (void) markAsFinished
{
    @synchronized (self) {
        NSAssert(isExecuting == YES, @"inconsistency detected at -%@", NSStringFromSelector(_cmd));
        NSAssert(isFinished == NO, @"inconsistency detected at -%@", NSStringFromSelector(_cmd));
        [self willChangeValueForKey:@"isExecuting"];
        [self willChangeValueForKey:@"isFinished"];
        isFinished = YES;
        isExecuting = NO;
        [self didChangeValueForKey:@"isFinished"];
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (void)markAsCancelled
{
    @synchronized (self) {
        [self willChangeValueForKey:@"isCancelled"];
        isCancelled = YES;
        [self didChangeValueForKey:@"isCancelled"];
    }
}

@end

@implementation BKTTaskContent (BkURLRequestOperation)

static NSString * const urlResponseKey = @"urlResponse";

- (void) setUrlResponse:(NSURLResponse *)urlResponse
{
    [self setContentValue:urlResponse forKey:urlResponseKey];
}

- (NSURLResponse *) urlResponse
{
    return [self contentValueForKey:urlResponseKey];
}

- (NSHTTPURLResponse *) httpURLResponse
{
    id response = [self urlResponse];
    return ([response isKindOfClass:[NSHTTPURLResponse class]] ? response : nil);
}
@end
