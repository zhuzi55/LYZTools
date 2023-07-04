//
//  LYZTool.h
//  LYZTools
//
//  Created by liyz on 2023/7/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//用于定位或位置回调
typedef void(^LocationBlock) (NSDictionary *dict);

@interface LYZTool : NSObject

//单例获取对象
+(instancetype)sharedInstance;

-(void)getLocationWithCallback:(LocationBlock)locationBlock;

-(void)getAddressWithCallback:(LocationBlock)locationBlock;


@end

NS_ASSUME_NONNULL_END
