//
//  PLBackgroundKeeper.h
//  PLBackgroundKeeper
//
//  Created by Xin Guo on 2019/6/18.
//  Copyright © 2019 org.emagrorrim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLBackgroundKeeper : NSObject

- (void)setupEnv;
- (void)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
