//
//  DWForecastCell.m
//  DailyWeather
//
//  Created by Admin on 14.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "DWForecastCell.h"

@implementation DWForecastCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_minDegreesLabel release];
    [_maxDegreesLabel release];
    [_dateLabel release];
    [_conditionImage release];
    [super dealloc];
}
@end
