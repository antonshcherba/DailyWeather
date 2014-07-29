//
//  DWWorldWeatherOnlineService.h
//  DailyWeather
//
//  Created by Admin on 18.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "DWWeatherService.h"
#import "DWWeatherSetting.h"

@interface DWWorldWeatherOnlineService : DWWeatherService <DWWeatherSetting>

- (void) setCurrentWeatherWithLoadedDictionary: (NSDictionary*) dictionary;
- (void) setForecastWithLoadedDictionary:(NSDictionary *)dictionary;

@end
