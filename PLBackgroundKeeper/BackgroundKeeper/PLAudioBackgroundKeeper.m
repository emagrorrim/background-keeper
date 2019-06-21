//
//  PLAudioBackgroundKeeper.m
//  PLBackgroundKeeper
//
//  Created by Xin Guo  on 2019/6/19.
//  Copyright © 2019 org.emagrorrim. All rights reserved.
//

#import "PLAudioBackgroundKeeper.h"

#import <AVFoundation/AVFoundation.h>

@interface PLAudioBackgroundKeeper ()

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, assign) UIBackgroundTaskIdentifier task;

@property (nonatomic, assign) BOOL isAvailable;

@end

@implementation PLAudioBackgroundKeeper

- (instancetype)init
{
  if (self = [super init]) {
    [self setupNotifications];
    _isAvailable = [self setupAudioSession];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"slience" ofType:@"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    [self.player prepareToPlay];
    self.player.volume = 0.01;
    self.player.numberOfLoops = -1;
  }
  return self;
}

- (void)setupNotifications {
  [NSNotificationCenter.defaultCenter addObserver:self
                                         selector:@selector(handleInterruption:)
                                             name:AVAudioSessionInterruptionNotification
                                           object:nil];
}

- (void)handleInterruption:(NSNotification *)notification {
  AVAudioSessionInterruptionType type = [notification.userInfo[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
  switch (type) {
    case AVAudioSessionInterruptionTypeBegan: {
      self.isAvailable = NO;
      break;
    }
    case AVAudioSessionInterruptionTypeEnded: {
      self.isAvailable = YES;
      break;
    }
  }
}

- (BOOL)setupAudioSession {
  AVAudioSession *audioSession = [AVAudioSession sharedInstance];
  NSError *error = nil;
  [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
  if (error) {
    NSLog(@"Error setCategory AVAudioSession: %@", error);
    return NO;
  }
  NSLog(@"%d", audioSession.isOtherAudioPlaying);
  NSError *activeSetError = nil;
  [audioSession setActive:YES error:&activeSetError];
  if (activeSetError) {
    NSLog(@"Error activating AVAudioSession: %@", activeSetError);
    return NO;
  }
  return YES;
}

- (BOOL)start {
  self.isAvailable = [self setupAudioSession];
  if (self.isAvailable) {
    [self.player play];
    [self applyForBackgroundTask];
    [self.player stop];
  }
  return self.isAvailable;
}

- (void)stop {
  [self.player stop];
  [self stopBackgroundTaskIfNeeded];
}

- (BOOL)refresh {
  self.isAvailable = [self setupAudioSession];
  if (self.isAvailable) {
    [self.player play];
    [self stopBackgroundTaskIfNeeded];
    [self applyForBackgroundTask];
    [self.player stop];
  }
  return self.isAvailable;
}

- (void)applyForBackgroundTask {
  self.task =[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    dispatch_async(dispatch_get_main_queue(), ^{
      [[UIApplication sharedApplication] endBackgroundTask:self.task];
      self.task = UIBackgroundTaskInvalid;
    });
  }];
}

- (void)stopBackgroundTaskIfNeeded {
  if (self.task && self.task != UIBackgroundTaskInvalid) {
    [[UIApplication sharedApplication] endBackgroundTask:self.task];
    self.task = UIBackgroundTaskInvalid;
  }
}

@end
