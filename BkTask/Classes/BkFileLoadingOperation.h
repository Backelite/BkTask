//
//  BkFileLoadingOperation.h
//  BkTask
//
//  Created by Gaspard Viot on 21/08/13.
//  Copyright (c) 2013 Backelite. All rights reserved.
//

#import <BkTask/BkTask.h>
#import "BkBasicStepOperation.h"

@interface BkFileLoadingOperation : BkBasicStepOperation

@property (nonatomic, copy) NSURL *fileURL;
@property (nonatomic, assign) NSDataReadingOptions readingOptions;

+ (id) loadOperationWithFile:(NSURL *)fileURL;

@end
