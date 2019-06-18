//
//  PLBackgroundKeeper.m
//  PLBackgroundKeeper
//
//  Created by Xin Guo on 2019/6/18.
//  Copyright © 2019 org.emagrorrim. All rights reserved.
//

#import "PLBackgroundKeeper.h"

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "PLLocationBackgroundKeeper.h"

const int POLLING_DURATION = 20;

@interface PLBackgroundKeeper ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CFRunLoopRef runLoopRef;
@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, strong) PLLocationBackgroundKeeper *locationBGKeeper;

@end

@implementation PLBackgroundKeeper

- (instancetype)init
{
  if (self = [super init]) {
    _locationBGKeeper = [[PLLocationBackgroundKeeper alloc] init];
    _queue = dispatch_queue_create("com.background", NULL);
  }
  return self;
}

- (void)start {
  [self.locationBGKeeper start];
  dispatch_async(self.queue, ^{
    self.timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:POLLING_DURATION target:self selector:@selector(backgroundChecking) userInfo:nil repeats:YES];
    self.runLoopRef = CFRunLoopGetCurrent();
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
  });
}

- (void)backgroundChecking {
  dispatch_async(dispatch_get_main_queue(), ^{
    if ([[UIApplication sharedApplication] backgroundTimeRemaining] < POLLING_DURATION + 1) {
      NSLog(@"后台快被杀死了");
    } else {
      NSLog(@"后台继续活跃呢");
    }
    [self.locationBGKeeper refresh];
  });
}

- (void)stop {
  [self.locationBGKeeper stop];
  CFRunLoopStop(self.runLoopRef);
  [self.timer invalidate];
  self.timer = nil;
}

@end
