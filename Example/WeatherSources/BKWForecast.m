//
//  BKWForecast.m
//  Weather
//
//  Created by Gaspard Viot on 28/08/13.
//  Copyright (c) 2013 Backelite. All rights reserved.
//

#import "BKWForecast.h"

@implementation BKWForecast

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _cityId = [[dict objectForKey:@"id"] integerValue];
        _city = [dict objectForKey:@"name"];
        _countryCode = [[dict objectForKey:@"sys"] objectForKey:@"country"];
        
        NSDictionary *mainForecasts = [dict objectForKey:@"main"];
        _temperature = [[mainForecasts objectForKey:@"temp"] doubleValue];
        _temperatureMin = [[mainForecasts objectForKey:@"temp_min"] doubleValue];
        _temperatureMax = [[mainForecasts objectForKey:@"temp_max"] doubleValue];
        _pressure = [[mainForecasts objectForKey:@"pressure"] integerValue];
        _humidity = [[mainForecasts objectForKey:@"humidity"] integerValue];
        
        _windSpeed = [[[dict objectForKey:@"wind"] objectForKey:@"speed"] integerValue];
        _weatherDescription = [[[dict objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"description"];
    }
    return self;
}

@end
