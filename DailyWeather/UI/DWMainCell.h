//
//  DWMainCell.h
//  DailyWeather
//
//  Created by Admin on 12.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWMainCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *conditionImage;
@property (retain, nonatomic) IBOutlet UILabel *degreesLabel;
@property (retain, nonatomic) IBOutlet UILabel *conditionLabel;
@property (retain, nonatomic) IBOutlet UILabel *minDegreesLabel;
@property (retain, nonatomic) IBOutlet UILabel *maxDegreesLabel;
@property (retain, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (retain, nonatomic) IBOutlet UILabel *humidytyLabel;
@property (retain, nonatomic) IBOutlet UILabel *pressureLabel;


@end
