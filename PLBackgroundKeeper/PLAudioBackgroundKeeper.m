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

@end

@implementation PLAudioBackgroundKeeper

- (instancetype)init
{
  if (self = [super init]) {
    [self setupAudioSession];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"slience" ofType:@"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    [self.player prepareToPlay];
    self.player.volume = 0.01;
    self.player.numberOfLoops = -1;
  }
  return self;
}

- (void)setupAudioSession {
  AVAudioSession *audioSession = [AVAudioSession sharedInstance];
  NSError *error = nil;
  [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
  if (error) {
    NSLog(@"Error setCategory AVAudioSession: %@", error);
  }
  NSLog(@"%d", audioSession.isOtherAudioPlaying);
  NSError *activeSetError = nil;
  [audioSession setActive:YES error:&activeSetError];
  if (activeSetError) {
    NSLog(@"Error activating AVAudioSession: %@", activeSetError);
  }
}

- (void)start {
  [self.player play];
  [self applyForBackgroundTask];
  [self.player stop];
}

- (void)stop {
  [self.player stop];
  [self stopBackgroundTaskIfNeeded];
}

- (void)refresh {
  [self.player play];
  [self stopBackgroundTaskIfNeeded];
  [self applyForBackgroundTask];
  [self.player stop];
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
