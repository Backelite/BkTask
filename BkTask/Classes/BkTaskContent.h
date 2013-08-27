//
//  BkTaskContent.h
//  BkCore
//
//  Created by Pierre Monod-Broca on 02/03/12.
//  Copyright (c) 2012 Backelite. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The BkTYaskContent class is intented to represent the content exchanged between the steps.
 */
@interface BkTaskContent : NSObject <NSCopying>

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
 *  Content to process for task with input key of type BkTaskContentBodyData
 */
@property (nonatomic, copy) NSData *bodyData;


/**
 *  Content to process for task with input key of type BkTaskContentBodyObject
 */
@property (nonatomic, strong) id bodyObject;

@end

/**
 *  Constant use to define content type as NSData
 */
extern NSString * const BkTaskContentBodyData;

/**
 *  Constant use to define content type as NSObject or subclasses
 */
extern NSString * const BkTaskContentBodyObject;

