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

#import "BKTTask+BkNetwork.h"

#import "BKTURLRequestOperation.h"
#import "BKTURLSessionLoadingOperation.h"
#import "BKTJSONParsingOperation.h"

@implementation BKTTask (BkNetwork)

+ (id) taskWithRequest:(NSURLRequest *)aRequest
{
    BKTTask *newtask = [BKTTask new];
    BKTURLRequestOperation *reqOp = [[BKTURLRequestOperation alloc] initWithRequest:aRequest];
    [newtask addStep:reqOp];
    return newtask;
}

+ (id) taskWithJSONRequest:(NSURLRequest *)aRequest
{
    BKTTask *task = [self taskWithRequest:aRequest];
    BKTJSONParsingOperation *jsonOp = [BKTJSONParsingOperation new];
    [task addStep:jsonOp];
    return task;
}

+ (id) sessionTaskWithRequest:(NSURLRequest *)aRequest session:(NSURLSession *)session
{
    BKTTask *newtask = [BKTTask new];
    BKTURLSessionLoadingOperation *reqOp = [[BKTURLSessionLoadingOperation alloc] initWithRequest:aRequest];
    [reqOp setSession:session];
    [newtask addStep:reqOp];
    return newtask;
}

+ (id) sessionTaskWithJSONRequest:(NSURLRequest *)aRequest session:(NSURLSession *)session
{
    BKTTask *task = [self sessionTaskWithRequest:aRequest session:session];
    BKTJSONParsingOperation *jsonOp = [BKTJSONParsingOperation new];
    [task addStep:jsonOp];
    return task;
}


@end
