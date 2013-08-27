//
//  BkFileSavingOperation.h
//  BkNetwork
//
//  Created by Pierre Monod-Broca on 10/02/12.
//  Copyright (c) 2012 Backelite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BkBasicStepOperation.h"

/**
 *  The BkFileSavingOperation class is an implementation of BkBasicStepOperation used to save file on disk.
 */
@interface BkFileSavingOperation : BkBasicStepOperation

/**
 *  Destination URL for saving input as a file.
 */
@property (nonatomic, copy) NSURL *fileURL;

/**
 *  Helper method to create a file saving step with an URL
 *
 *  @param fileURL The destination URL to save file.
 *
 *  @return A file saving step ready to be added to a task
 */
+ (id) saveOperationWithFile:(NSURL *)fileURL;

@end
