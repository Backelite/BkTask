//
//  BkFileSavingOperation.h
//  BkNetwork
//
//  Created by Pierre Monod-Broca on 10/02/12.
//  Copyright (c) 2012 Backelite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BkBasicStepOperation.h"

@interface BkFileSavingOperation : BkBasicStepOperation

@property (nonatomic, copy) NSURL *fileURL;

+ (id) saveOperationWithFile:(NSURL *)fileURL;

@end
