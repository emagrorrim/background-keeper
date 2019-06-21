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
#import "PLBackgroundKeeperStatus.h"

@interface PLBackgroundKeeper ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CFRunLoopRef runLoopRef;
@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, strong) PLLocationBackgroundKeeper *locationBGKeeper;
@property (nonatomic, strong) PLAudioBackgroundKeeper *audioBGKeeper;

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
        [self notifyDelegateLocationBGKeeperIsOn];
      } else {
        [self notifyDelegateAudioBGKeeperIsOn];
      }
      break;
    }
    case PLBackgroundKeeperTypeAudio: {
      [self.locationBGKeeper stop];
      [self.audioBGKeeper start];
      [self notifyDelegateAudioBGKeeperIsOn];
      break;
    }
    case PLBackgroundKeeperTypeLocation: {
      [self.audioBGKeeper stop];
      [self.locationBGKeeper start];
      [self notifyDelegateLocationBGKeeperIsOn];
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
    switch (self.options.bgKeeperType) {
      case PLBackgroundKeeperTypeAuto: {
        if ([self.audioBGKeeper refresh]) {
          [self.locationBGKeeper stop];
          [self notifyDelegateAudioBGKeeperIsOn];
        } else {
          [self.locationBGKeeper start];
          [self.locationBGKeeper refresh];
          [self notifyDelegateLocationBGKeeperIsOn];
        }
        break;
      }
      case PLBackgroundKeeperTypeAudio: {
        [self.audioBGKeeper refresh];
        [self notifyDelegateAudioBGKeeperIsOn];
        break;
      }
      case PLBackgroundKeeperTypeLocation: {
        [self.locationBGKeeper refresh];
        [self notifyDelegateLocationBGKeeperIsOn];
        break;
      }
    }
    [self.delegate backgroundKeeperDidRefreshed];
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
  [self notifyDelegateBothLocationAndAudioBGKeeperIsOff];
}

- (void)notifyDelegateAudioBGKeeperIsOn {
  [self.delegate backgroundKeeper:PLBackgroundKeeperTypeLocation didChangedToStatus:PLBackgroundKeeperStatusOff];
  [self.delegate backgroundKeeper:PLBackgroundKeeperTypeAudio didChangedToStatus:PLBackgroundKeeperStatusOn];
}

- (void)notifyDelegateLocationBGKeeperIsOn {
  [self.delegate backgroundKeeper:PLBackgroundKeeperTypeLocation didChangedToStatus:PLBackgroundKeeperStatusOn];
  [self.delegate backgroundKeeper:PLBackgroundKeeperTypeAudio didChangedToStatus:PLBackgroundKeeperStatusOff];
}

- (void)notifyDelegateBothLocationAndAudioBGKeeperIsOff {
  [self.delegate backgroundKeeper:PLBackgroundKeeperTypeLocation didChangedToStatus:PLBackgroundKeeperStatusOff];
  [self.delegate backgroundKeeper:PLBackgroundKeeperTypeAudio didChangedToStatus:PLBackgroundKeeperStatusOff];
}

@end
