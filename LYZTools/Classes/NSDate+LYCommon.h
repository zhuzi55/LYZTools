//
//  NSDate+LYCommon.h
//  LYZTools
//
//  Created by liyz on 2023/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (LYCommon)

// warn: [NSDate date]获取的是UTC时间，跟北京时间差8小时
// UTC 是世界标准时间，不属于任何时区
// 时间戳 是以 1970年1月1日 00：00：00 为参考标准，某个时间和它的差转换成秒，就是时间戳
// 时间戳应该是10位数，如果遇见了13位的时间戳，直接去掉前3位，因为这可能是精确到了毫秒

// G公元 yy年的后两位 yyyy完整年 MM月份 dd日 d日不带0
// aa上午下午 EEE简写星期 EEEE完整星期
// HH时24制 KK时12制 mm分 m分不带0 ss秒 s秒不带0 S毫秒

/// 获取当前时间戳 跟系统时间一致 即京八区
+(NSString *)getCurrentTimestamp;

/// 获取当前时间 指定格式 跟系统时间一致 即京八区
/// @"YYYY-MM-dd HH:mm:ss"
+(NSString *)getCurrentTimeWithFormatter:(NSString *)formatterStr;

/// 时间戳转指定格式
+(NSString *)getTimeWithTimestamp:(NSString *)timestamp Formatter:(NSString *)formatterStr;

/// 时间戳转为日期的显示(在一分钟内显示几秒前，在一小时内显示几分钟前，在一天内显示几小时前，在一周内显示几天前，否则显示具体年月日)
+(NSString *)getBeforeTimeWithTimestamp:(NSString *)timestamp;

/// 指定格式转时间戳
+(NSString *)getTimestampWithTime:(NSString *)time Fomatter:(NSString *)fomatterStr;

/// 时间转换为指定格式
+(NSString *)getTransferTimeWithTime:(NSString *)time;


@end

NS_ASSUME_NONNULL_END
