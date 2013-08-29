//
//  BkFileLoadingOperation.h
//  BkTask
//
//  Created by Gaspard Viot on 21/08/13.
//  Copyright (c) 2013 Backelite. All rights reserved.
//

#import "BkTask.h"
#import "BkBasicStepOperation.h"

/**
 *  The BkFileLoadingOperation class is an implementation of BkBasicStepOperation used to load a file from disk.
 *  This step is intented to be used as a first step.
 */
@interface BkFileLoadingOperation : BkBasicStepOperation

/**
 *  Source URL for loading the file from disk
 */
@property (nonatomic, copy) NSURL *fileURL;

/**
 *  Reading options when loading file. Default value is 0.
 */
@property (nonatomic, assign) NSDataReadingOptions readingOptions;

/**
 *  Helper method to create a file loading step with an URL
 *
 *  @param fileURL The source URL to load file.
 *
 *  @return A file loading step ready to be added to a task.
 */
+ (id) loadOperationWithFile:(NSURL *)fileURL;

@end
