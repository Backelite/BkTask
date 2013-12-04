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

#import "BKTBasicStepOperation.h"

typedef id (^BKTBlockStepOperationBlock)(id input, NSError **error);

/**
 *  Class to create simple steps with just a block, avoiding subclassing of \ref BKTBasicStepOperation in some cases.
 */
@interface BKTBlockStepOperation : BKTBasicStepOperation

/**
 *  Class method to create a simple step with a block.
 *
 *  @param inKey     The input key of the step.
 *  @param outKey    The output key of the step.
 *  @param workBlock The block executed to process step input.
 *
 *  @return A step ready to be added to a task.
 */
+ (id) blockOperationWithInputKey:(NSString *)inKey outputKey:(NSString *)outKey block:(BKTBlockStepOperationBlock)workBlock;

/**
 *  Class method to create a simple step with a block. Input and output keys values are BKTTaskContentBodyObject.
 *
 *  @param queue     The operation queue on which the step should be executed.
 *  @param workBlock The block executed to process step input.
 *
 *  @return A step ready to be added to a task.
 */
+ (id) blockOperationWithQueue:(NSOperationQueue *)queue block:(BKTBlockStepOperationBlock)workBlock;

/**
 *  Class method to create a simple step with a block. Input and output keys values are BKTTaskContentBodyObject.
 *
 *  @param workBlock The block executed to process step input.
 *
 *  @return A step ready to be added to a task.
 */
+ (id) blockOperationWithBlock:(BKTBlockStepOperationBlock)workBlock;

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
- (id) initWithInputKey:(NSString *)inKey outputKey:(NSString *)outKey queue:(NSOperationQueue *)queue block:(BKTBlockStepOperationBlock)workBlock;

/**
 *  Initializer to create a simple step with a block. The queue is nil, though the step will be executed on the default queue used by the task.
 *
 *  @param inKey     The input key of the step.
 *  @param outKey    The output key of the step.
 *  @param workBlock The block executed to process step input.
 *
 *  @return A step ready to be added to a task.
 */
- (id) initWithInputKey:(NSString *)inKey outputKey:(NSString *)outKey block:(BKTBlockStepOperationBlock)workBlock;

/**
 *  Initializer to create a simple step with a block. The queue is nil, though the step will be executed on the default queue used by the task.
 *  Input and output keys values are BkTaskContentBodyObject.
 *
 *  @param workBlock The block executed to process step input.
 *
 *  @return A step ready to be added to a task.
 */
- (id) initWithBlock:(BKTBlockStepOperationBlock)workBlock;

@end
