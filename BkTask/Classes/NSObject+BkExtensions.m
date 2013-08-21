//
//  NSObject+BkExtensions.m
//  BkCommon
//
//  Created by François Proulx on 04/11/09.
//  Copyright 2009 Backelite. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+BkExtensions.h"

@implementation NSObject (BkExtensions)

- (id) nonNullValueForKeyPath:(id)keyPath
{
    id obj = [self valueForKeyPath:keyPath];
    if (obj == [NSNull null])
        return nil;
    return obj;
}

+ (id) createObjectOfClass:(Class)aClass fromNibNamed:(NSString *)nibName
{
	NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
	id object = nil; 
	for (NSObject *nibItem in nibContents) { 
		if ([nibItem class] == aClass) { 
			object = nibItem;
			break;
		} 
	} 
	return object;
}

+ (id) createFromNibNamed:(NSString *)nibName
{
	return [self createObjectOfClass:self fromNibNamed:(nibName == nil ? NSStringFromClass(self) : nibName)];
}

- (NSString *)autoDescription
{
    //CLEANUP
	NSMutableString *description = [NSMutableString string];
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//	NSUInteger padding = 0;
//	[TPAutoArchiver objectDescription:self withBuffer:description padding:&padding];
//	[pool drain];
	return (description);
}

- (void) performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg1 withObject:(id)arg2 waitUntilDone:(BOOL)wait
{
	if ([self respondsToSelector:aSelector]) {
		NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
		if (signature) {
			NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
			[invocation setTarget:self];
			[invocation setSelector:aSelector];
			
			// args 0 and 1 are self and _cmd
			[invocation setArgument:&arg1 atIndex:2];
			[invocation setArgument:&arg2 atIndex:3];
			
			[invocation retainArguments];
			
			[invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:wait];
		}
	}
}

- (void) performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg1 withObject:(id)arg2
{
	[self performSelectorOnMainThread:aSelector withObject:arg1 withObject:arg2 waitUntilDone:NO];
}

- (void) performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg1 withObject:(id)arg2 withObject:(id)arg3 waitUntilDone:(BOOL)wait
{
	if ([self respondsToSelector:aSelector]) {
		NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
		if (signature) {
			NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
			[invocation setTarget:self];
			[invocation setSelector:aSelector];
			
			// args 0 and 1 are self and _cmd
			[invocation setArgument:&arg1 atIndex:2];
			[invocation setArgument:&arg2 atIndex:3];
			[invocation setArgument:&arg3 atIndex:4];
			
			[invocation retainArguments];
			
			[invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:wait];
		}
	}
}

- (void) performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg1 withObject:(id)arg2 withObject:(id)arg3
{
	[self performSelectorOnMainThread:aSelector withObject:arg1 withObject:arg2 withObject:arg3 waitUntilDone:NO];
}

+ (void) printSelectors
{
	Method          *methods;
  NSUInteger      i;
  
  methods = class_copyMethodList(self, NULL);
  for (i = 0; methods[i] != NULL; ++i) {
      NSLog(@"%@", NSStringFromSelector(method_getName(methods[i])));
  }
}

@end
