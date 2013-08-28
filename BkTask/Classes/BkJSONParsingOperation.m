//
//  BkJSONParsingOperation.m
//  BkTask
//
//  Created by Gaspard Viot on 21/08/13.
//  Copyright (c) 2013 Backelite. All rights reserved.
//

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
