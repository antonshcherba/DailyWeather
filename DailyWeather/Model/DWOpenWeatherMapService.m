//
//  DWOpenWeatherMapService.m
//  DailyWeather
//
//  Created by Admin on 18.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "DWOpenWeatherMapService.h"

@implementation DWOpenWeatherMapService

-(instancetype) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.serviceName = @"OpenWeatherMap";
    self.currentWeatherRequest = nil;
    self.forecastDataRequest = nil;
    self.cityName = [[NSString alloc] initWithString:@"London"];
    [self.cityName release];
    self.degreesOption = [[NSString alloc] initWithString:@"℃"];
    self.windSpeedOption = [[NSString alloc] initWithString:@"m/s"];
    
    return self;
}

- (void) setCityName:(NSString *)cityName
{
    super.cityName = cityName;
    
    self.currentWeatherRequest = nil;
    self.forecastDataRequest = nil;
    
    //self.currentWeatherRequest = [[NSString alloc]  initWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&units=metric", self.cityName];
    //self.forecastDataRequest = [[NSString alloc]  initWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?mode=json&cnt=5&q=%@&units=metric", self.cityName];
    self.currentWeatherRequest = [[NSString alloc]  initWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=metric", self.latitude, self.longitude];
    self.forecastDataRequest = [[NSString alloc]  initWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?mode=json&cnt=5&lat=%f&lon=%f&units=metric", self.latitude, self.longitude];

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
    
    //self.cityName = [dictionary objectForKey:@"name"];
    //self.latitude = [ (NSNumber *)[[dictionary objectForKey:@"coord"] objectForKey:@"lat"] floatValue];
    //self.longitude = [ (NSNumber *)[[dictionary objectForKey:@"coord"] objectForKey:@"lon"] floatValue];
    
    self.currentWeather.temperature = [ (NSNumber *)[[dictionary objectForKey:@"main"] objectForKey:@"temp"] floatValue];
    self.currentWeather.temperatureMax = [ (NSNumber *)[[dictionary objectForKey:@"main"] objectForKey:@"temp_max"] floatValue];
    self.currentWeather.temperatureMin = [ (NSNumber *)[[dictionary objectForKey:@"main"] objectForKey:@"temp_min"] floatValue];
    self.currentWeather.humidity = [ (NSNumber *)[[dictionary objectForKey:@"main"] objectForKey:@"humidity"] integerValue];
    self.currentWeather.pressure = [ (NSNumber *)[[dictionary objectForKey:@"main"] objectForKey:@"pressure"] floatValue];
    
    self.currentWeather.windSpeed = [ (NSNumber *)[[dictionary objectForKey:@"wind"] objectForKey:@"speed"] floatValue];
    self.currentWeather.windDirection = [ (NSNumber *)[[dictionary objectForKey:@"wind"] objectForKey:@"deg"] floatValue];
    self.currentWeather.speedType = @"m/s";
    
    if ([self.windSpeedOption isEqualToString:@"mps"]) {
        [self.currentWeather toMilesPS];
    } else if ([self.windSpeedOption isEqualToString:@"km/h"]) {
        [self.currentWeather toKilometersPH];
    }
    
    NSArray *weatherParameter = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"weather"]];
    
    self.currentWeather.weatherCondition = [[weatherParameter objectAtIndex:0] objectForKey:@"main"];
    self.currentWeather.weatherDescription = [[weatherParameter objectAtIndex:0] objectForKey:@"description"];
    self.currentWeather.weatherIcon = [self parseIconName:[[weatherParameter objectAtIndex:0] objectForKey:@"icon"]];
    self.currentWeather.degreesType = @"℃";
    
    if ([self.degreesOption isEqualToString:@"℉"]) {
        [self.currentWeather toFahrenheit];
    }
    
    [weatherParameter release];
}

- (void) setForecastWithLoadedDictionary:(NSDictionary *)dictionary
{
    if (!dictionary)
        return;
    
    NSArray *forecastList = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"list"]];
    
    for (id item in self.forecastData) {
        [item release];
        item = nil;
    }
    [self.forecastData removeAllObjects];
    for (NSDictionary *item in forecastList) {
        DWForecastItem *forecastItem = [[DWForecastItem alloc] init];
        forecastItem.temperature = [(NSNumber*)[[item objectForKey:@"temp"] objectForKey:@"day"] floatValue];
        forecastItem.temperatureMin = [(NSNumber*)[[item objectForKey:@"temp"] objectForKey:@"min"] floatValue];
        forecastItem.temperatureMax = [(NSNumber*)[[item objectForKey:@"temp"] objectForKey:@"max"] floatValue];
        forecastItem.pressure = [(NSNumber*)[item objectForKey:@"pressure"] floatValue];
        forecastItem.humidity = [(NSNumber*)[item objectForKey:@"humidity"] integerValue];
        
        forecastItem.windSpeed = [ (NSNumber *)[item objectForKey:@"speed"] floatValue];
        forecastItem.windDirection = [ (NSNumber *)[item objectForKey:@"deg"] floatValue];
        self.currentWeather.speedType = @"m/s";
        
        if ([self.windSpeedOption isEqualToString:@"mps"]) {
            [forecastItem toMilesPS];
        } else if ([self.windSpeedOption isEqualToString:@"km/h"]) {
            [forecastItem toKilometersPH];
        }
        
        NSArray *weatherParameter = [[NSArray alloc] initWithArray:[item objectForKey:@"weather"]];
        forecastItem.weatherCondition = [[weatherParameter objectAtIndex:0] objectForKey:@"main"];
        forecastItem.weatherDescription = [[weatherParameter objectAtIndex:0] objectForKey:@"description"];
        forecastItem.weatherIcon = [self parseIconName: [[weatherParameter objectAtIndex:0] objectForKey:@"icon"]];
        [weatherParameter release];
        
        forecastItem.dataReceiving = [(NSNumber *)[item objectForKey:@"dt"] longValue];
        forecastItem.degreesType = @"℃";
        
        if ([self.degreesOption isEqualToString:@"℉"]) {
            [forecastItem toFahrenheit];
        }
        
        [self.forecastData addObject:forecastItem];
        
    }
    
    [forecastList release];
    
}

- (NSString *) parseIconName: (NSString *) iconName
{
    NSString *localIcon;
    
    if ([iconName isEqualToString:@"01d"]) {
        localIcon = [[NSString alloc] initWithString:@"1.png"];
    } else if ([iconName isEqualToString:@"01n"]) {
        localIcon = [[NSString alloc] initWithString:@"2.png"];
    } else if ([iconName isEqualToString:@"02d"]) {
        localIcon = [[NSString alloc] initWithString:@"3.png"];
    } else if ([iconName isEqualToString:@"02n"]) {
        localIcon = [[NSString alloc] initWithString:@"4.png"];
    } else if ([iconName isEqualToString:@"03d"]
               || [iconName isEqualToString:@"03n"]
               || [iconName isEqualToString:@"04d"]
               || [iconName isEqualToString:@"04n"]) {
        localIcon = [[NSString alloc] initWithString:@"5.png"];
    } else if ([iconName isEqualToString:@"09d"]
               || [iconName isEqualToString:@"09n"]) {
        localIcon = [[NSString alloc] initWithString:@"6.png"];
    } else if ([iconName isEqualToString:@"10d"]) {
        localIcon = [[NSString alloc] initWithString:@"7.png"];
    } else if ([iconName isEqualToString:@"10n"]) {
        localIcon = [[NSString alloc] initWithString:@"8.png"];
    } else if ([iconName isEqualToString:@"11d"]
               || [iconName isEqualToString:@"11n"]) {
        localIcon = [[NSString alloc] initWithString:@"9.png"];
    } else if ([iconName isEqualToString:@"13d"]
               || [iconName isEqualToString:@"13n"]) {
        localIcon = [[NSString alloc] initWithString:@"10.png"];
    }
    
    return [localIcon autorelease];
}

@end
