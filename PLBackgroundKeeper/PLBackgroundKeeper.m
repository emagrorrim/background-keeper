//
//  PLBackgroundKeeper.m
//  PLBackgroundKeeper
//
//  Created by Xin Guo on 2019/6/18.
//  Copyright © 2019 org.emagrorrim. All rights reserved.
//

#import "PLBackgroundKeeper.h"

#import <UIKit/UIKit.h>

#import "PLLocationBackgroundKeeper.h"
#import "PLAudioBackgroundKeeper.h"

const int POLLING_DURATION = 20;

@interface PLBackgroundKeeper ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CFRunLoopRef runLoopRef;
@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, strong) PLLocationBackgroundKeeper *locationBGKeeper;
@property (nonatomic, strong) PLAudioBackgroundKeeper *audioBGKeeper;

@end

@implementation PLBackgroundKeeper

- (instancetype)init
{
  if (self = [super init]) {
    _locationBGKeeper = [[PLLocationBackgroundKeeper alloc] init];
    _audioBGKeeper = [[PLAudioBackgroundKeeper alloc] init];
    _queue = dispatch_queue_create("com.background", NULL);
  }
  return self;
}

- (void)start {
//  [self.locationBGKeeper start];
  [self.audioBGKeeper start];
  dispatch_async(self.queue, ^{
    self.timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:POLLING_DURATION target:self selector:@selector(backgroundChecking) userInfo:nil repeats:YES];
    self.runLoopRef = CFRunLoopGetCurrent();
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    CFRunLoopRun();
  });
}

- (void)backgroundChecking {
  dispatch_async(dispatch_get_main_queue(), ^{
    if ([[UIApplication sharedApplication] backgroundTimeRemaining] < POLLING_DURATION + 1) {
      NSLog(@"%@", [NSString stringWithFormat:@"剩余可执行时间小于轮询时间(%ds) -> 剩余：%f", POLLING_DURATION, [[UIApplication sharedApplication] backgroundTimeRemaining]]);
      [self.audioBGKeeper refresh];
    } else {
      NSLog(@"%@", [NSString stringWithFormat:@"剩余可执行时间大于于轮询时间(%ds) -> 剩余：%f", POLLING_DURATION, [[UIApplication sharedApplication] backgroundTimeRemaining]]);
    }
//    [self.locationBGKeeper refresh];
  });
}

- (void)stop {
//  [self.locationBGKeeper stop];
  [self.audioBGKeeper stop];
  CFRunLoopStop(self.runLoopRef);
  [self.timer invalidate];
  self.timer = nil;
}

@end
