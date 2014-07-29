//
//  DWWeatherService.h
//  DailyWeather
//
//  Created by Admin on 01.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DWForecastItem.h"

@interface DWWeatherService : NSObject

#pragma mark - locaction parameters
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;

#pragma mark - Weather data
@property (nonatomic,retain) DWForecastItem *currentWeather;
@property (nonatomic,retain) NSMutableArray *forecastData;

#pragma mark - Reqeuest
@property (nonatomic,retain) NSString *currentWeatherRequest;
@property (nonatomic,retain) NSString *forecastDataRequest;

#pragma mark - Settings
@property (nonatomic, strong) NSString *degreesOption;
@property (nonatomic, strong) NSString *windSpeedOption;
@property (nonatomic, strong) NSString *serviceName;

- (NSDictionary *)currentWeatherDictionaryRepresentation;

- (void) toCelsius;
- (void) toFahrenheit;

-(void) toMilesPS;
-(void) toMetersPS;
-(void) toKilometersPH;
@end
