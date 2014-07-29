//
//  DWLocationSearchViewController.m
//  DailyWeather
//
//  Created by Admin on 17.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "DWLocationSearchViewController.h"
#import "DWNetworkManager.h"

@interface DWLocationSearchViewController ()

@property (nonatomic, strong) DWNetworkManager *locationLoader;
@property (nonatomic, strong) NSString *locationQuery;
@property (nonatomic, strong) NSString *city;

@end

@implementation DWLocationSearchViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_locationLoader) {
        _locationLoader = [[DWNetworkManager alloc] init];
        _locationLoader.notificationName = @"LocationLoaded";
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData:) name:self.locationLoader.notificationName object:nil];
    self.locationQuery = @"http://api.geonames.org/search?username=invader13&type=json&maxRows=10&q=";
    _searchResults = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.delegate installLocation:[self.searchResults objectAtIndex:indexPath.row]];
    NSDictionary *resultDictionary = [self.searchResults objectAtIndex:indexPath.row];
    [self.delegate installLocationName: [resultDictionary objectForKey:@"city"] andLatitude: [resultDictionary objectForKey:@"lat"] andLongtitude:[resultDictionary objectForKey:@"long"]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Search Bar Methods
- (void) filterContentForSearchText: (NSString *) searchText scope: (NSString *) scope
{
    //[self.searchResults removeAllObjects];
    if (searchText.length < 3) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@", self.locationQuery, searchText];
    [self.locationLoader loadDataFromURL:url];
    
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return  YES;
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}

- (void) getData: (NSNotification *) notification
{
    if (!notification.userInfo)
        return;
    [notification.userInfo retain];
    NSArray *locationList = [[NSArray alloc] initWithArray:[notification.userInfo objectForKey:@"geonames"]];
    [notification.userInfo release];
    
    //add retain
    [self.searchResults removeAllObjects];
    for (NSDictionary *item in locationList) {
        //DWForecastItem *forecastItem = [[DWForecastItem alloc] init];
        NSString *cityItem = [NSString stringWithFormat:@"%@,%@",[item objectForKey:@"name"], [item objectForKey:@"countryName"]];
        NSDictionary *locationDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:cityItem,@"city",[item objectForKey:@"lat"],@"lat",[item objectForKey:@"lng"],@"long", nil];
        //[self.searchResults addObject:cityItem];
        [self.searchResults addObject:locationDictionary];
        
    }
    [locationList release];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *city = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (indexPath.row < self.searchResults.count) {
            //city = [self.searchResults objectAtIndex:indexPath.row];
            city = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"city"];
        }
        
    }
    cell.textLabel.text = city;
    return cell;
    
    return cell;
}

- (void)dealloc {
    [_LocationSearchBar release];
    [_locationLoader release];
    [_searchResults release];
    
    _LocationSearchBar = nil;
    _locationLoader = nil;
    _searchResults = nil;
    _locationLoader.notificationName = nil;
    [super dealloc];
}
@end
