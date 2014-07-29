//
//  DWWorldWeatherOnlineService.m
//  DailyWeather
//
//  Created by Admin on 18.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "DWWorldWeatherOnlineService.h"

@implementation DWWorldWeatherOnlineService

-(instancetype) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.serviceName = @"World Weather Online";
    self.currentWeatherRequest = nil;
    self.forecastDataRequest = nil;
    self.cityName = [[NSString alloc] initWithString:@"London"];
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
    
    self.currentWeatherRequest = [[NSString alloc]  initWithFormat:@"http://api.worldweatheronline.com/free/v1/weather.ashx?q=%f,%f&format=json&date=today&key=1e10644e277877df6fa292a187cc3907f376df0d", self.latitude, self.longitude];
    self.forecastDataRequest = [[NSString alloc]  initWithFormat:@"http://api.worldweatheronline.com/free/v1/weather.ashx?q=%f,%f&format=json&num_of_days=5&key=1e10644e277877df6fa292a187cc3907f376df0d", self.latitude, self.longitude];

    //self.currentWeatherRequest = [[NSString alloc]  initWithFormat:@"http://api.worldweatheronline.com/free/v1/weather.ashx?q=%@&format=json&date=today&key=1e10644e277877df6fa292a187cc3907f376df0d", self.cityName];
    //self.forecastDataRequest = [[NSString alloc]  initWithFormat:@"http://api.worldweatheronline.com/free/v1/weather.ashx?q=%@&format=json&num_of_days=5&key=1e10644e277877df6fa292a187cc3907f376df0d", self.cityName];
    
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
    NSDictionary *dataDictionary = [[NSDictionary alloc] initWithDictionary:[dictionary objectForKey:@"data"]];
    NSArray *currentConditionArray = [dataDictionary objectForKey:@"current_condition"];
    NSArray *weatherArray = [dataDictionary objectForKey:@"weather"];
    NSDictionary *currentConditionDictionary = [currentConditionArray objectAtIndex:0];
    NSDictionary *weatherDictionary = [weatherArray objectAtIndex:0];
    [dataDictionary release];
    
    self.currentWeather.temperature = [ (NSNumber *)[currentConditionDictionary objectForKey:@"temp_C"] floatValue];
    self.currentWeather.temperatureMax = [ (NSNumber *)[weatherDictionary objectForKey:@"tempMaxC"] floatValue];
    self.currentWeather.temperatureMin = [ (NSNumber *)[weatherDictionary objectForKey:@"tempMinC"] floatValue];
    self.currentWeather.degreesType = @"℃";
    if ([self.degreesOption isEqualToString:@"℃"]) {
        [self.currentWeather toCelsius];
    } else if ([self.degreesOption isEqualToString:@"℉"]) {
        [self.currentWeather toFahrenheit];
    }
    
    self.currentWeather.humidity = [ (NSNumber *)[currentConditionDictionary objectForKey:@"humidity"] integerValue];
    self.currentWeather.pressure = [ (NSNumber *)[currentConditionDictionary objectForKey:@"pressure"] floatValue];
    
    self.currentWeather.weatherCondition = [[[currentConditionDictionary objectForKey:@"weatherDesc"] objectAtIndex:0] objectForKey:@"value"];
    self.currentWeather.weatherDescription = self.currentWeather.weatherCondition;
    self.currentWeather.weatherIcon = [self parseIconCode: [(NSString*)[currentConditionDictionary objectForKey:@"weatherCode"]intValue]];
    
    self.currentWeather.windDirection = [(NSString*)[weatherDictionary objectForKey:@"winddirDegree"] floatValue];
    self.currentWeather.windSpeed = [(NSString*)[weatherDictionary objectForKey:@"windspeedKmph"] floatValue];
    self.currentWeather.speedType = @"km/h";
    
    if ([self.windSpeedOption isEqualToString:@"m/s"]) {
        [self.currentWeather toMetersPS];
    } else if ([self.windSpeedOption isEqualToString:@"mps"]) {
        [self.currentWeather toMilesPS];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd"];
    NSDate *date = [formatter dateFromString:[weatherDictionary objectForKey:@"date"]];
    self.currentWeather.dataReceiving = [date timeIntervalSince1970];
    [formatter release];
}

- (void) setForecastWithLoadedDictionary:(NSDictionary *)dictionary
{
    if (!dictionary)
        return;
    NSDictionary *dataDictionary = [[NSDictionary alloc] initWithDictionary:[dictionary objectForKey:@"data"]];
    NSArray *forecastList = [dataDictionary objectForKey:@"weather"];
    
    for (id item in self.forecastData) {
        [item release];
        item = nil;
    }
    [self.forecastData removeAllObjects];
    for (NSDictionary *item in forecastList) {
        DWForecastItem *forecastItem = [[DWForecastItem alloc] init];
        
        forecastItem.temperatureMax = [ (NSNumber *)[item objectForKey:@"tempMaxC"] floatValue];
        forecastItem.temperatureMin = [ (NSNumber *)[item objectForKey:@"tempMinC"] floatValue];
        forecastItem.temperature = (forecastItem.temperatureMax + forecastItem.temperatureMin) / 2;
        forecastItem.degreesType = @"℃";
        if ([self.degreesOption isEqualToString:@"℃"]) {
            [forecastItem toCelsius];
        } else if ([self.degreesOption isEqualToString:@"℉"]) {
            [forecastItem toFahrenheit];
        }
        
        forecastItem.humidity = 0;
        forecastItem.pressure = 0;
        
        forecastItem.weatherCondition = [[[item objectForKey:@"weatherDesc"] objectAtIndex:0] objectForKey:@"value"];
        forecastItem.weatherDescription = forecastItem.weatherCondition;
        forecastItem.weatherIcon = [self parseIconCode: [(NSString*)[item objectForKey:@"weatherCode"]intValue]];
        
        forecastItem.windDirection = [(NSString*)[item objectForKey:@"winddirDegree"] floatValue];
        forecastItem.windSpeed = [(NSString*)[item objectForKey:@"windspeedKmph"] floatValue];
        forecastItem.speedType = @"km/h";
        
        if ([self.windSpeedOption isEqualToString:@"m/s"]) {
            [forecastItem toMetersPS];
        } else if ([self.windSpeedOption isEqualToString:@"km/h"]) {
            [forecastItem toKilometersPH];
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-mm-dd"];
        NSDate *date = [formatter dateFromString:[item objectForKey:@"date"]];
        forecastItem.dataReceiving = [date timeIntervalSince1970];
        [formatter release];
        
        [self.forecastData addObject:forecastItem];
        
    }
    
    [dataDictionary release];
}

- (NSString *) parseIconCode: (NSInteger) iconCode
{
    NSString *localIcon;
    
    if (iconCode == 113) {
        localIcon = [[NSString alloc] initWithString:@"1.png"];
    } else if (iconCode == 116) {
        localIcon = [[NSString alloc] initWithString:@"3.png"];
    } else if (iconCode == 119 ||
               iconCode == 260 ||
               iconCode == 248 ||
               iconCode == 200 ||
               iconCode == 185 ||
               iconCode == 182 ||
               iconCode == 143 ||
               iconCode == 122) {
        localIcon = [[NSString alloc] initWithString:@"5.png"];
    } else if (iconCode == 266 ||
               iconCode == 263 ||
               iconCode == 176 ||
               iconCode == 353 ||
               iconCode == 296 ||
               iconCode == 293 ||
               iconCode == 176 ||
               iconCode == 359 ||
               iconCode == 356 ||
               iconCode == 311 ||
               iconCode == 308 ||
               iconCode == 305 ||
               iconCode == 302 ||
               iconCode == 299) {
        localIcon = [[NSString alloc] initWithString:@"7.png"];
    } else if (iconCode == 386 || iconCode == 389) {
        localIcon = [[NSString alloc] initWithString:@"9.png"];
    } else if (iconCode == 371 ||
               iconCode == 368 ||
               iconCode == 338 ||
               iconCode == 335 ||
               iconCode == 332 ||
               iconCode == 329 ||
               iconCode == 326 ||
               iconCode == 323 ||
               iconCode == 320 ||
               iconCode == 230 ||
               iconCode == 227 ||
               iconCode == 179 ||
               iconCode == 395 ||
               iconCode == 392 ||
               iconCode == 373 ||
               iconCode == 374 ||
               iconCode == 365 ||
               iconCode == 362 ||
               iconCode == 350 ||
               iconCode == 317 ||
               iconCode == 311 ||
               iconCode == 284 ||
               iconCode == 281) {
        localIcon = [[NSString alloc] initWithString:@"10.png"];
    }
    
    return [localIcon autorelease];
}

@end
