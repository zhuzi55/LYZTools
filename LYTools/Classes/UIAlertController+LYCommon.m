//
//  UIAlertController+LYCommon.m
//  LYTools_Example
//
//  Created by liyz on 2023/1/6.
//  Copyright © 2023 zhuzi55. All rights reserved.
//

#import "UIAlertController+LYCommon.h"

@implementation UIAlertController (LYCommon)

/// 最简易的弹框
+(void)alertWithTitle:(NSString *)title Message:(NSString *)message FromVC:(UIViewController *)vc{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"好的 == ");
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消 == ");
    }];
    [alertVC addAction:okAction];
    [alertVC addAction:cancelAction];
    [vc presentViewController:alertVC animated:YES completion:nil];
    
}

/// 最简易的弹框-带回调事件
+(void)alertWithTitle:(NSString *)title Message:(NSString *)message FromVC:(UIViewController *)vc OKBlock:(void(^)(void))okBlock CancleBlock:(void(^)(void))cancleBlock{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (okBlock) {
            okBlock();
        }
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        if (cancleBlock) {
            cancleBlock();
        }
        
    }];
    [alertVC addAction:okAction];
    [alertVC addAction:cancelAction];
    [vc presentViewController:alertVC animated:YES completion:nil];
    
}

/// 弹框-可以自定义按钮文字等
+(void)alertWithTitle:(NSString *)title Message:(NSString *)message OKTitle:(NSString *)okTitle CancleTitle:(NSString *)cancleTitle FromVC:(UIViewController *)vc OKBlock:(void(^)(void))okBlock CancleBlock:(void(^)(void))cancleBlock{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (okBlock) {
            okBlock();
        }
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancleTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        if (cancleBlock) {
            cancleBlock();
        }
        
    }];
    [alertVC addAction:okAction];
    [alertVC addAction:cancelAction];
    [vc presentViewController:alertVC animated:YES completion:nil];
}

@end
