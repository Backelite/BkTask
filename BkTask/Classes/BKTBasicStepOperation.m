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

#import "BKTBasicStepOperation.h"
#import "BKTTaskContent.h"

NSString * const kBKTaskErrorDomain = @"com.backelite.bktask.ErrorDomain";

@interface BKTBasicStepOperation ()

@property (strong) NSError *error;

@end

@implementation BKTBasicStepOperation
@synthesize content;
@synthesize error;
@synthesize nextStep;
@synthesize previousStep;
@synthesize task;

#pragma mark - Life Cycle


- (id) init
{
    if ((self = [super init])) {
    }
    return self;
}

#pragma mark - Copy

- (id)copyWithZone:(NSZone *)zone
{
    BKTBasicStepOperation *copy = [[[self class] allocWithZone:zone] init];
    return copy;
}

#pragma mark - Properties

#pragma mark - Operation

- (void) main
{
    NSError *theError = nil;
    NSString *key = [self inputKey];
    id input = (key == nil ? self.content : [self.content contentValueForKey:key]);
    id output = [self processInput:input error:&theError];
    if (nil == output) {
        if (theError == nil) {
            //Error should be improved with specific error code
            theError = [NSError errorWithDomain:kBKTaskErrorDomain code:0 userInfo:nil];
        }
        self.error = theError;
    } else {
        key = [self outputKey];
        if (key == nil) {
            self.content = output;
        } else {
            [self.content setContentValue:output forKey:key];
        }
        
    }
}

- (id) processInput:(id)theInput error:(NSError **)error
{
    NSAssert(NO, @"This is an abstract method."
             " You must overide one of the following method: -start, -main, or -processInput:error:."
             " See documentation of NSOperation and BkBasicStepOperation.");
    return theInput;
}

- (NSString *)inputKey
{
    NSAssert(NO, @"This is an abstract method."
             " See documentation of NSOperation and BkBasicStepOperation.");
    return nil;
}

- (NSString *)outputKey
{
    NSAssert(NO, @"This is an abstract method."
             " See documentation of NSOperation and BkBasicStepOperation.");
    return nil;
}

@end
