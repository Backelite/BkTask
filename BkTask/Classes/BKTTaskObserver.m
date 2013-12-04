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

#import "BKTTaskObserver.h"
#import "BKTTask.h"


static char taskIsFinishedValueObservingContext = 0;
static NSString *taskIsFinishedKeyPath = @"isFinished";

@interface BKTTaskObserver ()

- (void) addObserverOnTask:(BKTTask *)aTask;
- (void) removeObserverFromTask:(BKTTask *)aTask;
- (void) observeValueForIsFinished:(BOOL)isFinished ofTask:(BKTTask *)aTask;

@end


@implementation BKTTaskObserver {
    NSMutableSet *_observedTasks;
}
@synthesize delegate = _delegate;

#pragma mark - Destruction

- (void) dealloc 
{
    for (BKTTask *aTask in _observedTasks) {
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

- (void) addObserverOnTask:(BKTTask *)aTask
{
    [aTask addObserver:self forKeyPath:taskIsFinishedKeyPath options:NSKeyValueObservingOptionNew context:&taskIsFinishedValueObservingContext];
}

- (void) removeObserverFromTask:(BKTTask *)aTask
{
    [aTask removeObserver:self forKeyPath:taskIsFinishedKeyPath];
}

- (void) observeValueForIsFinished:(BOOL)isFinished ofTask:(BKTTask *)aTask
{
    if (isFinished) {
        [self.delegate observer:self taskDidFinish:aTask];
        [self stopObservingTask:aTask];
    }
}

- (void) observeTask:(BKTTask *)aTask
{
    if (NO == [_observedTasks containsObject:aTask]) {
        [_observedTasks addObject:aTask];
        [self addObserverOnTask:aTask];
    }
}

- (void) stopObservingTask:(BKTTask *)aTask
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
