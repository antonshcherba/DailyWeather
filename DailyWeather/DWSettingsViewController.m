//
//  DWSettingsViewController.m
//  DailyWeather
//
//  Created by Admin on 15.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "DWSettingsViewController.h"

@interface DWSettingsViewController ()
{
    NSInteger currentServiceIndex;
}
@end

@implementation DWSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define SERVICE_1 @"OpenWeatherMap"
#define SERVICE_2 @"World Weather Online"
#define SERVICE_3 @"Weather Underground"

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.degreesOption isEqualToString:@"℃"]) {
        self.degreesOptionControl.selectedSegmentIndex = 0;
    } else if ([self.degreesOption isEqualToString:@"℉"]) {
        self.degreesOptionControl.selectedSegmentIndex = 1;
    }
    
    if ([self.windSpeedOption isEqualToString:@"mps"]) {
        self.windSpeedOptionControl.selectedSegmentIndex = 0;
    } else if ([self.windSpeedOption isEqualToString:@"m/s"]) {
        self.windSpeedOptionControl.selectedSegmentIndex = 1;
    } else if ([self.windSpeedOption isEqualToString:@"km/h"]) {
        self.windSpeedOptionControl.selectedSegmentIndex = 2;
    }
    
    if ([self.serviceNameOption isEqualToString:SERVICE_1]) {
        currentServiceIndex = 0;
    } else if ([self.serviceNameOption isEqualToString:SERVICE_2]) {
        currentServiceIndex = 1;
    } else if ([self.serviceNameOption isEqualToString:SERVICE_3]) {
        currentServiceIndex = 2;
    }
}

- (void)didReceiveMemoryWarning
{
    UIAlertView *error = [[UIAlertView alloc] init];
    [error show];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#define SERVICE_NAME_SECTION 1

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (indexPath.section) {
        case SERVICE_NAME_SECTION:
            if (indexPath.row == currentServiceIndex) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case SERVICE_NAME_SECTION:
            currentServiceIndex = indexPath.row;
            if (currentServiceIndex == 0)
                self.serviceNameOption = SERVICE_1;
            else if (indexPath.row == 1)
                self.serviceNameOption = SERVICE_2;
            else if (indexPath.row == 2)
                self.serviceNameOption = SERVICE_3;
            break;
            
        default:
            break;
    }
    [tableView reloadData];
}

- (void)dealloc {
    [_degreesOptionControl release];
    [_windSpeedOptionControl release];
    [_serviceNameOption release];
    [super dealloc];
}
- (IBAction)closeSettingsViewAction:(id)sender {
    NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [self.degreesOptionControl titleForSegmentAtIndex:[self.degreesOptionControl selectedSegmentIndex]], @"degrees",
                              [self.windSpeedOptionControl titleForSegmentAtIndex:[self.windSpeedOptionControl selectedSegmentIndex]], @"speed",self.serviceNameOption,@"service",nil];
    [self.model installSettings:settings];
    [settings release];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
