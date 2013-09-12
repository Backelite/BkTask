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

#import <Foundation/Foundation.h>
#import "BKTTask.h"
#import "BKTTaskContent.h"

/**
 *  Implementation of a step allowing to download data. This step takes no input and returns downloaded data as output.
 */
@interface BKTURLRequestOperation : NSOperation <BKTTaskStep, NSURLConnectionDataDelegate>

/**
 *  The request used to download data.
 */
@property (copy, readonly) NSURLRequest *request;

/**
 *  Accessor for the step error object. If error is different from nil, the task will fail and call the failure block.
 */
@property (strong) NSError *error;

/**
 *  Initializer for the download step.
 *
 *  @param aRequest The request used to download data.
 *
 *  @return A step initialized with a request.
 */
- (id) initWithRequest:(NSURLRequest *)aRequest;

/**
 *  Class method to initialize a download step
 *
 *  @param urlRequest The request used to download data.
 *
 *  @return A step initialized with a request.
 */
+ (instancetype) operationWithRequest:(NSURLRequest *)urlRequest;

@end

@interface BKTTaskContent (BkURLRequestOperation)

/**
 *  The URL response of the receiver.
 */
@property (nonatomic, retain) NSURLResponse *urlResponse;

/**
 *  The HTTP URL response of the receiver. The value may be identical to \ref urlResponse if the latter is kind of NSHTTPURLResponse.
 */
@property (nonatomic, readonly) NSHTTPURLResponse *httpURLResponse;

@end