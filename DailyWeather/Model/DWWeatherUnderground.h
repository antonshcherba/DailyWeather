//
//  DWWeatherUnderground.h
//  DailyWeather
//
//  Created by Admin on 19.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "DWWeatherService.h"

@interface DWWeatherUnderground : DWWeatherService

- (void) setCurrentWeatherWithLoadedDictionary: (NSDictionary*) dictionary;
- (void) setForecastWithLoadedDictionary:(NSDictionary *)dictionary;

@end
