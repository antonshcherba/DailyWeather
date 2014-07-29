//
//  DWWeatherUnderground.m
//  DailyWeather
//
//  Created by Admin on 19.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "DWWeatherUnderground.h"

@implementation DWWeatherUnderground

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.serviceName = @"Weather Underground";
    self.currentWeatherRequest = nil;
    self.forecastDataRequest = nil;
    self.cityName = [[NSString alloc] initWithString:@"London,uk"];
    [self.cityName release];
    self.degreesOption = [[NSString alloc] initWithString:@"℃"];
    self.windSpeedOption = [[NSString alloc] initWithString:@"km/h"];
    
    return self;
}

- (void) setCityName:(NSString *)cityName
{
    super.cityName = cityName;
    
    self.currentWeatherRequest = nil;
    self.forecastDataRequest = nil;
    //NSString *city = [[cityName componentsSeparatedByString:@","] objectAtIndex:0];
    //NSString *country = [[cityName componentsSeparatedByString:@","] objectAtIndex:1];
    
    self.currentWeatherRequest = [[NSString alloc]  initWithFormat:@"http://api.wunderground.com/api/f75712659ed236c8/forecast/q/%f,%f.json", self.latitude, self.longitude];
    self.forecastDataRequest = [[NSString alloc]  initWithFormat:@"http://api.wunderground.com/api/f75712659ed236c8/forecast10day/q/%f,%f.json", self.latitude, self.longitude];
    [self.currentWeatherRequest release];
    [self.forecastDataRequest release];
}

-(void) dealloc
{
    for (id item in self.forecastData) {
        [item release];
        item = nil;
    }
    [self.forecastData removeAllObjects];
    [self.degreesOption release];
    [self.windSpeedOption release];
    
    self.cityName = nil;
    self.degreesOption = nil;
    self.windSpeedOption = nil;
    
    self.currentWeatherRequest = nil;
    self.forecastDataRequest = nil;
    
    [super dealloc];
}

-(void) setCurrentWeatherWithLoadedDictionary:(NSDictionary *)dictionary
{
    if (!dictionary)
        return;
    NSDictionary *forecastDictionary = [[dictionary objectForKey:@"forecast"] objectForKey:@"simpleforecast"];
    NSArray *forecastDays = [[NSArray alloc] initWithArray:[forecastDictionary objectForKey:@"forecastday"]];
    
    NSDictionary *todayDictionary = [forecastDays objectAtIndex:1];
    
    self.currentWeather.temperatureMax = [ (NSNumber *)[[todayDictionary objectForKey:@"high"]objectForKey:@"celsius"] floatValue];
    self.currentWeather.temperatureMin = [ (NSNumber *)[[todayDictionary objectForKey:@"low"]objectForKey:@"celsius"] floatValue];
    self.currentWeather.temperature = (self.currentWeather.temperatureMax + self.currentWeather.temperatureMin) / 2;
    self.currentWeather.degreesType = @"℃";
    if ([self.degreesOption isEqualToString:@"℃"]) {
        [self.currentWeather toCelsius];
    } else if ([self.degreesOption isEqualToString:@"℉"]) {
        [self.currentWeather toFahrenheit];
    }
    
    self.currentWeather.humidity = [ (NSNumber *)[todayDictionary objectForKey:@"avehumidity"] integerValue];
    self.currentWeather.pressure = [ (NSNumber *)[todayDictionary objectForKey:@"pressure"] floatValue];
    
    self.currentWeather.weatherCondition = [todayDictionary objectForKey:@"conditions"];
    self.currentWeather.weatherDescription = self.currentWeather.weatherCondition;
    self.currentWeather.weatherIcon = [self parseIconName:(NSString *)[todayDictionary objectForKey:@"icon"]];
    
    self.currentWeather.windDirection = [[[todayDictionary objectForKey:@"maxwind"]objectForKey:@"degrees"] floatValue];
    self.currentWeather.windSpeed = [[[todayDictionary objectForKey:@"maxwind"]objectForKey:@"kph"] floatValue];
    self.currentWeather.speedType = @"km/h";
    
    if ([self.windSpeedOption isEqualToString:@"m/s"]) {
        [self.currentWeather toMetersPS];
    } else if ([self.windSpeedOption isEqualToString:@"mps"]) {
        [self.currentWeather toMilesPS];
    }
    self.currentWeather.dataReceiving = [(NSString*)[[todayDictionary objectForKey:@"date"] objectForKey:@"epoch"] longLongValue];
    
    [forecastDays release];
    }

- (void) setForecastWithLoadedDictionary:(NSDictionary *)dictionary
{
    NSInteger counter = 0;
    if (!dictionary)
        return;
    NSDictionary *forecastDictionary = [[dictionary objectForKey:@"forecast"] objectForKey:@"simpleforecast"];
    NSArray *forecastDays = [[NSArray alloc] initWithArray:[forecastDictionary objectForKey:@"forecastday"]];
    for (id item in self.forecastData) {
        [item release];
        item = nil;
    }
    [self.forecastData removeAllObjects];
    
    for (NSDictionary *item in forecastDays) {
        if (counter % 2 != 0) {
            continue;
        }
        DWForecastItem *forecastItem = [[DWForecastItem alloc] init];
        forecastItem.temperatureMax = [ (NSNumber *)[[item objectForKey:@"high"]objectForKey:@"celsius"] floatValue];
        forecastItem.temperatureMin = [ (NSNumber *)[[item objectForKey:@"low"]objectForKey:@"celsius"] floatValue];
        forecastItem.temperature = (forecastItem.temperatureMax + forecastItem.temperatureMin) / 2;
        forecastItem.degreesType = @"℃";
        if ([self.degreesOption isEqualToString:@"℃"]) {
            [forecastItem toCelsius];
        } else if ([self.degreesOption isEqualToString:@"℉"]) {
            [forecastItem toFahrenheit];
        }
        
        forecastItem.humidity = [ (NSNumber *)[item objectForKey:@"avehumidity"] integerValue];
        forecastItem.pressure = [ (NSNumber *)[item objectForKey:@"pressure"] floatValue];
        
        forecastItem.weatherCondition = [item objectForKey:@"conditions"];
        forecastItem.weatherDescription = self.currentWeather.weatherCondition;
        forecastItem.weatherIcon = [self parseIconName:(NSString *)[item objectForKey:@"icon"]];
        
        forecastItem.windDirection = [[[item objectForKey:@"maxwind"]objectForKey:@"degrees"] floatValue];
        forecastItem.windSpeed = [[[item objectForKey:@"maxwind"]objectForKey:@"kph"] floatValue];
        forecastItem.speedType = @"km/h";
        
        if ([self.windSpeedOption isEqualToString:@"m/s"]) {
            [forecastItem toMetersPS];
        } else if ([self.windSpeedOption isEqualToString:@"mps"]) {
            [forecastItem toMilesPS];
        }
        forecastItem.dataReceiving = [(NSString*)[[item objectForKey:@"date"] objectForKey:@"epoch"] longLongValue];
        [self.forecastData addObject:forecastItem];
    }
    [forecastDays release];
}

- (NSString *) parseIconName: (NSString *) iconName
{
    NSString *localName;
    
    if ([iconName isEqualToString:@"clear"] ||
        [iconName isEqualToString:@"sunny"]) {
        localName = [[NSString alloc] initWithString:@"1.png"];
    } else if ([iconName isEqualToString:@"mostlycloudy"] ||
               [iconName isEqualToString:@"mostlysunny"] ||
               [iconName isEqualToString:@"partlycloudy"] ||
               [iconName isEqualToString:@"partlysunny"]) {
        localName = [[NSString alloc] initWithString:@"3.png"];
    } else if ([iconName isEqualToString:@"cloudy"] ) {
        localName = [[NSString alloc] initWithString:@"5.png"];
    } else if ([iconName isEqualToString:@"chancerain"] ||
               [iconName isEqualToString:@"rain"]) {
        localName = [[NSString alloc] initWithString:@"6.png"];
    } else if ([iconName isEqualToString:@"chancetstorms"] ||
               [iconName isEqualToString:@"tstorms"] ||
               [iconName isEqualToString:@"unknown"]) {
        localName = [[NSString alloc] initWithString:@"9.png"];
    } else if ([iconName isEqualToString:@"chanceflurries"] ||
               [iconName isEqualToString:@"chancesleet"] ||
               [iconName isEqualToString:@"chancesnow"] ||
               [iconName isEqualToString:@"flurries"] ||
               [iconName isEqualToString:@"sleet"] ||
               [iconName isEqualToString:@"snow"]) {
        localName = [[NSString alloc] initWithString:@"10.png"];
    }
    
    return [localName autorelease];
}

@end
