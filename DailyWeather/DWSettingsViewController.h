//
//  DWSettingsViewController.h
//  DailyWeather
//
//  Created by Admin on 15.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model/DWModel.h"

@interface DWSettingsViewController : UITableViewController


#pragma mark - Controls
@property (retain, nonatomic) IBOutlet UISegmentedControl *degreesOptionControl;
@property (retain, nonatomic) IBOutlet UISegmentedControl *windSpeedOptionControl;

#pragma mark - Options
@property (nonatomic, strong) NSString *degreesOption;
@property (nonatomic, strong) NSString *windSpeedOption;
@property (nonatomic, strong) NSString *serviceNameOption;

@property (nonatomic, retain) DWModel *model;

- (IBAction)closeSettingsViewAction:(id)sender;

@end
