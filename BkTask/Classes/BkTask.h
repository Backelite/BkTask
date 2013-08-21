//
//  BkTask.h
//  BkNetwork
//
//  Created by Pierre Monod-Broca on 23/01/12.
//  Copyright (c) 2012 Backelite. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BkTask;
@class BkTaskContent;
@protocol BkTaskStep;
typedef NSOperation <BkTaskStep> BkStepOperation;
typedef void (^BkTaskCompletion)(BkTask *task, id output);
typedef void (^BkTaskFailure)(BkTask *task, NSError *error);

/**
 * Asynchronous task group.
 *
 * Meant particularly to handle url request when used with [BkURLRequestOperation]
 *
 * @ingroup operation
 * @see BkTask, BkURLRequestOperation (in BkNetwork), BkTask(BkURLRequestOperation) (in BkNetwork)
 */
@interface BkTask : NSObject <NSCopying>

@property (strong, nonatomic) BkStepOperation *initialStep;
@property (strong, nonatomic, readonly) BkTaskContent *content;
@property (strong, nonatomic) id taskId; //< application defined value that can be used to identify a task

@property (readonly) BOOL isExecuting; //< is set to YES when the task starts, then to NO when it stops, whether it is cancelled, done, or has failed. KVO compliant. Thread safe.
@property (readonly) BOOL isFinished; //< is set to NO when the task stops, whether it is cancelled, done, or has failed. KVO compliant. Thread safe.
@property (readonly) BOOL isCancelled; //< is set to YES when the method -cancel is called. KVO compliant. Thread safe.

/// the designated initializer.
- (id) init;
///Helper
//- (id) initWithRequest:(NSURLRequest *)request steps:(NSArray *)stepsOrConfigs;

/** adds a step after the last one. */
- (void) addStep:(BkStepOperation *)aStep;
/** adds a step after another one. Call with previousStep set to nil to add it as the first step. */
- (void) insertStep:(BkStepOperation *)aStep afterStep:(BkStepOperation *)previousStep;
/** adds a step before another one. Raises an exception if nextStep is already running. */
- (void) insertStep:(BkStepOperation *)aStep beforeStep:(BkStepOperation *)nextStep;

/// adds a block to be called on completion.
///
/// 'target' is intended to be used to remove the related completion block when necessary.
/// 'target' is unretained but beware that the same object could be retained by the completion block.
- (void) addTarget:(id)target completion:(BkTaskCompletion)completionBlock;
/// removes the completion handlers registered for target.
/// if 'target' is the last target, it may cancel the task
- (void) removeTargetCompletions:(id)target;

/// adds a block to be called on failure.
/// 'target' is intended to be used to remove the related block when necessary.
/// 'target' is unretained but beware that the same object could be retained by the block.
- (void) addTarget:(id)target failure:(BkTaskFailure)failureBlock;
/// removes the failure handlers registered for target.
- (void) removeTargetFailures:(id)target;

- (void) start;

/**
 * Remove all targets and tries to cancel the task. In most case you should rather remove the target that is no longer interested in the result.
 * @see \ref removeTargetCompletions:
 */
- (void) cancel;

- (id) step:(id <BkTaskStep>)aStep parameterValueForKey:(NSString *)key;

@end

@protocol BkTaskStep <NSObject, NSCopying>

@required
/// the setter are to be used exclusively by the owning task
@property (unsafe_unretained, nonatomic) BkTask *task;
/// the setter are to be used exclusively by the owning task
@property (unsafe_unretained, nonatomic) BkStepOperation *previousStep;
/// the setter are to be used exclusively by the owning task
@property (unsafe_unretained, nonatomic) BkStepOperation *nextStep;
//@property (strong, nonatomic) NSArray *nextSteps;

@property (strong, nonatomic) BkTaskContent *content;
- (NSError *) error;

@optional
- (NSOperationQueue *) stepOperationQueue; //< do not return the main queue

@end

#pragma mark Deprecated

@interface BkTask (Deprecated)

/// adds a target/selector pair that will be invoked once the task is completed.
/// 'selector' should have the following signature: - (void) taskDidEnd:(BkTask *)task output:(id)output.
/// prefer the -addTarget:completion: alternative.
/// @deprecated use \ref addTarget:completion: instead.
- (void) addTarget:(id)target selector:(SEL)selector DEPRECATED_ATTRIBUTE;

/// adds a target/selector pair that will be invoked if the task fails.
/// 'selector' should have the following signature: - (void) taskDidEnd:(BkTask *)task error:(NSError *)error.
/// @deprecated use \ref addTarget:failure: instead.
- (void) addTarget:(id)target failureSelector:(SEL)selector DEPRECATED_ATTRIBUTE;

/// removes the completion handlers registered for target.
/// if 'target' is the last target, it may cancel the task
/// @deprecated use \ref removeTargetCompletions: instead.
- (void) removeTarget:(id)target DEPRECATED_ATTRIBUTE;

@end
