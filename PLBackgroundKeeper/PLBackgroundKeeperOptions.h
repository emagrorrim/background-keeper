//
//  PLBackgroundKeeperOptions.h
//  PLBackgroundKeeper
//
//  Created by Xin Guo  on 2019/6/21.
//  Copyright © 2019 org.emagrorrim. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
  PLBackgroundKeeperTypeAudio,
  PLBackgroundKeeperTypeLocation,
  PLBackgroundKeeperTypeAuto,
} PLBackgroundKeeperType;

NS_ASSUME_NONNULL_BEGIN

@interface PLBackgroundKeeperOptions : NSObject

@property (nonatomic, assign) PLBackgroundKeeperType bgKeeperType;
@property (nonatomic, assign) int pollingInterval;

- (instancetype)initWithBackgroundKeeperType:(PLBackgroundKeeperType)bgKeeperType
                             pollingInterval:(int)pollingInterval;

+ (PLBackgroundKeeperOptions *)defaultOptions;

@end

NS_ASSUME_NONNULL_END
