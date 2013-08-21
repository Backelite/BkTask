//
//  BkBlockStepOperation.m
//  BkCore
//
//  Created by Pierre Monod-Broca on 13/04/12.
//  Copyright (c) 2012 Backelite. All rights reserved.
//

#import "BkBlockStepOperation.h"
#import "BkTaskContent.h"

@interface BkBlockStepOperation ()

@property (nonatomic, readonly) BkBlockStepOperationBlock block;
@property (nonatomic, readonly) NSString *inputKey;
@property (nonatomic, readonly) NSString *outputKey;

@end

@implementation BkBlockStepOperation {
    NSOperationQueue *_stepOperationQueue;
}
@synthesize block;
@synthesize inputKey;
@synthesize outputKey;

#pragma mark - Destruction

- (void) dealloc
{
    [block release];
    [inputKey release];
    [outputKey release];
    [_stepOperationQueue release];
    
    [super dealloc];
}


#pragma mark - Construction

+ (id)blockOperationWithBlock:(BkBlockStepOperationBlock)workBlock
{
    return [self blockOperationWithInputKey:BkTaskContentBodyObject outputKey:BkTaskContentBodyObject block:workBlock];
}

+ (id)blockOperationWithQueue:(NSOperationQueue *)queue block:(BkBlockStepOperationBlock)workBlock
{
    return [[[self alloc] initWithInputKey:BkTaskContentBodyObject outputKey:BkTaskContentBodyObject queue:queue block:workBlock] autorelease];
}
+ (id)blockOperationWithInputKey:(NSString *)inKey outputKey:(NSString *)outKey block:(BkBlockStepOperationBlock)workBlock
{
    return [[[self alloc] initWithInputKey:inKey outputKey:outKey block:workBlock] autorelease];
}

- (id)initWithInputKey:(NSString *)inKey outputKey:(NSString *)outKey queue:(NSOperationQueue *)queue block:(BkBlockStepOperationBlock)workBlock
{
    if ((self = [super init])) {
        NSParameterAssert(workBlock != nil);
        _stepOperationQueue = [queue retain];
        block = [workBlock copy];
        inputKey = [inKey copy];
        outputKey = [outKey copy];
    }
    return self;
}

- (id)initWithInputKey:(NSString *)inKey outputKey:(NSString *)outKey block:(BkBlockStepOperationBlock)workBlock
{
    return [self initWithInputKey:inKey outputKey:outKey queue:nil block:workBlock];
}

- (id) initWithBlock:(id (^)(id input, NSError **error))workBlock
{
    return [self initWithInputKey:BkTaskContentBodyObject outputKey:BkTaskContentBodyObject block:workBlock];
}

- (id) init
{
    [self doesNotRecognizeSelector:_cmd]; // use an other init method
    [self release];
    self = nil;
    return self;
}

#pragma mark - Copy

- (id)copyWithZone:(NSZone *)zone
{
    BkBlockStepOperation *copy = [super copyWithZone:zone];
    copy->block = [block copy];
    copy->inputKey = [inputKey copy];
    copy->outputKey = [outputKey copy];
    copy->_stepOperationQueue = [_stepOperationQueue retain];
    return copy;
}

#pragma mark - Work

- (id)processInput:(id)theInput error:(NSError **)error
{
    return block(theInput, error);
}

#pragma mark - Queue

- (NSOperationQueue *)stepOperationQueue
{
    return _stepOperationQueue;
}

@end
