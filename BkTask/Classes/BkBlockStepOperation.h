//
//  BkBlockStepOperation.h
//  BkCore
//
//  Created by Pierre Monod-Broca on 13/04/12.
//  Copyright (c) 2012 Backelite. All rights reserved.
//

#import "BkBasicStepOperation.h"

typedef id (^BkBlockStepOperationBlock)(id input, NSError **error);

/**
 *  Class to create simple steps with just a block, avoiding subclassing of BkBasicStepOperation in some cases.
 */
@interface BkBlockStepOperation : BkBasicStepOperation

/**
 *  Class method to create a simple step with a block.
 *
 *  @param inKey     The input key of the step.
 *  @param outKey    The output key of the step.
 *  @param workBlock The block executed to process step input.
 *
 *  @return A step ready to be added to a task.
 */
+ (id) blockOperationWithInputKey:(NSString *)inKey outputKey:(NSString *)outKey block:(BkBlockStepOperationBlock)workBlock;

/**
 *  Class method to create a simple step with a block. Input and output keys values are BkTaskContentBodyObject.
 *
 *  @param queue     The operation queue on which the step should be executed.
 *  @param workBlock The block executed to process step input.
 *
 *  @return A step ready to be added to a task.
 */
+ (id) blockOperationWithQueue:(NSOperationQueue *)queue block:(BkBlockStepOperationBlock)workBlock;

/**
 *  Class method to create a simple step with a block. Input and output keys values are BkTaskContentBodyObject.
 *
 *  @param workBlock The block executed to process step input.
 *
 *  @return A step ready to be added to a task.
 */
+ (id) blockOperationWithBlock:(BkBlockStepOperationBlock)workBlock;

/**
 *  Initializer to create a simple step with a block.
 *
 *  @param inKey     The input key of the step.
 *  @param outKey    The output key of the step.
 *  @param queue     The operation queue on which the step should be executed.
 *  @param workBlock The block executed to process step input.
 *
 *  @return A step ready to be added to a task.
 */
- (id) initWithInputKey:(NSString *)inKey outputKey:(NSString *)outKey queue:(NSOperationQueue *)queue block:(BkBlockStepOperationBlock)workBlock;

/**
 *  Initializer to create a simple step with a block. The queue is nil, though the step will be executed on the default queue used by the task.
 *
 *  @param inKey     The input key of the step.
 *  @param outKey    The output key of the step.
 *  @param workBlock The block executed to process step input.
 *
 *  @return A step ready to be added to a task.
 */
- (id) initWithInputKey:(NSString *)inKey outputKey:(NSString *)outKey block:(BkBlockStepOperationBlock)workBlock;

/**
 *  Initializer to create a simple step with a block. The queue is nil, though the step will be executed on the default queue used by the task.
 *  Input and output keys values are BkTaskContentBodyObject.
 *
 *  @param workBlock The block executed to process step input.
 *
 *  @return A step ready to be added to a task.
 */
- (id) initWithBlock:(BkBlockStepOperationBlock)workBlock;

@end
