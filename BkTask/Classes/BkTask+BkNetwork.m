//
//  BkTask+BkNetwork.m
//  BkNetwork
//
//  Created by Pierre Monod-Broca on 03/02/12.
//  Copyright (c) 2012 Backelite. All rights reserved.
//

#import "BkTask+BkNetwork.h"

#import "BkURLRequestOperation.h"
#import "BkJSONParsingOperation.h"

@implementation BkTask (BkNetwork)

+ (id) taskWithRequest:(NSURLRequest *)aRequest
{
    BkTask *newtask = [BkTask new];
    BkURLRequestOperation *reqOp = [[BkURLRequestOperation alloc] initWithRequest:aRequest];
    [newtask addStep:reqOp];
    return newtask;
}

+ (id) taskWithJSONRequest:(NSURLRequest *)aRequest
{
    BkTask *task = [self taskWithRequest:aRequest];
    BkJSONParsingOperation *jsonOp = [BkJSONParsingOperation new];
    [task addStep:jsonOp];
    return task;
}


@end
