//
//  BKWForecast.h
//  Weather
//
//  Created by Gaspard Viot on 28/08/13.
//  Copyright (c) 2013 Backelite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKWForecast : NSObject

@property (nonatomic) NSInteger cityId;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *countryCode;
@property (nonatomic) double temperature;
@property (nonatomic) double temperatureMin;
@property (nonatomic) double temperatureMax;
@property (nonatomic) NSInteger pressure;
@property (nonatomic) NSInteger humidity;
@property (nonatomic) double windSpeed;
@property (strong, nonatomic) NSString *weatherDescription;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
