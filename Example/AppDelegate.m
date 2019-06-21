//
//  AppDelegate.m
//  PLBackgroundKeeper
//
//  Created by Xin Guo  on 2019/6/18.
//  Copyright © 2019 org.emagrorrim. All rights reserved.
//

#import "AppDelegate.h"
#import "PLBGKeeper.h"
#import "Logger.h"

@interface AppDelegate () <PLBackgroundKeeperDelegate>

@property(nonatomic, strong) PLBackgroundKeeper *backgroundKeeper;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.backgroundKeeper = [[PLBackgroundKeeper alloc] initWithOptions:[PLBackgroundKeeperOptions defaultOptions]];
  self.backgroundKeeper.delegate = self;
  return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  [self.backgroundKeeper start];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  [self.backgroundKeeper stop];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma - mark PLBackgroundKeeperDelegate

- (void)backgroundKeeperDidRefreshed {
  int pollingInterval = self.backgroundKeeper.options.pollingInterval;
  NSTimeInterval remainingTime = [[UIApplication sharedApplication] backgroundTimeRemaining];
  if (remainingTime < pollingInterval + 1) {
    [Logger info:[NSString stringWithFormat:@"剩余可执行时间小于轮询时间(%ds) -> 剩余：%es", pollingInterval, remainingTime]];
  } else {
    [Logger info:[NSString stringWithFormat:@"剩余可执行时间大于于轮询时间(%ds) -> 剩余：%es", pollingInterval, remainingTime]];
  }
}

- (void)backgroundKeeper:(PLBackgroundKeeperType)bgKeeperType didChangedToStatus:(PLBackgroundKeeperStatus)bgKeeperStatus {
  NSString *backgroundKeeperName = @"";
  NSString *backgroundKeeperStatus;
  switch (bgKeeperType) {
    case PLBackgroundKeeperTypeAudio: {
      backgroundKeeperName = @"Audio background keeper";
      break;
    }
    case PLBackgroundKeeperTypeLocation: {
      backgroundKeeperName = @"Location background keeper";
      break;
    }
    default:
      break;
  }
  switch (bgKeeperStatus) {
    case PLBackgroundKeeperStatusOn: {
      backgroundKeeperStatus = @"On";
      break;
    }
    case PLBackgroundKeeperStatusOff: {
      backgroundKeeperStatus = @"Off";
      break;
    }
  }
  [Logger info:[NSString stringWithFormat:@"%@ is %@", backgroundKeeperName, backgroundKeeperStatus]];
}


@end
