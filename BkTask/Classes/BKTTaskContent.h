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

/**
 *  The BKTTaskContent class is intented to represent the content exchanged between the steps.
 */
@interface BKTTaskContent : NSObject <NSCopying>

/**
 *  Returns the value associated with a given key.
 *
 *  @param key The key for which to return the corresponding value.
 *
 *  @return The value associated with \ref key.
 */
- (id) contentValueForKey:(NSString *)key;

/**
 *  Add an additionnal value with a key to make it available to multiple steps.
 *
 *  @param value An additionnal value. Cannot be nil.
 *  @param key   The key for \ref value. Uses key value coding.
 */
- (void) setContentValue:(id)value forKey:(NSString *)key;

/**
 *  Content to process for task with input key of type kBkTaskContentBodyData
 */
@property (nonatomic, copy) NSData *bodyData;


/**
 *  Content to process for task with input key of type kBkTaskContentBodyObject
 */
@property (nonatomic, strong) id bodyObject;

@end

/**
 *  Constant use to define content type as NSData
 */
extern NSString * const kBkTaskContentBodyData;

/**
 *  Constant use to define content type as NSObject or subclasses
 */
extern NSString * const kBkTaskContentBodyObject;

