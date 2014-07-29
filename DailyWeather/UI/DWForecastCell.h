//
//  DWForecastCell.h
//  DailyWeather
//
//  Created by Admin on 14.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWForecastCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *minDegreesLabel;
@property (retain, nonatomic) IBOutlet UILabel *maxDegreesLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UIImageView *conditionImage;

@end
