//
//  BKWCitySearch.h
//  Weather
//
//  Created by Gaspard Viot on 28/08/13.
//  Copyright (c) 2013 Backelite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKWCitySearch : NSObject

@property (strong, nonatomic) NSString *message;
@property (nonatomic) NSInteger resultCount;
@property (strong, nonatomic) NSArray *forecasts; //Array of BKWForecast

- (id)initWithDictionary:(NSDictionary *)dict;

@end
