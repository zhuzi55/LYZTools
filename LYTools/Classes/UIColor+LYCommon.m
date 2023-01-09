//
//  UIColor+LYCommon.m
//  LYTools
//
//  Created by liyz on 2023/1/6.
//

#import "UIColor+LYCommon.h"

@implementation UIColor (LYCommon)

/// 随机颜色
+ (UIColor *)ly_randomColor{
    
    int R = (arc4random() % 256) ; // [0,256)里取随机数
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
    return [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:1];
    
}

/// 加载十六进制颜色 -  三种形式都支持 0xFFFFFF #FFFFFF FFFFFF
+ (UIColor *)ly_colorWithHexString:(NSString *)hexStr{
    return [self ly_colorWithHexString:hexStr Alpha:1.0];
}
+(UIColor *)ly_colorWithHexString:(NSString *)hexStr Alpha:(CGFloat)alpha{
    
    NSString *cString = [[hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 取六位颜色值
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];

}

@end
