//
//  PLBackgroundKeeper.m
//  PLBackgroundKeeper
//
//  Created by Xin Guo on 2019/6/18.
//  Copyright © 2019 org.emagrorrim. All rights reserved.
//

#import "PLBackgroundKeeper.h"

#import <UIKit/UIKit.h>

#import "PLBackgroundKeeperOptions.h"
#import "PLLocationBackgroundKeeper.h"
#import "PLAudioBackgroundKeeper.h"

@interface PLBackgroundKeeper ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CFRunLoopRef runLoopRef;
@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, strong) PLLocationBackgroundKeeper *locationBGKeeper;
@property (nonatomic, strong) PLAudioBackgroundKeeper *audioBGKeeper;

@property (nonatomic, assign) PLBackgroundKeeperOptions *options;

@end

@implementation PLBackgroundKeeper

- (instancetype)init {
  if (self = [super init]) {
    [self commonInit];
    _options = [PLBackgroundKeeperOptions defaultOptions];
  }
  return self;
}

- (instancetype)initWithOptions:(PLBackgroundKeeperOptions *)options
{
  if (self = [super init]) {
    [self commonInit];
    _options = options;
  }
  return self;
}

- (void)commonInit {
  _locationBGKeeper = [[PLLocationBackgroundKeeper alloc] init];
  _audioBGKeeper = [[PLAudioBackgroundKeeper alloc] init];
  _queue = dispatch_queue_create("com.background", NULL);
}

- (void)start {
  switch (self.options.bgKeeperType) {
    case PLBackgroundKeeperTypeAuto: {
      if (![self.audioBGKeeper start]) {
        [self.locationBGKeeper start];
      }
      break;
    }
    case PLBackgroundKeeperTypeAudio: {
      [self.locationBGKeeper stop];
      [self.audioBGKeeper start];
      break;
    }
    case PLBackgroundKeeperTypeLocation: {
      [self.audioBGKeeper stop];
      [self.locationBGKeeper start];
      break;
    }
  }

  dispatch_async(self.queue, ^{
    self.timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:self.options.pollingInterval target:self selector:@selector(refreshBackgroundKeeper) userInfo:nil repeats:YES];
    self.runLoopRef = CFRunLoopGetCurrent();
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    CFRunLoopRun();
  });
}

- (void)refreshBackgroundKeeper {
  dispatch_async(dispatch_get_main_queue(), ^{
    if ([[UIApplication sharedApplication] backgroundTimeRemaining] < self.options.pollingInterval + 1) {
      NSLog(@"%@", [NSString stringWithFormat:@"剩余可执行时间小于轮询时间(%ds) -> 剩余：%f", self.options.pollingInterval, [[UIApplication sharedApplication] backgroundTimeRemaining]]);
    } else {
      NSLog(@"%@", [NSString stringWithFormat:@"剩余可执行时间大于于轮询时间(%ds) -> 剩余：%f", self.options.pollingInterval, [[UIApplication sharedApplication] backgroundTimeRemaining]]);
    }
    switch (self.options.bgKeeperType) {
      case PLBackgroundKeeperTypeAuto: {
        if ([self.audioBGKeeper refresh]) {
          [self.locationBGKeeper stop];
        } else {
          [self.locationBGKeeper start];
          [self.locationBGKeeper refresh];
        }
        break;
      }
      case PLBackgroundKeeperTypeAudio: {
        [self.audioBGKeeper refresh];
        break;
      }
      case PLBackgroundKeeperTypeLocation: {
        [self.locationBGKeeper refresh];
        break;
      }
    }
  });
}

- (void)stop {
  [self stopAllBGKeeper];
  CFRunLoopStop(self.runLoopRef);
  [self.timer invalidate];
  self.timer = nil;
}

- (void)stopAllBGKeeper {
  [self.locationBGKeeper stop];
  [self.audioBGKeeper stop];
}

@end
