//
//  BKWCitySearch.m
//  Weather
//
//  Created by Gaspard Viot on 28/08/13.
//  Copyright (c) 2013 Backelite. All rights reserved.
//

#import "BKWCitySearch.h"
#import "BKWForecast.h"

@implementation BKWCitySearch

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _message = [dict objectForKey:@"message"];
        _resultCount = [[dict objectForKey:@"count"] integerValue];
        
        NSArray *forecastsDict = [dict objectForKey:@"list"];
        NSMutableArray *forecasts = [[NSMutableArray alloc] initWithCapacity:[forecastsDict count]];
        [forecastsDict enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            BKWForecast *aForecast = [[BKWForecast alloc] initWithDictionary:obj];
            [forecasts addObject:aForecast];
        }];
        _forecasts = [NSArray arrayWithArray:forecasts];
    }
    return self;
}

@end
