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

/**
 * @description Init with PLBackgroundKeeperOptions
 * @param options contains the BG Keeper type and Polling Interval which is an int.
 */
- (instancetype)initWithOptions:(PLBackgroundKeeperOptions *)options;

/**
 * The background keeper will start corresponding background keeper according to the options
 * eg.
 * If we choose to use Audio, it will start audio bg keeper, if you choose location, it will
 * start location bg keeper.
 *
 * If you choose to use Auto/not setting the options, it will choose the availiable bg keeper
 * and close another. The audio bg keeper has higher priority than location bg keeper and it
 * will only start location bg keeper when audio bg keeper is not availiable.
 */
- (void)start;

/// Stop all bg keepers
- (void)stop;

@end

NS_ASSUME_NONNULL_END
