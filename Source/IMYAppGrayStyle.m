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

+ (void)showInWindow:(UIWindow *)window {
    for (UIView *subview in window.subviews) {
        if ([subview isKindOfClass: IMYAppGrayStyleCoverView.class]) {
            // 已有灰色蒙版，不再追加
            return;
        }
    }
    IMYAppGrayStyleCoverView *coverView = [[self alloc] initWithFrame:window.bounds];
    coverView.userInteractionEnabled = NO;
    coverView.backgroundColor = [UIColor lightGrayColor];
    coverView.layer.compositingFilter = @"saturationBlendMode";
    coverView.layer.zPosition = FLT_MAX;
    [window addSubview:coverView];
    
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
            [IMYAppGrayStyleCoverView showInWindow:window];
        }
    }
}

+ (void)close {
    NSAssert(NSThread.isMainThread, @"必须在主线程调用!");
    for (UIView *coverView in IMYAppGrayStyleCoverView.allCoverViews) {
        [coverView removeFromSuperview];
    }
}

@end
