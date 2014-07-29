//
//  DWNetworkManager.h
//  DailyWeather
//
//  Created by Admin on 03.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWNetworkManager : NSObject

@property (nonatomic,strong) NSDictionary *weatherInfo;
@property (nonatomic, strong) NSString *notificationName;

- (instancetype) init;
- (void) loadDataFromURL: (NSString *) URL;

@end
