//
//  BkBasicStepOperation.h
//  BkCore
//
//  Created by Pierre Monod-Broca on 31/01/12.
//  Copyright (c) 2012 Backelite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BkTask.h"

/**
 * Basic implementation of BkTaskStep.
 * BkBasicStepOperation is abstact and meant to be subclassed.
 */
@interface BkBasicStepOperation : NSOperation <BkTaskStep>

/**
 * Abstract method meant to be overridden by the most basic subclasses to perform its task
 * @discussion Returning nil will cause the task to fail. If your step have no output, simply return [NSNull null].
 */
- (id) processInput:(id)theInput error:(NSError **)error;


/**
 *  Abstract method. See BkTaskContent for possible values.
 *
 *  @return The input key.
 *  @see \ref BkTaskContent.
 */
- (NSString *) inputKey;

/**
 *  Abstract method. See BkTaskContent for possible values.
 *
 *  @return The output key.
 *  @see \ref BkTaskContent.
 */
- (NSString *) outputKey;

@end
