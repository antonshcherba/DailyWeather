//
//  DWNetworkManager.m
//  DailyWeather
//
//  Created by Admin on 03.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "DWNetworkManager.h"

@interface DWNetworkManager()
{
    BOOL isLoading;
}
//@property (nonatomic, strong) NSString *srcURL;
@property (nonatomic, strong) NSURLConnection *conn;
@property (nonatomic, strong) NSMutableData *loadedData;
@property (nonatomic,strong) NSMutableArray *requests;

@end

@implementation DWNetworkManager

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _notificationName = nil;
    _requests = [[NSMutableArray alloc] init];
    isLoading = NO;
    
    return self;
}

- (void) loadDataFromURL: (NSString *) URL
{
    if (isLoading == YES) {
        [_requests addObject:URL];
        return;
    }
    NSURL *url = [NSURL URLWithString:[URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    self.conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    if (_loadedData == nil) {
        _loadedData = [[NSMutableData alloc] initWithLength:0];
    }
    isLoading = YES;
    [self.conn start];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.loadedData.length = 0;
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.loadedData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Load failed with error %@", error);
    [self.conn cancel];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [_conn cancel];
    [_conn release];
    NSError *error = nil;
    self.weatherInfo = [NSJSONSerialization JSONObjectWithData:self.loadedData options:0 error:&error];
    if (error) {
        self.weatherInfo = nil;
        NSLog(@"Error parsing data %@", error);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:nil userInfo:self.weatherInfo];
    self.weatherInfo = nil;
    isLoading = NO;
    if (_requests.count != 0) {
        [self loadDataFromURL:[_requests objectAtIndex:0]];
        [_requests removeObjectAtIndex:0];
    }
    
}

- (void) dealloc
{
    [_conn release];
    [_loadedData release];
    [_requests release];
    [super dealloc];
}
@end
