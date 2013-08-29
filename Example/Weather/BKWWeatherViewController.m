//
//  BKWWeatherViewController.m
//  Weather
//
//  Created by Gaspard Viot on 28/08/13.
//  Copyright (c) 2013 Backelite. All rights reserved.
//

#import "BKWWeatherViewController.h"
#import "BKWForecast.h"

@interface BKWWeatherViewController ()

@end

@implementation BKWWeatherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateWithCurrentForecast];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateWithCurrentForecast
{
    self.descriptionLabel.text = [self.forecast.weatherDescription capitalizedString];
    self.temperatureLabel.text = [NSString stringWithFormat:@"%.f°", self.forecast.temperature];
    self.minTemperatureLabel.text = [NSString stringWithFormat:@"%.f°C", self.forecast.temperatureMin];
    self.maxTemperatureLabel.text = [NSString stringWithFormat:@"%.f°C", self.forecast.temperatureMax];
    self.windSpeedLabel.text = [NSString stringWithFormat:@"%.f km/h", self.forecast.windSpeed];
    self.humidityLabel.text = [NSString stringWithFormat:@"%d %%", self.forecast.humidity];
    self.pressureLabel.text = [NSString stringWithFormat:@"%d hPa", self.forecast.pressure];
}

@end
