//
//  DWViewController.m
//  DailyWeather
//
//  Created by Admin on 17.06.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "DWViewController.h"
#import "DWMainCell.h"
#import "DWForecastCell.h"
#import "DWModel.h"

@interface DWViewController ()

@property (nonatomic, strong) NSAttributedString *refreshTitle;

@end

@implementation DWViewController
{
    DWModel *model;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    model = [[DWModel alloc] init];
    
    NSString *refreshMainCellNotification = @"refreshCurrentData";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMainCellData:) name:refreshMainCellNotification object:nil];
    NSString *refreshCellNotification = @"refreshForecastData";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCellData:) name:refreshCellNotification object:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  [defaults objectForKey:@"service"], @"service",
                                  [defaults objectForKey:@"city"], @"city",
                                  [defaults objectForKey:@"degrees"],@"degrees",
                                  [defaults objectForKey:@"speed"],@"speed", nil];
    if (userSettings) {
        
        [model installSettings:userSettings];
        model.weatherInfo.cityName = [userSettings objectForKey:@"city"];
    }
    
    [userSettings autorelease];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshControlAction:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    
    NSAttributedString *tmp = [[NSAttributedString alloc] initWithString:@"Loading weather data"];
    self.refreshControl.attributedTitle = tmp;
    //NSLog(@"viewDidLoad count %i", refreshControl.attributedTitle.retainCount);
    NSLog(@"viewDidLoad count %i", self.refreshControl.attributedTitle.retainCount);
    [self.refreshControl beginRefreshing];
    [model loadCurrentData];
    [model loadForecastData];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)dealloc {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userSettings = [[NSDictionary alloc] initWithObjectsAndKeys:model.weatherInfo.serviceName, @"service",
    model.weatherInfo.cityName, @"city",
    [NSNumber numberWithFloat: model.weatherInfo.latitude],@"lat",
    [NSNumber numberWithFloat: model.weatherInfo.longitude],@"long",
    model.weatherInfo.degreesOption,@"degrees",
    model.weatherInfo.windSpeedOption,@"speed", nil];
    [defaults setObject:userSettings forKey:@"settings"];
    
    [model release];
    [_InfoTable release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI operations

-(void)refreshControlAction: (UIRefreshControl *) sender
{
    //[sender.attributedTitle release];
    NSLog(@"refreshControlAction count %lu", (unsigned long)self.refreshControl.attributedTitle.retainCount);
    sender.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading weather data"];
    [model loadCurrentData];
    [model loadForecastData];
    //[self.refreshControl endRefreshing];
}

#pragma mark - Model operations

- (void) refreshMainCellData: (NSNotification *) notification {
    //[self.refreshControl.attributedTitle release];
    NSLog(@"refreshMainCellData count %lu", (unsigned long)self.refreshControl.attributedTitle.retainCount);
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data"];
    
    self.title = model.weatherInfo.cityName;
    DWMainCell *cell = (DWMainCell *)[self.InfoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self refreshCellData:cell withItem:model.weatherInfo.currentWeather];
    [self.refreshControl endRefreshing];
    

}

- (void) refreshCellData: (NSNotification *) notification {
    int row = 1;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    for (DWForecastItem *item in model.weatherInfo.forecastData) {
        DWForecastCell *cell = (DWForecastCell *)[self.InfoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        if (!cell) {
            continue;
        }
        
        [self refreshCellData:cell withItem:item];
        row++;
    }
    [dateFormatter release];
    //[self.refreshControl endRefreshing];
}

-(void) refreshCellData: (UITableViewCell*) cell withItem: (DWForecastItem*) item
{
    if ([cell isKindOfClass:[DWMainCell class]]) {
        DWMainCell *mainCell = (DWMainCell*) cell;
        mainCell.degreesLabel.text = [NSString stringWithFormat:@"%i%@", (int)item.temperature,item.degreesType];
        mainCell.minDegreesLabel.text = [NSString stringWithFormat:@"Min: %i%@", (int)item.temperatureMin, item.degreesType];
        mainCell.maxDegreesLabel.text = [NSString stringWithFormat:@"Max: %i%@", (int)item.temperatureMax, item.degreesType];
        mainCell.conditionLabel.text = item.weatherCondition;
        mainCell.conditionImage.image = [UIImage imageNamed: item.weatherIcon];
        mainCell.humidytyLabel.text = [NSString stringWithFormat:@"humidity: %i", item.humidity];
        mainCell.pressureLabel.text = [NSString stringWithFormat:@"pressure: %.2f", item.pressure];
        mainCell.windSpeedLabel.text = [NSString stringWithFormat:@"wind speed: %.2f", item.windSpeed];
        
    } else if ([cell isKindOfClass:[DWForecastCell class]]) {
        DWForecastCell *forecastCell = (DWForecastCell *) cell;
        forecastCell.minDegreesLabel.text = [NSString stringWithFormat:@"%i%@", (int)item.temperatureMin, item.degreesType];
        forecastCell.maxDegreesLabel.text = [NSString stringWithFormat:@"%i%@", (int)item.temperatureMax, item.degreesType];
        forecastCell.conditionImage.image = [UIImage imageNamed:item.weatherIcon];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:item.dataReceiving];
        NSString *dateStr = [dateFormatter stringFromDate:date];
        forecastCell.dateLabel.text = dateStr;
        [dateFormatter release];
    }
}

- (void) installLocationName:(NSString *)location andLatitude: (NSNumber*) lat andLongtitude: (NSNumber*)lng
{
    model.weatherInfo.cityName = location;
    model.weatherInfo.latitude = lat.floatValue;
    model.weatherInfo.longitude  = lng.floatValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:location forKey:@"city"];
    [defaults setObject:lat forKey:@"lat"];
    [defaults setObject:lng forKey:@"long"];
    
    [model loadCurrentData];
    [model loadForecastData];
    NSString *refreshCurrentDataNotification = @"refreshCurrentData";
    [[NSNotificationCenter defaultCenter] postNotificationName:refreshCurrentDataNotification object:nil userInfo:nil];
    NSString *refreshForecastDataNotification = @"refreshForecastData";
    [[NSNotificationCenter defaultCenter] postNotificationName:refreshForecastDataNotification object:nil];
}

#pragma mark - Segues

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showSettings"]) {
        DWSettingsViewController *settingsController = segue.destinationViewController;
        settingsController.degreesOption = model.weatherInfo.degreesOption;
        settingsController.windSpeedOption = model.weatherInfo.windSpeedOption;
        settingsController.serviceNameOption = model.weatherInfo.serviceName;
        settingsController.model = model;
    } else if ([segue.identifier isEqualToString:@"showLocationSearch"]) {
        DWLocationSearchViewController *locationController = segue.destinationViewController;
        locationController.delegate = self;
    }
}

#pragma mark - UI operations

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableString *cellIdentifier = [[NSMutableString alloc] init];
    if (indexPath.row == 0) {
        [cellIdentifier appendString:@"MainCell"];
        DWMainCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [cellIdentifier release];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [self refreshCellData:cell withItem:model.weatherInfo.currentWeather];
        
        return cell;
    } else {
        [cellIdentifier appendString:@"ForecastCell"];
        DWForecastCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DWForecastCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if (indexPath.row-1 < [model.weatherInfo.forecastData count])
        {
            
            DWForecastItem *item = [model.weatherInfo.forecastData objectAtIndex:indexPath.row-1];
            [self refreshCellData:cell withItem:item];
        }
        [cellIdentifier release];
        return cell;
    }
    
    [cellIdentifier release];
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return tableView.frame.size.height - self.navigationController.navigationBar.frame.size.height;
            break;
            
        default:
            return (tableView.frame.size.height - self.navigationController.navigationBar.frame.size.height) / 5;
    }
}

@end
