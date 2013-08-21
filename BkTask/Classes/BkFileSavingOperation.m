//
//  BkFileSavingOperation.m
//  BkNetwork
//
//  Created by Pierre Monod-Broca on 10/02/12.
//  Copyright (c) 2012 Backelite. All rights reserved.
//

#import "BkFileSavingOperation.h"
#import "BkTaskContent.h"
#import "BkLog.h"

@interface BkFileSavingOperation ()

@end

@implementation BkFileSavingOperation
@synthesize fileURL;

#pragma mark - Life Cycle
- (void) dealloc
{
    [fileURL release];

    [super dealloc];
}

+ (id)saveOperationWithFile:(NSURL *)fileURL
{
    BkFileSavingOperation *ope = [self new];
    ope.fileURL = fileURL;
    return [ope autorelease];
}

#pragma mark - Copy

- (id)copyWithZone:(NSZone *)zone
{
    BkFileSavingOperation *copy = [super copyWithZone:zone];
    copy->fileURL = [fileURL copy];
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
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *dirURL = [fileURL URLByDeletingLastPathComponent];
    if (NO == [manager fileExistsAtPath:[dirURL path]]) {
        if (NO == [manager createDirectoryAtPath:dirURL.path withIntermediateDirectories:YES attributes:nil error:error]) {
            BKLogE(@"error creating dir at URL('%@'): %@", dirURL, *error);
            //TODO: error handling
        }
    }
    NSData *data = theInput;
    if (NO == [data writeToURL:fileURL options:NSDataWritingAtomic error:error]) {
        BKLogE(@"error writing data to URL('%@'): %@", fileURL, *error);
        //TODO: error handling
    }
    return theInput;
}

@end
