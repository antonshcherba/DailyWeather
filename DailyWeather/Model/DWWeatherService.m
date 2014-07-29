//
//  DWWeatherService.m
//  DailyWeather
//
//  Created by Admin on 01.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "DWWeatherService.h"

@implementation DWWeatherService


-(instancetype) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _currentWeather = [[DWForecastItem alloc] init];
    _forecastData = [[NSMutableArray alloc] init];

    return self;
}

-(void) dealloc
{
    [_currentWeather release];
    [_forecastData release];
    
    _currentWeather = nil;
    _forecastData = nil;

    [super dealloc];
}

-(NSDictionary *)currentWeatherDictionaryRepresentation
{
    NSDictionary *weatherInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 self.cityName, @"city",
                                 [NSNumber numberWithFloat:self.latitude], @"latitide",
                                 [NSNumber numberWithFloat:self.longitude], @"longitude",
                                 [NSNumber numberWithFloat:_currentWeather.temperature], @"temperature",
                                 [NSNumber numberWithFloat:_currentWeather.temperatureMax], @"temperatureMax",
                                 [NSNumber numberWithFloat:_currentWeather.temperatureMin], @"temperatureMin",
                                 [NSNumber numberWithInt:_currentWeather.humidity], @"humidity",
                                 [NSNumber numberWithInt:_currentWeather.pressure], @"pressure",
                                 [NSNumber numberWithFloat:_currentWeather.windSpeed], @"speed",
                                 [NSNumber numberWithFloat:_currentWeather.windDirection], @"direction",
                                 _currentWeather.weatherCondition, @"condition",
                                 _currentWeather.weatherDescription, @"description",
                                 _currentWeather.weatherIcon, @"icon",
                                 nil];
    return [weatherInfo autorelease];
}

#pragma mark - Update parameters with metric

- (void) toCelsius
{
    self.degreesOption = @"℃";
    [_currentWeather toCelsius];
    for (DWForecastItem *item in _forecastData) {
        [item toCelsius];
    }
}

- (void) toKelvin
{
    self.degreesOption = @"K";
    [_currentWeather toKelvin];
    for (DWForecastItem *item in _forecastData) {
        [item toKelvin];
    }
}

- (void) toFahrenheit
{
    self.degreesOption = @"℉";
    [_currentWeather toFahrenheit];
    for (DWForecastItem *item in _forecastData) {
        [item toFahrenheit];
    }
}

- (void) toMilesPS
{
    [_currentWeather toMilesPS];
    for (DWForecastItem *item in _forecastData) {
        [item toMilesPS];
    }
    self.windSpeedOption = @"mps";
}

- (void) toMetersPS
{
    [_currentWeather toMetersPS];
    for (DWForecastItem *item in _forecastData) {
        [item toMetersPS];
    }
    self.windSpeedOption = @"m/s";
}

- (void) toKilometersPH
{
    [_currentWeather toKilometersPH];
    for (DWForecastItem *item in _forecastData) {
        [item toKilometersPH];
    }
    self.windSpeedOption = @"km/h";
}

@end
