//
//  BkJSONParsingOperation.h
//  BkTask
//
//  Created by Gaspard Viot on 21/08/13.
//  Copyright (c) 2013 Backelite. All rights reserved.
//

#import "BkBasicStepOperation.h"

/**
 *  A JSON parsing step using NSJSONSerialization.
 */
@interface BkJSONParsingOperation : BkBasicStepOperation

/**
 *  Options to pass to the JSON parser. Default value is 0.
 */
@property (nonatomic, assign) NSJSONReadingOptions jsonOptions;

@end
