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

#import "BKTFileLoadingOperation.h"
#import "BKTTaskContent.h"

@implementation BKTFileLoadingOperation

#pragma mark - Life Cycle

+ (id)loadOperationWithFile:(NSURL *)fileURL
{
    BKTFileLoadingOperation *ope = [self new];
    ope.fileURL = fileURL;
    return ope;
}

#pragma mark - Copy

- (id)copyWithZone:(NSZone *)zone
{
    BKTFileLoadingOperation *copy = [super copyWithZone:zone];
    copy->_fileURL = [_fileURL copy];
    return copy;
}

#pragma mark -

- (NSString *)inputKey
{
    return kBkTaskContentBodyData;
}

- (NSString *)outputKey
{
    return kBkTaskContentBodyData;
}

#pragma mark -

- (id) processInput:(id)theInput error:(NSError **)error
{
    NSData *fileContent = [NSData dataWithContentsOfURL:_fileURL options:self.readingOptions error:error];
    return fileContent;
}
@end
