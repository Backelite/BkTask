//
//  BkURLRequestOperation.h
//  BkNetwork
//
//  Created by Pierre Monod-Broca on 31/01/12.
//  Copyright (c) 2012 Backelite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BkTask.h"
#import "BkTaskContent.h"

/**
 * work in progress
 */
@interface BkURLRequestOperation : NSOperation <BkTaskStep, NSURLConnectionDataDelegate>

@property (copy, readonly) NSURLRequest *request;
@property (strong) NSError *error;
- (id) initWithRequest:(NSURLRequest *)aRequest;
+ (instancetype) operationWithRequest:(NSURLRequest *)urlRequest;

@end

@interface BkTaskContent (BkURLRequestOperation)

@property (nonatomic, retain) NSURLResponse *urlResponse;
@property (nonatomic, readonly) NSHTTPURLResponse *httpURLResponse; // returns urlResponse if it is an NSHTTPURLResponse

@end