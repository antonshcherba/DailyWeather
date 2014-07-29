//
//  DWWeatherSetting.h
//  DailyWeather
//
//  Created by Admin on 18.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DWWeatherSetting

@required
- (void) setCurrentWeatherWithLoadedDictionary: (NSDictionary*) dictionary;
- (void) setForecastWithLoadedDictionary:(NSDictionary *)dictionary;

@end
