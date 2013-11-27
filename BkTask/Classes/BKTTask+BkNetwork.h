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

#import "BKTTask.h"

@interface BKTTask (BkNetwork)

/**
 *  Create a task to execute the request and download the content. It adds an \ref BKTURLRequestOperation initialized with 'aRequest' as first step.
 *  Other steps can be added after.
 *
 *  @param aRequest The request to use to create a download operation as a first step.
 *
 *  @return The task initialized with a download step.
 */
+ (id) taskWithRequest:(NSURLRequest *)aRequest;


/**
 *  Create a task to execute the request, then parse the resulting data as json. It adds an \ref BKTURLRequestOperation initialized with 'aRequest' as first step,
 *  And a BKTJSONParsingOperation as second step. Other steps can be added after.
 *  The JSON parser is NSJSONSerialization ; iOS 5.0 or better is required.
 *
 *  @param aRequest The request to use to create a download operation as a first step.
 *
 *  @return The task initialized with a download step and a JSON parsing step.
 */
+ (id) taskWithJSONRequest:(NSURLRequest *)aRequest;

/**
 *  Create a task to execute the request using NSURLSession and download the content. It adds an \ref BKTURLSessionLoadingOperation initialized with 'aRequest' as first step.
 *  Other steps can be added after.
 *
 *  @param aRequest The request to use to create a download operation as a first step.
 *
 *  @return The task initialized with a download step.
 */
+ (id) sessionTaskWithRequest:(NSURLRequest *)aRequest session:(NSURLSession *)session;


/**
 *  Create a task to execute the request, then parse the resulting data as json. It adds an \ref BKTURLSessionLoadingOperation initialized with 'aRequest' as first step,
 *  And a BKTJSONParsingOperation as second step. Other steps can be added after.
 *  The JSON parser is NSJSONSerialization ; iOS 5.0 or better is required.
 *
 *  @param aRequest The request to use to create a download operation as a first step.
 *
 *  @return The task initialized with a download step and a JSON parsing step.
 */
+ (id) sessionTaskWithJSONRequest:(NSURLRequest *)aRequest session:(NSURLSession *)session;

@end
