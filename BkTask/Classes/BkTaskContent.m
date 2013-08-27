//
//  BkTaskContent.m
//  BkCore
//
//  Created by Pierre Monod-Broca on 02/03/12.
//  Copyright (c) 2012 Backelite. All rights reserved.
//

#import <objc/runtime.h>
#import "BkTaskContent.h"

NSString * const BkTaskContentBodyData = @"bodyData";
NSString * const BkTaskContentBodyObject = @"bodyObject";

@implementation BkTaskContent {
    NSMutableDictionary *values;
}
@dynamic bodyData;
@dynamic bodyObject;

#pragma mark - Destruction

- (void) dealloc
{
    [values release];
    [super dealloc];
}

#pragma mark - Construction

- (id) init
{
    if ((self = [super init])) {
        values = [NSMutableDictionary new];
    }
    return self;
}

- (id) initWithContent:(BkTaskContent *)content
{
    if ((self = [super init])) {
        values = [content->values mutableCopy];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    BkTaskContent *copy = [[[self class] allocWithZone:zone] initWithContent:self];
    return copy;
}

#pragma mark - Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p: %@>", [self class], self, values];
}

#pragma mark - Values

- (id) contentValueForKey:(NSString *)key
{
    return [values objectForKey:key];
}

- (void) setContentValue:(id)value forKey:(NSString *)key
{
    [values setValue:value forKey:key];
}

/// attempt at dynamic resolving properties
static id dynamicGetter(id self, SEL _cmd)
{
    return [self contentValueForKey:NSStringFromSelector(_cmd)];
}

static NSString *BKPropertyNameFromSetter(NSString *setter)
{
    NSMutableString *key = [setter mutableCopy];
    [key deleteCharactersInRange:NSMakeRange(key.length - 1, 1)]; // remove ':' suffix
    [key deleteCharactersInRange:NSMakeRange(0, 3)]; // remove 'set' prefix
    [key replaceCharactersInRange:NSMakeRange(0, 1) // lower first char
                       withString:[[key substringWithRange:NSMakeRange(0, 1)] lowercaseString]];
    return [key autorelease];
}

static void dynamicSetter(id self, SEL _cmd, id value)
{
    NSString *key = BKPropertyNameFromSetter(NSStringFromSelector(_cmd));
    [self setContentValue:value forKey:key];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    BOOL resolved = [super resolveInstanceMethod:sel];
    if (NO == resolved) {
        NSString *methodName = NSStringFromSelector(sel);
        if ([methodName rangeOfString:@":"].location == NSNotFound) {
            if (NULL != class_getProperty([self class], methodName.UTF8String)) {
                class_addMethod(self, sel, (IMP)dynamicGetter, "@@:");
                resolved = YES;
            }
        } else if ([methodName hasPrefix:@"set"]
                   && [methodName rangeOfString:@":"].location == [methodName length] - 1) {
            if (NULL != class_getProperty([self class], BKPropertyNameFromSetter(methodName).UTF8String)) {
                class_addMethod(self, sel, (IMP)dynamicSetter, "v@:@");
                resolved = YES;
            }
        }
    }
    return resolved;
}

#pragma mark - Properties

- (NSData *)bodyData
{
    return [self contentValueForKey:@"bodyData"];
}

- (void)setBodyData:(NSData *)bodyData
{
    [self setContentValue:bodyData forKey:@"bodyData"];
}

- (id)bodyObject
{
    return [self contentValueForKey:@"bodyObject"];
}

- (void)setBodyObject:(id)bodyObject
{
    [self setContentValue:bodyObject forKey:@"bodyObject"];
}

@end
