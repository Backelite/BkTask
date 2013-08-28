//
//  BkTaskObserver.m
//  BkCore
//
//  Created by Pierre Monod-Broca on 05/09/12.
//  Copyright (c) 2012 Backelite. All rights reserved.
//

#import "BkTaskObserver.h"

#import "BkLog.h"
#import "BkTask.h"


static char taskIsFinishedValueObservingContext = 0;
static NSString *taskIsFinishedKeyPath = @"isFinished";

@interface BkTaskObserver ()

- (void) addObserverOnTask:(BkTask *)aTask;
- (void) removeObserverFromTask:(BkTask *)aTask;
- (void) observeValueForIsFinished:(BOOL)isFinished ofTask:(BkTask *)aTask;

@end


@implementation BkTaskObserver {
    NSMutableSet *_observedTasks;
}
@synthesize delegate = _delegate;

#pragma mark - Destruction

- (void) dealloc 
{
    for (BkTask *aTask in _observedTasks) {
        [self removeObserverFromTask:aTask];
    }

#if !__has_feature(objc_arc)
    [_observedTasks release];
    [super dealloc];
#endif
}

#pragma mark - Construction

- (id) init
{
    self = [super init];
    if (self) {
        _observedTasks = [NSMutableSet new];
    }
    return self;	
}

#pragma mark - KVO

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &taskIsFinishedValueObservingContext) {
        [self observeValueForIsFinished:[[change objectForKey:NSKeyValueChangeNewKey] boolValue] ofTask:object];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Observation

- (void) addObserverOnTask:(BkTask *)aTask
{
    [aTask addObserver:self forKeyPath:taskIsFinishedKeyPath options:NSKeyValueObservingOptionNew context:&taskIsFinishedValueObservingContext];
}

- (void) removeObserverFromTask:(BkTask *)aTask
{
    [aTask removeObserver:self forKeyPath:taskIsFinishedKeyPath];
}

- (void) observeValueForIsFinished:(BOOL)isFinished ofTask:(BkTask *)aTask
{
    if (isFinished) {
//        BKLogD(@"task <%p> is finished", aTask);
        //TODO: call delegate
        [self stopObservingTask:aTask];
    }
}

- (void) observeTask:(BkTask *)aTask
{
    if (NO == [_observedTasks containsObject:aTask]) {
        [_observedTasks addObject:aTask];
        [self addObserverOnTask:aTask];
    }
}

- (void) stopObservingTask:(BkTask *)aTask
{
    if ([_observedTasks containsObject:aTask]) {
        [self removeObserverFromTask:aTask];
        [_observedTasks removeObject:aTask];
    }
}

#pragma mark -

- (NSSet *) tasks
{
    return [_observedTasks copy];
}

@end
