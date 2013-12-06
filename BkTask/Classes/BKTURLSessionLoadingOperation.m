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

#import "BKTURLSessionLoadingOperation.h"
#import "BKTTaskContent.h"
#import "BKTURLRequestOperation.h"

//Categories
#import "UIApplication+BkCore.h"

@interface BKTURLSessionLoadingOperation ()

@property (strong, nonatomic) NSURLSessionDataTask *loadingTask;
@property (strong, nonatomic) NSError *error;

@end

@implementation BKTURLSessionLoadingOperation {
    BOOL isExecuting;
    BOOL isFinished;
    BOOL isCancelled;
}

//Synthetize properties from protocol
@synthesize nextStep;
@synthesize previousStep;
@synthesize task;
@synthesize error;
@synthesize content;

- (instancetype) initWithRequest:(NSURLRequest *)urlRequest
{
    self = [super init];
    if (self) {
        _request = urlRequest;
    }
    return self;
}

+ (instancetype) operationWithRequest:(NSURLRequest *)urlRequest
{
    return [[BKTURLSessionLoadingOperation alloc] initWithRequest:urlRequest];
}

#pragma mark - Copy

- (id) copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithRequest:_request];
}

#pragma mark - Accessors

//If no session provided, we use the shared one
- (NSURLSession *)session
{
    if (_session == nil) {
        _session = [NSURLSession sharedSession];
    }
    return _session;
}

#pragma mark - Operation

- (NSString *) inputKey
{
    return kBkTaskContentBodyData;
}

- (NSString *) outputKey
{
    return kBkTaskContentBodyData;
}

- (void)start
{
    @synchronized (self) {
        [self markAsStarted];
        if ([self isCancelled]) {
            [self finish];
        } else {
            [[self.session dataTaskWithRequest:self.request completionHandler:^(NSData *data, NSURLResponse *response, NSError *networkError) {
                self.content.bodyData = data;
                self.content.urlResponse = response;
                if (networkError) {
                    self.error = networkError;
                } else {
                    self.error = [self errorForResponse:(NSHTTPURLResponse *)response];
                }
                
                [[UIApplication sharedApplication] disableNetworkActivityIndicator];
                [self finish];
            }] resume];
            [[UIApplication sharedApplication] enableNetworkActivityIndicator];
        }
    }
}

- (void) finish
{
    @synchronized (self) {
        [self markAsFinished];
    }
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

- (NSError *)errorForResponse:(NSHTTPURLResponse *)httpResponse
{
    NSError *httpError = nil;
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
        httpError = [NSError errorWithDomain:@"BkHTTPErrorDomain" code:statusCode userInfo:userInfo];
    }
    return httpError;
}

@end
