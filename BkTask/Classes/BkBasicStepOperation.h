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
 * abstract method meant to be overridden by the most basic subclasses to perform its task
 */
- (id) processInput:(id)theInput error:(NSError **)error;

/// abstract method. See BkTaskContent for possible values.
- (NSString *) inputKey;
/// abstract method. See BkTaskContent for possible values.
- (NSString *) outputKey;

@end
