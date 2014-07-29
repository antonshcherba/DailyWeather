//
//  DWViewController.h
//  DailyWeather
//
//  Created by Admin on 17.06.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWSettingsViewController.h"
#import "DWLocationSearchViewController.h"

@interface DWViewController : UITableViewController <NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource, LocationDelegate>

#pragma mark - Controls
@property (retain, nonatomic) IBOutlet UITableView *InfoTable;

@end
