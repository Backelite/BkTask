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

#import "BkFileSavingOperation.h"
#import "BkTaskContent.h"
#import "BkLog.h"

@interface BkFileSavingOperation ()

@end

@implementation BkFileSavingOperation
@synthesize fileURL;

#pragma mark - Life Cycle

+ (id)saveOperationWithFile:(NSURL *)fileURL
{
    BkFileSavingOperation *ope = [self new];
    ope.fileURL = fileURL;
    return ope;
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
