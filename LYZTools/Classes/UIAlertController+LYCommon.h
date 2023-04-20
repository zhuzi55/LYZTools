//
//  UIAlertController+LYCommon.h
//  LYTools_Example
//
//  Created by liyz on 2023/1/6.
//  Copyright © 2023 zhuzi55. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (LYCommon)

/// 最简易的弹框
+(void)alertWithTitle:(NSString *)title Message:(NSString *)message FromVC:(UIViewController *)vc;

/// 最简易的弹框-带回调事件
+(void)alertWithTitle:(NSString *)title Message:(NSString *)message FromVC:(UIViewController *)vc OKBlock:(void(^)(void))okBlock CancleBlock:(void(^)(void))cancleBlock;

/// 弹框-可以自定义按钮文字等
+(void)alertWithTitle:(NSString *)title Message:(NSString *)message OKTitle:(NSString *)okTitle CancleTitle:(NSString *)cancleTitle FromVC:(UIViewController *)vc OKBlock:(void(^)(void))okBlock CancleBlock:(void(^)(void))cancleBlock;

@end

NS_ASSUME_NONNULL_END
