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
#import "BkTask.h"

extern NSString * const kBKTaskErrorDomain;

/**
 * Basic implementation of BkTaskStep.
 * BkBasicStepOperation is abstact and meant to be subclassed.
 */
@interface BkBasicStepOperation : NSOperation <BkTaskStep>

/**
 * Abstract method meant to be overridden by the most basic subclasses to perform its task
 * @discussion Returning nil will cause the task to fail. If your step have no output, simply return [NSNull null].
 */
- (id) processInput:(id)theInput error:(NSError **)error;


/**
 *  Abstract method. See BkTaskContent for possible values.
 *
 *  @return The input key.
 *  @see \ref BkTaskContent.
 */
- (NSString *) inputKey;

/**
 *  Abstract method. See BkTaskContent for possible values.
 *
 *  @return The output key.
 *  @see \ref BkTaskContent.
 */
- (NSString *) outputKey;

@end
