//
//  PLLocationBackgroundKeeper.m
//  PLBackgroundKeeper
//
//  Created by Xin Guo on 2019/6/18.
//  Copyright © 2019 org.emagrorrim. All rights reserved.
//

#import "PLLocationBackgroundKeeper.h"

#import <CoreLocation/CoreLocation.h>

@interface PLLocationBackgroundKeeper ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation PLLocationBackgroundKeeper

- (instancetype)init {
  if (self = [super init]) {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
      [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    [self.locationManager stopUpdatingLocation];
  }
  return self;
}

- (void)start {
  [self.locationManager startUpdatingLocation];
}

- (void)stop {
  [self.locationManager stopUpdatingLocation];
}

- (void)refresh {
  [self stop];
  [self start];
}

- (CLLocationManager *)locationManager {
  if (_locationManager == nil) {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.allowsBackgroundLocationUpdates = YES;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
  }
  return _locationManager;
}

@end
