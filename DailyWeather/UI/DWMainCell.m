//
//  DWMainCell.m
//  DailyWeather
//
//  Created by Admin on 12.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "DWMainCell.h"

@implementation DWMainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

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
    [_degreesLabel release];
    [_conditionLabel release];
    [_conditionImage release];
    [_minDegreesLabel release];
    [_maxDegreesLabel release];
    [_windSpeedLabel release];
    [_humidytyLabel release];
    [_pressureLabel release];
    [super dealloc];
}
@end
