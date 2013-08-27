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
 *  Implementation of a step allowing to download data. This step takes no input and returns downloaded data as output.
 */
@interface BkURLRequestOperation : NSOperation <BkTaskStep, NSURLConnectionDataDelegate>

/**
 *  The request used to download data.
 */
@property (copy, readonly) NSURLRequest *request;

/**
 *  Accessor for the step error object. If error is different from nil, the task will fail and call the failure block.
 */
@property (strong) NSError *error;

/**
 *  Initializer for the download step.
 *
 *  @param aRequest The request used to download data.
 *
 *  @return A step initialized with a request.
 */
- (id) initWithRequest:(NSURLRequest *)aRequest;

/**
 *  Class method to initialize a download step
 *
 *  @param urlRequest The request used to download data.
 *
 *  @return A step initialized with a request.
 */
+ (instancetype) operationWithRequest:(NSURLRequest *)urlRequest;

@end

@interface BkTaskContent (BkURLRequestOperation)

/**
 *  The URL response of the receiver.
 */
@property (nonatomic, retain) NSURLResponse *urlResponse;

/**
 *  The HTTP URL response of the receiver. The value may be identical to \ref urlResponse if the latter is kind of NSHTTPURLResponse.
 */
@property (nonatomic, readonly) NSHTTPURLResponse *httpURLResponse;

@end