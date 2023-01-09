//
//  UIView+LYCommon.m
//  LYTools
//
//  Created by liyz on 2023/1/6.
//

#import "UIView+LYCommon.h"

@implementation UIView (LYCommon)

#pragma mark - 快速访问UIView的Frame
-(CGFloat)ly_x{
    return self.frame.origin.x;
}
-(void)setLy_x:(CGFloat)ly_x{
    CGRect frame = self.frame;
    frame.origin.x = ly_x;
    self.frame = frame;
}

-(CGFloat)ly_y{
    return self.frame.origin.y;
}
-(void)setLy_y:(CGFloat)ly_y{
    CGRect frame = self.frame;
    frame.origin.y = ly_y;
    self.frame = frame;
}

-(CGFloat)ly_centerX{
    return self.center.x;
}

-(void)setLy_centerX:(CGFloat)ly_centerX{
    CGPoint center = self.center;
    center.x = ly_centerX;
    self.center = center;
}

-(CGFloat)ly_centerY{
    return self.center.y;
}

-(void)setLy_centerY:(CGFloat)ly_centerY{
    CGPoint center = self.center;
    center.y = ly_centerY;
    self.center = center;
}

-(CGFloat)ly_width{
    return self.frame.size.width;
}

-(void)setLy_width:(CGFloat)ly_width{
    CGRect frame = self.frame;
    frame.size.width = ly_width;
    self.frame = frame;
}

-(CGFloat)ly_height {
    return self.frame.size.height;
}

-(void)setLy_height:(CGFloat)ly_height{
    CGRect frame = self.frame;
    frame.size.height = ly_height;
    self.frame = frame;
}

-(CGSize)ly_size{
    return self.frame.size;
}

-(void)setLy_size:(CGSize)ly_size{
    CGRect frame = self.frame;
    frame.size = ly_size;
    self.frame = frame;
}

-(CGPoint)ly_origin {
    return self.frame.origin;
}

-(void)setLy_origin:(CGPoint)ly_origin{
    CGRect frame = self.frame;
    frame.origin = ly_origin;
    self.frame = frame;
}

@end
