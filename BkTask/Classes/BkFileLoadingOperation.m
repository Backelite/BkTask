//
//  BkFileLoadingOperation.m
//  BkTask
//
//  Created by Gaspard Viot on 21/08/13.
//  Copyright (c) 2013 Backelite. All rights reserved.
//

#import "BkFileLoadingOperation.h"
#import "BkTaskContent.h"

@implementation BkFileLoadingOperation

#pragma mark - Life Cycle
- (void) dealloc
{
    [_fileURL release];
    [super dealloc];
}

+ (id)loadOperationWithFile:(NSURL *)fileURL
{
    BkFileLoadingOperation *ope = [self new];
    ope.fileURL = fileURL;
    return [ope autorelease];
}

#pragma mark - Copy

- (id)copyWithZone:(NSZone *)zone
{
    BkFileLoadingOperation *copy = [super copyWithZone:zone];
    copy->_fileURL = [_fileURL copy];
    return copy;
}

#pragma mark -

- (NSString *)inputKey
{
    return BkTaskContentBodyData;
}

- (NSString *)outputKey
{
    return BkTaskContentBodyData;
}

#pragma mark -

- (id) processInput:(id)theInput error:(NSError **)error
{
    NSData *fileContent = [NSData dataWithContentsOfURL:_fileURL options:self.readingOptions error:error];
    return fileContent;
}
@end
