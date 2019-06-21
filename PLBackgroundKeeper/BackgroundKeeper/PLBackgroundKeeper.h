//
//  PLBackgroundKeeper.h
//  PLBackgroundKeeper
//
//  Created by Xin Guo on 2019/6/18.
//  Copyright © 2019 org.emagrorrim. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PLBackgroundKeeperOptions;
typedef NS_ENUM(NSUInteger, PLBackgroundKeeperType);
typedef NS_ENUM(NSUInteger, PLBackgroundKeeperStatus);

NS_ASSUME_NONNULL_BEGIN

@protocol PLBackgroundKeeperDelegate <NSObject>

- (void)backgroundKeeperDidRefreshed;
- (void)backgroundKeeper:(PLBackgroundKeeperType)bgKeeperType didChangedToStatus:(PLBackgroundKeeperStatus)bgKeeperStatus;

@end

@interface PLBackgroundKeeper : NSObject

@property (nonatomic, weak) id<PLBackgroundKeeperDelegate> delegate;
@property (nonatomic, strong) PLBackgroundKeeperOptions *options;

- (instancetype)initWithOptions:(PLBackgroundKeeperOptions *)options;

- (void)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
