//
//  UIImage+LYCommon.h
//  LYTools
//
//  Created by liyz on 2023/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LYCommon)

/// 根据颜色生成图片
+(UIImage *)ly_createImageWithColor:(UIColor*)color;

/// 渲染模式调整 - 始终绘制图片原始状态,不使用Tint Color
+(UIImage *)ly_imageOriginalWithName:(NSString *)imageName;

/// 压缩图片大小
-(NSData *)ly_createImageDataWithMaxImageSize:(CGFloat)maxImageSize maxSizeKB:(CGFloat)maxSizeKB;



@end

NS_ASSUME_NONNULL_END
