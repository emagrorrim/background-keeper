//
//  Logger.h
//  PLBackgroundKeeper
//
//  Created by Xin Guo  on 2019/6/18.
//  Copyright © 2019 org.emagrorrim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Logger : NSObject

+ (NSString *)info:(NSString *)info;
+ (NSString *)error:(NSString *)error;

@end

NS_ASSUME_NONNULL_END
