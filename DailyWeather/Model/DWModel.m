//
//  DWModel.m
//  DailyWeather
//
//  Created by Admin on 27.06.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "DWModel.h"
#import "DWNetworkManager.h"
#import "DWOpenWeatherMapService.h"
#import "DWWorldWeatherOnlineService.h"
#import "DWWeatherUnderground.h"

@interface DWModel()
{
    BOOL currentWeatherLoading;
    BOOL forecastLoading;
}

@property (nonatomic, strong) DWNetworkManager *weatherLoader;

@end

@implementation DWModel

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if (!self.weatherLoader) {
        self.weatherLoader = [[DWNetworkManager alloc] init];
        self.weatherLoader.notificationName = @"WeatherLoaded";
    }
    if (!self.weatherInfo)
        self.weatherInfo = [[DWOpenWeatherMapService alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData:) name:self.weatherLoader.notificationName object:nil];
    
    return self;
}

- (void) dealloc
{
    [self.weatherLoader release];
    [self.weatherInfo release];
    self.weatherLoader = nil;
    self.weatherInfo = nil;
    
    [super dealloc];
}

- (void) loadCurrentData
{
    currentWeatherLoading = YES;
    [self.weatherLoader loadDataFromURL: _weatherInfo.currentWeatherRequest];
}

- (void) loadForecastData
{
    forecastLoading = YES;
    [self.weatherLoader loadDataFromURL: _weatherInfo.forecastDataRequest];
}

- (void) getData: (NSNotification *) notification
{
    if (!self.weatherInfo) {
        self.weatherInfo = [[DWWorldWeatherOnlineService alloc] init];
    }
    
    [notification.userInfo retain];
    if (currentWeatherLoading) {
        [self.weatherInfo setCurrentWeatherWithLoadedDictionary:[notification userInfo]];
        currentWeatherLoading = NO;
        NSString *refreshCurrentDataNotification = @"refreshCurrentData";
        [[NSNotificationCenter defaultCenter] postNotificationName:refreshCurrentDataNotification object:nil userInfo:[self.weatherInfo currentWeatherDictionaryRepresentation]];
        
    } else if (forecastLoading) {
        [self.weatherInfo setForecastWithLoadedDictionary:[notification userInfo]];
        forecastLoading = NO;
        NSString *refreshForecastDataNotification = @"refreshForecastData";
        [[NSNotificationCenter defaultCenter] postNotificationName:refreshForecastDataNotification object:nil];
    }
    [notification.userInfo release];
}

- (void) installSettings:(NSDictionary *) settings
{
    BOOL refreshFlag = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *option = [settings objectForKey:@"service"];
    if (option && !([option isEqualToString:self.weatherInfo.serviceName])) {
        [self.weatherInfo release];
        self.weatherInfo = nil;
        
        if ([option isEqualToString:@"OpenWeatherMap"])
            self.weatherInfo = [[DWOpenWeatherMapService alloc] init];
        else if ([option isEqualToString:@"World Weather Online"])
            self.weatherInfo = [[DWWorldWeatherOnlineService alloc] init];
        else if ([option isEqualToString:@"Weather Underground"])
            self.weatherInfo = [[DWWeatherUnderground alloc] init];
        self.weatherInfo.degreesOption = [defaults objectForKey:@"degrees"];
        self.weatherInfo.windSpeedOption = [defaults objectForKey:@"speed"];
        self.weatherInfo.latitude = [[defaults objectForKey:@"lat"] floatValue];
        self.weatherInfo.longitude = [[defaults objectForKey:@"long"] floatValue];
        self.weatherInfo.cityName = [defaults objectForKey:@"city"];
        [self loadCurrentData];
        [self loadForecastData];
        [defaults setObject:self.weatherInfo.serviceName forKey:@"service"];
    }

    option = [settings objectForKey:@"degrees"];
    if (option && !([option isEqualToString:self.weatherInfo.degreesOption])) {
        if ([option isEqualToString:@"℃"]) {
            [self.weatherInfo toCelsius];
        } else if ([option isEqualToString:@"℉"]) {
            [self.weatherInfo toFahrenheit];
        }
        refreshFlag = YES;
        [defaults setObject:self.weatherInfo.degreesOption forKey:@"degrees"];
    }
    option = [settings objectForKey:@"speed"];
    if (option && !([option isEqualToString:self.weatherInfo.windSpeedOption])) {
        if ([option isEqualToString:@"mps"]) {
            [self.weatherInfo toMilesPS];
        } else if ([option isEqualToString:@"m/s"]) {
            [self.weatherInfo toMetersPS];
        } else if ([option isEqualToString:@"km/h"]) {
            [self.weatherInfo toKilometersPH];
        }
        refreshFlag = YES;
        [defaults setObject:self.weatherInfo.windSpeedOption forKey:@"speed"];
    }
    
    if (refreshFlag) {
        NSString *refreshCurrentDataNotification = @"refreshCurrentData";
        [[NSNotificationCenter defaultCenter] postNotificationName:refreshCurrentDataNotification object:nil userInfo:nil];
        NSString *refreshForecastDataNotification = @"refreshForecastData";
        [[NSNotificationCenter defaultCenter] postNotificationName:refreshForecastDataNotification object:nil];
    }
}

@end
