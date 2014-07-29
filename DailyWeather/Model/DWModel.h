//
//  DWModel.h
//  DailyWeather
//
//  Created by Admin on 27.06.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DWModel.h"
#import "DWWeatherService.h"

@interface DWModel : NSObject

- (void) loadCurrentData;
- (void) loadForecastData;
- (void) installSettings:(NSDictionary *) settings;

@property (nonatomic, retain) DWWeatherService *weatherInfo;
@property (nonatomic, strong) NSString *city;

@end
