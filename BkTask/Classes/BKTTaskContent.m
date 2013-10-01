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

#import <objc/runtime.h>
#import "BKTTaskContent.h"

NSString * const kBkTaskContentBodyData = @"bodyData";
NSString * const kBkTaskContentBodyObject = @"bodyObject";

@implementation BKTTaskContent {
    NSMutableDictionary *values;
}
@dynamic bodyData;
@dynamic bodyObject;

#pragma mark - Construction

- (id) init
{
    if ((self = [super init])) {
        values = [NSMutableDictionary new];
    }
    return self;
}

- (id) initWithContent:(BKTTaskContent *)content
{
    if ((self = [super init])) {
        values = [content->values mutableCopy];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    BKTTaskContent *copy = [[[self class] allocWithZone:zone] initWithContent:self];
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
    return key;
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
