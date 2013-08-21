//
//  BkBlockStepOperation.h
//  BkCore
//
//  Created by Pierre Monod-Broca on 13/04/12.
//  Copyright (c) 2012 Backelite. All rights reserved.
//

#import "BkBasicStepOperation.h"

typedef id (^BkBlockStepOperationBlock)(id input, NSError **error);

@interface BkBlockStepOperation : BkBasicStepOperation

+ (id) blockOperationWithInputKey:(NSString *)inKey outputKey:(NSString *)outKey block:(BkBlockStepOperationBlock)workBlock;
+ (id) blockOperationWithQueue:(NSOperationQueue *)queue block:(BkBlockStepOperationBlock)workBlock;
+ (id) blockOperationWithBlock:(BkBlockStepOperationBlock)workBlock;
- (id) initWithInputKey:(NSString *)inKey outputKey:(NSString *)outKey queue:(NSOperationQueue *)queue block:(BkBlockStepOperationBlock)workBlock;
- (id) initWithInputKey:(NSString *)inKey outputKey:(NSString *)outKey block:(BkBlockStepOperationBlock)workBlock;
- (id) initWithBlock:(BkBlockStepOperationBlock)workBlock;

@end
