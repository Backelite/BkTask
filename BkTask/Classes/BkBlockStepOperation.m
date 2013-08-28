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

@property (copy, nonatomic) BkBlockStepOperationBlock block;
@property (copy, nonatomic) NSString *inputKey;
@property (copy, nonatomic) NSString *outputKey;

@end

@implementation BkBlockStepOperation {
    NSOperationQueue *_stepOperationQueue;
}

#pragma mark - Destruction



#pragma mark - Construction

+ (id)blockOperationWithBlock:(BkBlockStepOperationBlock)workBlock
{
    return [self blockOperationWithInputKey:BkTaskContentBodyObject outputKey:BkTaskContentBodyObject block:workBlock];
}

+ (id)blockOperationWithQueue:(NSOperationQueue *)queue block:(BkBlockStepOperationBlock)workBlock
{
    return [[self alloc] initWithInputKey:BkTaskContentBodyObject outputKey:BkTaskContentBodyObject queue:queue block:workBlock];
}
+ (id)blockOperationWithInputKey:(NSString *)inKey outputKey:(NSString *)outKey block:(BkBlockStepOperationBlock)workBlock
{
    return [[self alloc] initWithInputKey:inKey outputKey:outKey block:workBlock];
}

- (id)initWithInputKey:(NSString *)inKey outputKey:(NSString *)outKey queue:(NSOperationQueue *)queue block:(BkBlockStepOperationBlock)workBlock
{
    if ((self = [super init])) {
        NSParameterAssert(workBlock != nil);
        _stepOperationQueue = queue;
        self.block = workBlock;
        self.inputKey = inKey;
        self.outputKey = outKey;
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
    self = nil;
    return self;
}

#pragma mark - Copy

- (id)copyWithZone:(NSZone *)zone
{
    BkBlockStepOperation *copy = [super copyWithZone:zone];
    copy.block = self.block;
    copy.inputKey = self.inputKey;
    copy.outputKey = self.outputKey;
    copy->_stepOperationQueue = _stepOperationQueue;
    return copy;
}

#pragma mark - Work

- (id)processInput:(id)theInput error:(NSError **)error
{
    return self.block(theInput, error);
}

#pragma mark - Queue

- (NSOperationQueue *)stepOperationQueue
{
    return _stepOperationQueue;
}

@end
