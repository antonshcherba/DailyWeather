//
//  DWForecastItem.m
//  DailyWeather
//
//  Created by Admin on 12.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "DWForecastItem.h"

@implementation DWForecastItem

-(instancetype) init
{
    self = [super init];
    _temperature = _temperatureMax = _temperatureMin = _windSpeed = _windDirection = 0.0;
    _humidity = _pressure = 0;
    
    _weatherCondition = [[NSString alloc] init];
    _weatherDescription = [[NSString alloc] init];
    _weatherIcon = [[NSString alloc] init];
    _degreesType = [[NSString alloc] init];
    
    return self;
}

- (void) dealloc
{
    [_weatherCondition release];
    [_weatherDescription release];
    [_weatherIcon release];
    [_degreesType release];
    
    _weatherCondition = nil;
    _weatherDescription = nil;
    _weatherIcon = nil;
    _degreesType = nil;
    [super dealloc];
}

#pragma mark - Set temperature metric

- (void) toCelsius
{
    if ([_degreesType isEqualToString:@"℃"]) {
        return;
    } else if ([_degreesType isEqualToString:@"K"]) {
        _temperature -=273.15;
        _temperatureMax -=273.15;
        _temperatureMin -=273.15;
        _degreesType = @"℃";
    } else if ([_degreesType isEqualToString:@"℉"]) {
        _temperature = (_temperature - 32) * 5 / 9;
        _temperatureMax = (_temperatureMax - 32) * 5 / 9;
        _temperatureMin = (_temperatureMin - 32) * 5 / 9;
        _degreesType = @"℃";
    }
}

- (void) toKelvin
{
    if ([_degreesType isEqualToString:@"K"]) {
        return;
    } else if ([_degreesType isEqualToString:@"℃"]) {
        _temperature +=273.15;
        _temperatureMax +=273.15;
        _temperatureMin +=273.15;
        _degreesType = @"K";
    } else if ([_degreesType isEqualToString:@"℉"]) {
        _temperature = (_temperature + 459.67) / 9 * 5;
        _temperatureMax = (_temperatureMax + 459.67) / 9 * 5;
        _temperatureMin = (_temperatureMin + 459.67) / 9 * 5;
        _degreesType = @"K";
    }
}

-(void) toFahrenheit
{
    if ([_degreesType isEqualToString:@"℉"]) {
        return;
    } else if ([_degreesType isEqualToString:@"℃"]) {
        _temperature = _temperature / 5 * 9 + 32;
        _temperatureMax = _temperatureMax / 5 * 9 + 32;
        _temperatureMin = _temperatureMin / 5 * 9 + 32;
        _degreesType = @"℉";
    } else if ([_degreesType isEqualToString:@"K"]) {
        _temperature = _temperature * 9 / 5 - 459.67;
        _temperatureMax = _temperatureMax * 9 / 5 - 459.67;
        _temperatureMin = _temperatureMin * 9 / 5 - 459.67;
        _degreesType = @"℉";
    }
}

-(void) toMilesPS
{
    if ([_speedType isEqualToString:@"mps"]) {
        return;
    } else if ([_speedType isEqualToString:@"m/s"]) {
        _windSpeed /= 1609;
        _speedType = @"mps";
    } else if ([_speedType isEqualToString:@"km/h"]) {
        _windSpeed /= 5792.4;//1.609 / 3600;
        _speedType = @"mps";
    }
}

-(void) toMetersPS
{
    if ([_speedType isEqualToString:@"m/s"]) {
        return;
    } else if ([_speedType isEqualToString:@"mps"]) {
        _windSpeed *= 1609;
        _speedType = @"m/s";
    } else if ([_speedType isEqualToString:@"km/h"]) {
        _windSpeed /= 3.6;
        _speedType = @"m/s";
    }
}

-(void) toKilometersPH
{
    if ([_speedType isEqualToString:@"km/h"]) {
        return;
    } else if ([_speedType isEqualToString:@"m/s"]) {
        _windSpeed *= 3.6;
        _speedType = @"km/h";
    } else if ([_speedType isEqualToString:@"mps"]) {
        _windSpeed *= 1.609 * 3600;
        _speedType = @"km/h";
    }
}


@end
