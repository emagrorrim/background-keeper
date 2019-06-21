//
//  PLAudioBackgroundKeeper.h
//  PLBackgroundKeeper
//
//  Created by Xin Guo  on 2019/6/19.
//  Copyright © 2019 org.emagrorrim. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLAudioBackgroundKeeper : NSObject

- (BOOL)start;
- (void)stop;
- (BOOL)refresh;

@end

NS_ASSUME_NONNULL_END
