//
//  UIImage+LYCommon.m
//  LYTools
//
//  Created by liyz on 2023/1/6.
//

#import "UIImage+LYCommon.h"

@implementation UIImage (LYCommon)

/// 根据颜色生成图片
+(UIImage *)ly_createImageWithColor:(UIColor*)color{
    
    CGRect rect = CGRectMake(0, 0, 50, 50);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
    
}

/// 渲染模式调整 - 始终绘制图片原始状态,不使用Tint Color
+(UIImage *)ly_imageOriginalWithName:(NSString *)imageName{
    
    UIImage *theImage = [UIImage imageNamed:imageName];
    return [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

/// 压缩图片大小
-(NSData *)ly_createImageDataWithMaxImageSize:(CGFloat)maxImageSize maxSizeKB:(CGFloat)maxSizeKB{
    
    if (maxSizeKB <= 0.0) maxSizeKB = 1024.0;
    if (maxImageSize <= 0.0) maxImageSize = 1024.0;
    //先调整分辨率
    CGSize newSize = CGSizeMake(self.size.width, self.size.height);
    CGFloat tempHeight = newSize.height / maxImageSize;
    CGFloat tempWidth = newSize.width / maxImageSize;
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(self.size.width / tempWidth, self.size.height / tempWidth);
    } else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(self.size.width / tempHeight, self.size.height / tempHeight);
    }
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    CGFloat sizeOriginKB = imageData.length / 1024.0;
    CGFloat resizeRate = 0.9;
    while (sizeOriginKB > maxSizeKB && resizeRate > 0.1) {
        imageData = UIImageJPEGRepresentation(newImage,resizeRate);
        sizeOriginKB = imageData.length / 1024.0;
        resizeRate -= 0.1;
    }
    return imageData;
    
}

///  图片转base64
+(NSString *)ly_base64StrWithImage:(UIImage *)img{
    
    NSData *imgData = UIImageJPEGRepresentation(img, 1);
    return [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
}

/// base64转图片
+(UIImage *)ly_imageWithBase64Str:(NSString *)base64Str{
    
    NSData *imgData = [[NSData alloc]initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:imgData];
    
}

@end
