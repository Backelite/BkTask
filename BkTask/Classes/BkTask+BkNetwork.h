//
//  BkTask+BkNetwork.h
//  BkNetwork
//
//  Created by Pierre Monod-Broca on 03/02/12.
//  Copyright (c) 2012 Backelite. All rights reserved.
//

#import "BkTask.h"

@interface BkTask (BkNetwork)

/**
 *  Create a task to execute the request and download the content. It adds an BkURLRequestOperation initialized with 'aRequest' as first step.
 *  Other steps can be added after.
 *
 *  @param aRequest The request to use to create a download operation as a first step.
 *
 *  @return The task initialized with a download step.
 */
+ (id) taskWithRequest:(NSURLRequest *)aRequest;


/**
 *  Create a task to execute the request, then parse the resulting data as json. It adds an BkURLRequestOperation initialized with 'aRequest' as first step,
 *  And a BkJSONParsingOperation as second step. Other steps can be added after.
 *  The JSON parser is NSJSONSerialization ; iOS 5.0 or better is required.
 *
 *  @param aRequest The request to use to create a download operation as a first step.
 *
 *  @return The task initialized with a download step and a JSON parsing step.
 */
+ (id) taskWithJSONRequest:(NSURLRequest *)aRequest;

@end
