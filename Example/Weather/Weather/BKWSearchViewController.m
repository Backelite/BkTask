//
//  AVAViewController.m
//  Weather
//
//  Created by Gaspard Viot on 27/08/13.
//  Copyright (c) 2013 Backelite. All rights reserved.
//

#import "BKWSearchViewController.h"
#import "BKWWeatherViewController.h"

#import "BKWConstants.h"

// Model
#import "BKWCitySearch.h"
#import "BKWForecast.h"

// BkTask
#import "BkTaskCore.h"

@interface BKWSearchViewController ()

@property (strong, nonatomic) BKWCitySearch *citySearch;
@property (strong, nonatomic) BkTask *searchTask;

@end

@implementation BKWSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Search method
- (void)searchCity:(NSString *)cityName
{
    [self.searchTask cancel];
    
    // Create NSURRequest
    NSString *cityQuery = [NSString stringWithFormat:[NSString stringWithFormat:@"%@", CITY_QUERY],
                           [cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, cityQuery];
    NSURLRequest *searchRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Creating task
    // We first create a task with steps to download and parse JSON data.
    // Then, we create a custom step to convert parsed data to a model object.
    self.searchTask = [BkTask taskWithJSONRequest:searchRequest]; //  < Helper method to create a task with 2 steps for loading JSON and then parsing it.
    
    // Adding a custom step to transform parsed json dictionary to NSObject subclass
    BkBlockStepOperation *modelConversionStep = [BkBlockStepOperation blockOperationWithBlock:^id(id input, NSError *__autoreleasing *error) {
        if ([input isKindOfClass:[NSDictionary class]]) {
            BKWCitySearch *citySearch = [[BKWCitySearch alloc] initWithDictionary:input];
            return citySearch;
        } else {
            // Returning nil will make the task fail with a generic error.
            // A nice alternative for failing could be creating a custom NSError and use the error parameter of the block
            return nil;
        }
    }];
    [self.searchTask addStep:modelConversionStep];
    
    // Add a completion block.
    
    __weak BKWSearchViewController *weakSelf = self; // We create a weak reference for self to avoid potential retain cycles with blocks
    
    [self.searchTask addTarget:self completion:^(BkTask *task, id output) {
        weakSelf.citySearch = output;
        [weakSelf.tableView reloadData];
    }];
    
    // Add a failure block.
    [self.searchTask addTarget:self failure:^(BkTask *task, NSError *error) {
        weakSelf.citySearch = nil;
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
    }];
    
    // Start the task
    
    // Note that a task doesn't retain itself, so we use a property to retain it. Otherwise, the task would be deallocated
    // at the end of this method
    [self.searchTask start];
}

#pragma mark - UISearchBar Delegate Methods

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"] == NO) {
        NSString *searchString = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
        if ([searchString length] > 1) {
            [self searchCity:searchString];
        }
    }
    return YES;
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushWeatherView"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        BKWForecast *forecast = [self.citySearch.forecasts objectAtIndex:indexPath.row];
        
        BKWWeatherViewController *weatherController = segue.destinationViewController;
        weatherController.title = forecast.city;
        [weatherController setForecast:forecast];
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.citySearch forecasts] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellID = @"searchResultCellIdentifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellID];
    BKWForecast *forecast = [self.citySearch.forecasts objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ (%@)", forecast.city, forecast.countryCode]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%.f°C", forecast.temperature]];
    return cell;
}


@end
