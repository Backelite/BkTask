//
//  BkBasicStepOperation.m
//  BkCore
//
//  Created by Pierre Monod-Broca on 31/01/12.
//  Copyright (c) 2012 Backelite. All rights reserved.
//

#import "BkBasicStepOperation.h"
#import "BkTaskContent.h"

@interface BkBasicStepOperation ()

@property (strong) NSError *error;

@end

@implementation BkBasicStepOperation
@synthesize content;
@synthesize error;
@synthesize nextStep;
@synthesize previousStep;
@synthesize task;

#pragma mark - Life Cycle


- (id) init
{
    if ((self = [super init])) {
    }
    return self;
}

#pragma mark - Copy

- (id)copyWithZone:(NSZone *)zone
{
    BkBasicStepOperation *copy = [[[self class] allocWithZone:zone] init];
    return copy;
}

#pragma mark - Properties

#pragma mark - Operation

- (void) main
{
    NSError *theError = nil;
    NSString *key = [self inputKey];
    id input = (key == nil ? self.content : [self.content contentValueForKey:key]);
    id output = [self processInput:input error:&theError];
    if (nil == output) {
        if (theError == nil) {
            theError = [NSError errorWithDomain:@"com.backelite.unknown" code:0 userInfo:nil]; // paliatif
        }
        self.error = theError;
    } else {
        key = [self outputKey];
        if (key == nil) {
            self.content = output;
        } else {
            [self.content setContentValue:output forKey:key];
        }
        
    }
}

- (id) processInput:(id)theInput error:(NSError **)error
{
    NSAssert(NO, @"This is an abstract method."
             " You must overide one of the following method: -start, -main, or -processInput:error:."
             " See documentation of NSOperation and BkBasicStepOperation.");
    return theInput;
}

- (NSString *)inputKey
{
    NSAssert(NO, @"This is an abstract method."
             " See documentation of NSOperation and BkBasicStepOperation.");
    return nil;
}

- (NSString *)outputKey
{
    NSAssert(NO, @"This is an abstract method."
             " See documentation of NSOperation and BkBasicStepOperation.");
    return nil;
}

@end
