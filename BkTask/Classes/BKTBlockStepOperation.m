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

#import "BKTBlockStepOperation.h"
#import "BKTTaskContent.h"

@interface BKTBlockStepOperation ()

@property (copy, nonatomic) BKTBlockStepOperationBlock block;
@property (copy, nonatomic) NSString *inputKey;
@property (copy, nonatomic) NSString *outputKey;

@end

@implementation BKTBlockStepOperation {
    NSOperationQueue *_stepOperationQueue;
}

#pragma mark - Destruction



#pragma mark - Construction

+ (id)blockOperationWithBlock:(BKTBlockStepOperationBlock)workBlock
{
    return [self blockOperationWithInputKey:kBkTaskContentBodyObject outputKey:kBkTaskContentBodyObject block:workBlock];
}

+ (id)blockOperationWithQueue:(NSOperationQueue *)queue block:(BKTBlockStepOperationBlock)workBlock
{
    return [[self alloc] initWithInputKey:kBkTaskContentBodyObject outputKey:kBkTaskContentBodyObject queue:queue block:workBlock];
}
+ (id)blockOperationWithInputKey:(NSString *)inKey outputKey:(NSString *)outKey block:(BKTBlockStepOperationBlock)workBlock
{
    return [[self alloc] initWithInputKey:inKey outputKey:outKey block:workBlock];
}

- (id)initWithInputKey:(NSString *)inKey outputKey:(NSString *)outKey queue:(NSOperationQueue *)queue block:(BKTBlockStepOperationBlock)workBlock
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

- (id)initWithInputKey:(NSString *)inKey outputKey:(NSString *)outKey block:(BKTBlockStepOperationBlock)workBlock
{
    return [self initWithInputKey:inKey outputKey:outKey queue:nil block:workBlock];
}

- (id) initWithBlock:(id (^)(id input, NSError **error))workBlock
{
    return [self initWithInputKey:kBkTaskContentBodyObject outputKey:kBkTaskContentBodyObject block:workBlock];
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
    BKTBlockStepOperation *copy = [super copyWithZone:zone];
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
