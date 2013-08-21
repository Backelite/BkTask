//
//  BkJSONParsingOperation.h
//  BkTask
//
//  Created by Gaspard Viot on 21/08/13.
//  Copyright (c) 2013 Backelite. All rights reserved.
//

#import "BkBasicStepOperation.h"

@interface BkJSONParsingOperation : BkBasicStepOperation

@property (nonatomic, assign) NSJSONReadingOptions jsonOptions;

@end
