//
//  BKWWeatherViewController.h
//  Weather
//
//  Created by Gaspard Viot on 28/08/13.
//  Copyright (c) 2013 Backelite. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BKWForecast.h"

@interface BKWWeatherViewController : UIViewController

@property (strong, nonatomic) BKWForecast *forecast;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *minTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;

@end
