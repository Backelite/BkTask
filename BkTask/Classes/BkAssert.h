//
//  BkAssert.h
//  BkCore
//
//  Created by Pierre Monod-Broca on 31/01/12.
//  Copyright (c) 2012 Backelite. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BkAbstractMethodAssert() NSAssert2(NO, @"%@ is an abstract method and must be overriden in '%@'", NSStringFromSelector(_cmd), [self class])
#define BkSimpleAssert(condition) NSAssert1(condition, @"Assert not satisfying: %s", #condition)
/**
 * a macro to easily detects when a deprecated method is used (use NSAssert)
 */
#define BkMethodDeprecated(format, ...) NSAssert(NO, (@"DEPRECATED: %s (used on <%@ %p>) is deprecated: " format), __PRETTY_FUNCTION__, [self class], self , ##__VA_ARGS__)

/**
 * Convenient Assert to test a parameter class
 */
#define BkParameterClassAssert(param, expectedClass)        NSParameterAssert(param != nil && [param isKindOfClass:[expectedClass class]])
/**
 * Convenient Assert to test a parameter class if not nil
 */
#define BkParameterClassOrNilAssert(param, expectedClass)   NSParameterAssert(param == nil || [param isKindOfClass:[expectedClass class]])
