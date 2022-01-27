//
//  IMYAppGrayStyle.h
//  IMYAppGrayStyle
//
//  Created by ljh on 2022/1/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMYAppGrayStyle : NSObject

/// 开启全局变灰
+ (void)open;

/// 关闭全局变灰
+ (void)close;

/// 添加灰色模式
+ (void)addToView:(UIView *)view;

/// 移除灰色模式
+ (void)removeFromView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
