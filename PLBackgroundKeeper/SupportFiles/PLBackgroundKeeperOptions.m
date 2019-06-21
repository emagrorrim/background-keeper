//
//  PLBackgroundKeeperOptions.m
//  PLBackgroundKeeper
//
//  Created by Xin Guo  on 2019/6/21.
//  Copyright © 2019 org.emagrorrim. All rights reserved.
//

#import "PLBackgroundKeeperOptions.h"

const int DEFAULT_POLLING_INTERVAL = 20;

@implementation PLBackgroundKeeperOptions

- (instancetype)initWithBackgroundKeeperType:(PLBackgroundKeeperType)bgKeeperType
                             pollingInterval:(int)pollingInterval {
  if (self = [super init]) {
    _pollingInterval = pollingInterval;
    _bgKeeperType = bgKeeperType;
  }
  return self;
}

+ (PLBackgroundKeeperOptions *)defaultOptions {
  return [[PLBackgroundKeeperOptions alloc] initWithBackgroundKeeperType:PLBackgroundKeeperTypeAuto
                                                         pollingInterval:DEFAULT_POLLING_INTERVAL];
}

@end
