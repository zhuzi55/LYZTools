//
//  UIView+LYCommon.h
//  LYTools
//
//  Created by liyz on 2023/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LYCommon)

#pragma mark - 快速访问UIView的Frame
@property (nonatomic, assign) CGFloat ly_x;
@property (nonatomic, assign) CGFloat ly_y;
@property (nonatomic, assign) CGFloat ly_width;
@property (nonatomic, assign) CGFloat ly_height;

@property (nonatomic, assign) CGFloat ly_centerX;
@property (nonatomic, assign) CGFloat ly_centerY;
@property (nonatomic, assign) CGSize ly_size;
@property (nonatomic, assign) CGPoint ly_origin;

@end

NS_ASSUME_NONNULL_END
