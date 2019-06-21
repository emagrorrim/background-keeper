//
//  Logger.m
//  PLBackgroundKeeper
//
//  Created by Xin Guo  on 2019/6/18.
//  Copyright © 2019 org.emagrorrim. All rights reserved.
//

#import "Logger.h"

static Logger *sharedLogger;

@interface Logger ()

@property (nonatomic, assign) int count;
@property (nonatomic, strong) NSDate *startDate;

@property (nonatomic, strong) UITextView *displayer;

@end

@implementation Logger

+ (Logger *)sharedLogger {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if (!sharedLogger) {
      sharedLogger = [[Logger alloc] init];
    }
  });
  return sharedLogger;
}

- (instancetype)init
{
  if (self = [super init]) {
    _count = 0;
    _startDate = [NSDate date];
    _displayer = [[UITextView alloc] initWithFrame:CGRectZero];
  }
  return self;
}

- (NSString *)prefix {
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  [df setDateFormat:@"HH:mm:ss"];
  return [NSString stringWithFormat:@"[%d][%@][%@]", self.count, [df stringFromDate:self.startDate], [df stringFromDate:[NSDate date]]];
}

+ (UITextView *)displayer {
  Logger *logger = [Logger sharedLogger];
  return logger.displayer;
}

+ (NSString *)info:(NSString *)info {
  Logger *logger = [Logger sharedLogger];
  NSString *msg = [[[logger prefix] stringByAppendingString:@" Info: "] stringByAppendingString:info];
  if (logger.displayer.text.length > 10000) {
    logger.displayer.text = @"";
  }
  logger.displayer.text = [[logger.displayer.text stringByAppendingString:msg] stringByAppendingString:@"\n"];
  NSLog(@"%@", msg);
  logger.count ++;
  return msg;
}

+ (NSString *)error:(NSString *)error {
  Logger *logger = [Logger sharedLogger];
  NSString *msg = [[[logger prefix] stringByAppendingString:@" Error: "] stringByAppendingString:error];
  if (logger.displayer.text.length > 10000) {
    logger.displayer.text = @"";
  }
  logger.displayer.text = [[logger.displayer.text stringByAppendingString:msg] stringByAppendingString:@"\n"];
  NSLog(@"%@", msg);
  logger.count ++;
  return msg;
}

@end
