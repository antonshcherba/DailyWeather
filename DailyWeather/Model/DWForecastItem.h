//
//  DWForecastItem.h
//  DailyWeather
//
//  Created by Admin on 12.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWForecastItem : NSObject

#pragma mark - time parameters
@property (nonatomic, assign) long dataReceiving;

#pragma mark - main parameters
@property (nonatomic, assign) float temperature;
@property (nonatomic, assign) float temperatureMax;
@property (nonatomic, assign) float temperatureMin;
@property (nonatomic, assign) int humidity;
@property (nonatomic, assign) float pressure;

@property (nonatomic, strong) NSString *degreesType;
@property (nonatomic, strong) NSString *speedType;

#pragma mark - wind parameters
@property (nonatomic, assign) float windSpeed;
@property (nonatomic, assign) float windDirection;

#pragma mark - weather conditions
@property (nonatomic, strong) NSString *weatherCondition;
@property (nonatomic, strong) NSString *weatherDescription;
@property (nonatomic, strong) NSString *weatherIcon;

#pragma mark - Temperature change
- (void) toCelsius;
- (void) toKelvin;
- (void) toFahrenheit;

#pragma mark - Wind speed change
-(void) toMilesPS;
-(void) toMetersPS;
-(void) toKilometersPH;
@end
