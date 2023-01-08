//
//  UIColor+LYCommon.h
//  LYTools
//
//  Created by liyz on 2023/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (LYCommon)

/// 随机颜色
+ (UIColor *)ly_randomColor;

/// 加载十六进制颜色 -  三种形式都支持 0xFFFFFF #FFFFFF FFFFFF
+ (UIColor *)ly_colorWithHexString:(NSString *)hexStr;


@end

NS_ASSUME_NONNULL_END
