//
//  IMYAppGrayStyle.m
//  IMYAppGrayStyle
//
//  Created by ljh on 2022/1/27.
//

#import "IMYAppGrayStyle.h"

@interface IMYAppGrayStyleCoverView : UIView

@end

@implementation IMYAppGrayStyleCoverView

+ (NSHashTable *)allCoverViews {
    static NSHashTable *array;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = [NSHashTable weakObjectsHashTable];
    });
    return array;
}

+ (void)showInMaskerView:(UIView *)maskerView {
    if (!@available(iOS 13, *)) {
        // iOS13 之前系统不支持
        return;
    }
    
    // 遍历是否已添加 gray cover view
    for (UIView *subview in maskerView.subviews) {
        if ([subview isKindOfClass:IMYAppGrayStyleCoverView.class]) {
            return;
        }
    }
    
    IMYAppGrayStyleCoverView *coverView = [[self alloc] initWithFrame:maskerView.bounds];
    coverView.userInteractionEnabled = NO;
    coverView.backgroundColor = [UIColor lightGrayColor];
    coverView.layer.compositingFilter = @"saturationBlendMode";
    coverView.layer.zPosition = FLT_MAX;
    [maskerView addSubview:coverView];
    
    [self.allCoverViews addObject:coverView];
}

@end

@implementation IMYAppGrayStyle

+ (void)open {
    NSAssert(NSThread.isMainThread, @"必须在主线程调用!");
    NSMutableSet *windows = [NSMutableSet set];
    [windows addObjectsFromArray:UIApplication.sharedApplication.windows];
    if (@available(iOS 13, *)) {
        for (UIWindowScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if (![scene isKindOfClass:UIWindowScene.class]) {
                continue;
            }
            [windows addObjectsFromArray:scene.windows];
        }
    }
    // 遍历所有window，给它们加上蒙版
    for (UIWindow *window in windows) {
        NSString *className = NSStringFromClass(window.class);
        if (![className containsString:@"UIText"]) {
            [IMYAppGrayStyleCoverView showInMaskerView:window];
        }
    }
}

+ (void)close {
    NSAssert(NSThread.isMainThread, @"必须在主线程调用!");
    for (UIView *coverView in IMYAppGrayStyleCoverView.allCoverViews) {
        [coverView removeFromSuperview];
    }
}

+ (void)addToView:(UIView *)view {
    [IMYAppGrayStyleCoverView showInMaskerView:view];
}

+ (void)removeFromView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:IMYAppGrayStyleCoverView.class]) {
            [subview removeFromSuperview];
        }
    }
}

@end
