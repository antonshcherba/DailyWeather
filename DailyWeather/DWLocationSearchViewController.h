//
//  DWLocationSearchViewController.h
//  DailyWeather
//
//  Created by Admin on 17.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocationDelegate <NSObject>

- (void) installLocationName:(NSString *)location andLatitude: (NSNumber*) lat andLongtitude: (NSNumber*)lng;

@end

@interface DWLocationSearchViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSMutableArray *searchResults;
@property (retain, nonatomic) IBOutlet UISearchBar *LocationSearchBar;

@property (nonatomic,strong) id<LocationDelegate> delegate;
@end
