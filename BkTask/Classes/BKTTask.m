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

#import "BKTTask.h"

#import "BKTAssert.h"
#import "BKTTaskContent.h"
#import "BKTMisc.h"

//@class BkTaskStepBuilder;
//typedef id BkTaskStep; // NSArray, NSDictionary or BkStepOperation

static char kvoContextStepIsFinished;
//static char kvoContextStepIsExecuting;

typedef enum BkTaskTarget {
    BkTaskTargetNone,
    BkTaskTargetSuccess,
    BkTaskTargetFailure,
} BkTaskTarget;

@interface BKTTask ()

@property BOOL isExecuting;
@property BOOL isFinished;
@property BOOL isCancelled;

@property (strong, nonatomic) BKTTaskContent *content;
@property (strong, nonatomic) NSError *error;
@property (strong, nonatomic) NSMutableArray *completionHandlers;
@property (strong, nonatomic) NSMutableArray *failureHandlers;
@property (strong, nonatomic) NSMutableSet *currentSteps; // for now should contain 0 or 1 object
@property (strong, nonatomic) BKTStepOperation *lastStep;

//- (BkStepOperation *)realStepForStep:(id)step;
- (void) startStep:(BKTStepOperation *)aStep withInput:(BKTTaskContent *)content;
- (void) stepDidFinish:(BKTStepOperation *)aStep;
- (NSError *) step:(BKTStepOperation *)aStep didFailWithError:(NSError *)error;

- (void) finishAndInvokeTargets:(BkTaskTarget)targetType;
- (void) invokeTargetsForSuccess;
- (void) invokeTargetsForFailure;

+ (NSOperationQueue *) defaultBackgroundQueue;

@end

@interface BKTTaskTargetInvocation : NSObject
+ (id) invocationWithTarget:(id)target completion:(BKTTaskCompletion)completion;
+ (id) invocationWithTarget:(id)target selector:(SEL)selector;
@property (nonatomic, unsafe_unretained) id target;
- (void)invokeWithTask:(BKTTask *)tr output:(id)output;
@end

@implementation BKTTask {
    NSMutableSet *steps;
}

@synthesize completionHandlers;
@synthesize content;
@synthesize currentSteps;
@synthesize error;
@synthesize failureHandlers;
@synthesize initialStep;
@synthesize isCancelled;
@synthesize isExecuting;
@synthesize isFinished;
@synthesize lastStep;


#pragma mark - Life cycle

- (void)dealloc
{
    NSAssert(NO == isExecuting, @"BkTask (%p) is being deallocated while executing !", self);
}

- (id) init
{
    if (nil != (self = [super init])) {
        steps = [NSMutableSet new];
        currentSteps = [NSMutableSet new];
        completionHandlers = [NSMutableArray new];
        failureHandlers = [NSMutableArray new];
    }
    return self;
}

#pragma mark - Copy

- (id)copyWithZone:(NSZone *)zone
{
    BKTTask *copy = [[[self class] allocWithZone:zone] init];
    for (BKTStepOperation *step in steps) {
        BkSimpleAssert([step conformsToProtocol:@protocol(NSCopying)]);
        BKTStepOperation *stepCopy = [step copyWithZone:zone];
        [copy addStep:stepCopy];
    }
    copy->completionHandlers = [completionHandlers copyWithZone:zone];
    copy->failureHandlers = [failureHandlers copyWithZone:zone];
    return copy;
}

#pragma mark - Description

static NSString *stringFromBool(BOOL yesorno)
{
    return (yesorno ? @"YES" : @"NO");
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p (executing: %@, finished: %@, cancelled: %@)>", [self class], self, stringFromBool(isExecuting), stringFromBool(isFinished), stringFromBool(isCancelled)];
}

#pragma mark - Steps

- (void) addStep:(BKTStepOperation *)aStep
{
    [self insertStep:aStep afterStep:lastStep];
}

- (void) insertStep:(BKTStepOperation *)aStep afterStep:(BKTStepOperation *)previousStep
{
    NSAssert(aStep.task == nil, @"The step being added (%@) is already assigned to a task (%@)", aStep, aStep.task);
    BkSimpleAssert(previousStep == nil || previousStep.task == self);
    BKTStepOperation *nextStep = (previousStep == nil ? initialStep : previousStep.nextStep);
    if (nextStep != nil) {
        NSAssert(nextStep.isExecuting == NO, @"The step being added is followed by a step already running and consequantly won't ever be run");
        NSAssert(nextStep.isFinished == NO, @"The step being added is followed by a step already finished and consequantly won't ever be run");
    }
    [steps addObject:aStep];
    aStep.task = self;
    
    nextStep.previousStep = aStep;
    aStep.nextStep = nextStep;
    aStep.previousStep = previousStep;
    previousStep.nextStep = aStep;
    
    if (nil == previousStep) {
        self.initialStep = aStep;
    }
    if (nil == nextStep) {
        self.lastStep = aStep;
    }
}

- (void) insertStep:(BKTStepOperation *)aStep beforeStep:(BKTStepOperation *)nextStep
{
    BkSimpleAssert(nextStep == nil || nextStep.task == self);
    if (nil == nextStep) {
        [self insertStep:aStep afterStep:lastStep];
    } else {
        [self insertStep:aStep afterStep:nextStep.previousStep];
    }
}

// not yet public
- (void) removeStep:(BKTStepOperation *)aStep andFollowing:(BOOL)chainRemoval
{
    NSAssert(aStep.task == self, @"The step being removed (%@) is not assigned to this task (%@ instead of %@)", aStep, aStep.task, self);
    NSAssert(aStep.isExecuting == NO, @"The step being removed is already running");
    NSAssert(aStep.isFinished == NO, @"The step being removed is already");
    BKTStepOperation *previousStep = aStep.previousStep;
    BKTStepOperation *nextStep = (chainRemoval ? nil : aStep.nextStep);
    previousStep.nextStep = nextStep;
    nextStep.previousStep = previousStep;
    
    [steps removeObject:aStep];
    aStep.task = nil;
    if (chainRemoval) {
        while (nil != (aStep = aStep.nextStep)) {
            [steps removeObject:aStep];
            aStep.task = nil;
        }
    }
}

#pragma mark Target
#pragma mark * Generic

- (void) addTargetInvocation:(BKTTaskTargetInvocation *)targetInvocation inHandlers:(NSMutableArray *)handlers
{
    @synchronized (handlers) {
        NSAssert(nil != handlers, @"(task: %@) target list is nil, target invocation won't be added !", self);
        [handlers addObject:targetInvocation];
    }
}

- (void) removeTarget:(id)target fromHandlers:(NSMutableArray *)handlers
{
    @synchronized (handlers) {
        NSMutableIndexSet *toDelete = [NSMutableIndexSet new];
        NSUInteger i = 0;
        for (NSInvocation *inv in handlers) {
            if (inv.target == target) {
                [toDelete addIndex:i];
            }
            ++i;
        }
        [handlers removeObjectsAtIndexes:toDelete];
    }
}

- (void) invokeTargets:(NSArray *)handlers withOutput:(id)output
{
    if ([NSThread isMainThread]) {
        @synchronized (handlers) {
            for (BKTTaskTargetInvocation *inv in handlers) {
                [inv invokeWithTask:self output:output];
            }
        }
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self invokeTargets:handlers withOutput:output];
        });
    }
}

#pragma mark * Completion

- (void) addTarget:(id)target completion:(BKTTaskCompletion)completion
{
    [self addTargetInvocation:[BKTTaskTargetInvocation invocationWithTarget:target completion:completion]
                   inHandlers:completionHandlers];
}

- (void)removeTargetCompletions:(id)target
{
    [self removeTarget:target fromHandlers:completionHandlers];
    if ([completionHandlers count] == 0) {
        [self cancel];
    }
}

- (void) invokeTargetsForSuccess
{
    id output = (content.bodyObject ?: content.bodyData);
    if ([NSNull null] == output) {
        output = nil;
    }
    [self invokeTargets:completionHandlers withOutput:output];
}

#pragma mark * Failure

- (void)addTarget:(id)target failure:(BKTTaskFailure)failureBlock
{
    [self addTargetInvocation:[BKTTaskTargetInvocation invocationWithTarget:target completion:failureBlock]
                   inHandlers:failureHandlers];
}

- (void)removeTargetFailures:(id)target
{
    [self removeTarget:target fromHandlers:failureHandlers];
}

- (void) invokeTargetsForFailure
{
    [self invokeTargets:failureHandlers withOutput:error];
}

#pragma mark -

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &kvoContextStepIsFinished) {
        BKTStepOperation *step = object;
        if ([step valueForKey:@"isFinished"]) {
            [self stepDidFinish:step];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -

- (void)start
{
    BkSimpleAssert(isExecuting == NO && isFinished == NO);
    self.isExecuting = YES;
    if (isCancelled) {
        self.isFinished = YES;
        self.isExecuting = NO;
    } else {
        [self startStep:initialStep withInput:nil];
    }
}

- (void)cancel
{
    self.isCancelled = YES;
    
    //if interesting to cancel regarding, for example, the current progress...
    self.completionHandlers = nil;
    self.failureHandlers = nil;
    [self.currentSteps makeObjectsPerformSelector:@selector(cancel)];
}

- (void)startStep:(BKTStepOperation *)aStep withInput:(BKTTaskContent *)inputContent
{
    BKTTaskContent *newContent = (inputContent == nil ? [BKTTaskContent new] : [inputContent copy]);
    [aStep setContent:newContent];
    [currentSteps addObject:aStep];
    [aStep addObserver:self forKeyPath:@"isFinished" options:0 context:&kvoContextStepIsFinished];
    NSOperationQueue *queue = nil;
    if ([aStep respondsToSelector:@selector(stepOperationQueue)]) {
        queue = [aStep stepOperationQueue];
    }
    if (nil == queue) {
        queue = [[self class] defaultBackgroundQueue];
    }
    [queue addOperation:aStep];
}

- (void)stepDidFinish:(NSOperation<BKTTaskStep> *)aStep
{
    if (aStep.isCancelled) {
        self.isCancelled = YES;
    }
    BkSimpleAssert([currentSteps containsObject:aStep]);
    [aStep removeObserver:self forKeyPath:@"isFinished"];
    [currentSteps removeObject:aStep];
    BKTTaskContent *stepOutput = [aStep content];
    NSError *anError = [aStep error];
    self.content = stepOutput;
    
    if (nil != anError) {
        self.error = [self step:aStep didFailWithError:anError];
        [self finishAndInvokeTargets:BkTaskTargetFailure];
    } else if (isCancelled) {
        [self finishAndInvokeTargets:BkTaskTargetNone];
    } else {
        BKTStepOperation * nextStep;
        nextStep = [aStep nextStep];
        if (nil == nextStep) {
            [self finishAndInvokeTargets:BkTaskTargetSuccess];
        } else {
            [self startStep:nextStep withInput:stepOutput];
        }
    }
}

- (NSError *)step:(id<BKTTaskStep>)aStep didFailWithError:(NSError *)anError
{
    //    BKLogE(@"In some task (%@), some step (%@) failed awfully (%@)", self, aStep, anError);
    return anError;
}

#pragma mark - Finish

- (void) finishAndInvokeTargets:(BkTaskTarget)targetType
{
    self.isFinished = YES;
    self.isExecuting = NO;
    BkSimpleAssert([currentSteps count] == 0);
    
    switch (targetType) {
        case BkTaskTargetSuccess:
            [self invokeTargetsForSuccess];
            break;
        case BkTaskTargetFailure:
            [self invokeTargetsForFailure];
            break;
        case BkTaskTargetNone:
            //Do nothing
            break;
    }
    
    self.completionHandlers = nil;
    self.failureHandlers = nil;
}

#pragma mark - Queues

+ (NSOperationQueue *)defaultBackgroundQueue
{
    static NSOperationQueue *defaultQueue = nil;
    if (nil == defaultQueue) {
        //For BK version when we'll stop supporting iOS 3.X
        //static dispatch_once_t onceToken;
        //dispatch_once(&onceToken, ^{
        //    defaultQueue = [NSOperationQueue new];
        //});
        @synchronized (self) {
            if (nil == defaultQueue) {
                defaultQueue = [NSOperationQueue new];
            }
        }
    }
    return defaultQueue;
}

@end

#pragma mark - internal classes

@interface BKTTaskTargetInvocationSelector : BKTTaskTargetInvocation
@property (nonatomic) SEL selector;
@end

@interface BKTTaskTargetInvocationBlock : BKTTaskTargetInvocation
@property (nonatomic, copy) BKTTaskCompletion block;
@end



@implementation BKTTaskTargetInvocation
@synthesize target;
+ (id) invocationWithTarget:(id)target completion:(BKTTaskCompletion)completion
{
    NSParameterAssert(target != nil);
    NSParameterAssert(completion != nil);
    BKTTaskTargetInvocationBlock *b = [BKTTaskTargetInvocationBlock new];
    b.target = target;
    b.block = completion;
    return b;
}
+ (id)invocationWithTarget:(id)target selector:(SEL)selector
{
    NSParameterAssert(target != nil);
    NSParameterAssert(selector != nil);
    BKTTaskTargetInvocationSelector *b = [BKTTaskTargetInvocationSelector new];
    b.target = target;
    b.selector = selector;
    return b;
}
- (void)invokeWithTask:(BKTTask *)tr output:(id)output
{
    [self doesNotRecognizeSelector:_cmd];
}
@end

@implementation BKTTaskTargetInvocationSelector
@synthesize selector;
- (void)invokeWithTask:(BKTTask *)t output:(id)output
{
    NSInvocation *invoc = [NSInvocation invocationWithMethodSignature:[self.target methodSignatureForSelector:selector]];
    [invoc setTarget:self.target];
    [invoc setSelector:selector];
    __unsafe_unretained BKTTask *tempTask = t;
    [invoc setArgument:&tempTask atIndex:2];
    
    __unsafe_unretained id tempOutput = output;
    [invoc setArgument:&tempOutput atIndex:3];
    [invoc invoke];
}
@end

@implementation BKTTaskTargetInvocationBlock
@synthesize block;

- (void)invokeWithTask:(BKTTask *)t output:(id)output
{
    block(t, output);
}
@end