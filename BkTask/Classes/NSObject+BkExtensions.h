//
//  NSObject+BkExtensions.h
//  BkCommon
//
//  Created by François Proulx on 04/11/09.
//  Copyright 2009 Backelite. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @ingroup categories
 */
@interface NSObject (BkExtensions)

/**
 * Strips those stupid NSNull, very useful when parsing JSON
 */
- (id) nonNullValueForKeyPath:(id)keyPath;

/**
 * Automatically calls [NSObject description] on all properties of the class.
 * Crawls until base class is reached, uses NSFastEnumeration protocol on arrays and dictionaries
 */
- (NSString *)autoDescription;

/**
 * Performs the selector on the receiver on the main thread, supporting 2 arguments
 */
- (void) performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg1 withObject:(id)arg2;

/**
 * Performs the selector on the receiver on the main thread, supporting 2 arguments blocking or not
 */
- (void) performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg1 withObject:(id)arg2 waitUntilDone:(BOOL)wait;

/**
 * Performs the selector on the receiver on the main thread, supporting 3 arguments
 */
- (void) performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg1 withObject:(id)arg2 withObject:(id)arg3;

/**
 * Performs the selector on the receiver on the main thread, supporting 3 arguments blocking or not
 */
- (void) performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg1 withObject:(id)arg2 withObject:(id)arg3 waitUntilDone:(BOOL)wait;

/**
 * NSLog every selector of instance methods of the current class (not superclasses)
 */
+ (void) printSelectors;

@end
