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

#import "BkJSONParsingOperation.h"
#import "BkTaskContent.h"
#import "BkLog.h"

@implementation BkJSONParsingOperation

#pragma mark -

- (NSString *)inputKey
{
    return BkTaskContentBodyData;
}

- (NSString *)outputKey
{
    return BkTaskContentBodyObject;
}

#pragma mark -

- (id) processInput:(id)theInput error:(NSError **)error
{
    id jsonObject = nil;
    NSData *data = theInput;
    if (nil != data) {
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:self.jsonOptions error:error];
        if (jsonObject == nil) {
#ifdef DEBUG
            //An error has occured, so we print JSON string to help debugging
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            BKLogE(@"invalid as json:\n%@", string);
#endif
        }
    }
    return jsonObject;
}

@end
