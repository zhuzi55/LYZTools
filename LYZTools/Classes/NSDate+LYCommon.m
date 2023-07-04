//
//  NSDate+LYCommon.m
//  LYZTools
//
//  Created by liyz on 2023/6/30.
//

#import "NSDate+LYCommon.h"

@implementation NSDate (LYCommon)

/// 获取当前时间戳
+(NSString *)getCurrentTimestamp{
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval stamp = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f", stamp];
    
}

/// 获取当前时间 指定格式
+(NSString *)getCurrentTimeWithFormatter:(NSString *)formatterStr{
    
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterStr];
    NSString *timeStr = [formatter stringFromDate:nowDate];
    return timeStr;
    
}

/// 时间戳转指定格式
+(NSString *)getTimeWithTimestamp:(NSString *)timestamp Formatter:(nonnull NSString *)formatterStr{
    
    double time = [timestamp doubleValue];
    NSDate *myDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:formatterStr];
    NSString *timeStr=[formatter stringFromDate:myDate];
    
    // 如果有上午下午 默认是PM AM
    if([timeStr containsString:@"AM"]){
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"AM" withString:@"上午"];
    }
    if([timeStr containsString:@"PM"]){
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"PM" withString:@"下午"];
    }
    // 如果有星期 默认是 Monday
    if([timeStr containsString:@"Monday"]){
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"Monday" withString:@"星期一"];
    }
    if([timeStr containsString:@"Tuesday"]){
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"Tuesday" withString:@"星期二"];
    }
    if([timeStr containsString:@"Wednesday"]){
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"Wednesday" withString:@"星期三"];
    }
    if([timeStr containsString:@"Thursday"]){
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"Thursday" withString:@"星期四"];
    }
    if([timeStr containsString:@"Friday"]){
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"Friday" withString:@"星期五"];
    }
    if([timeStr containsString:@"Saturday"]){
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"Saturday" withString:@"星期六"];
    }
    if([timeStr containsString:@"Sunday"]){
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"Sunday" withString:@"星期日"];
    }
    return timeStr;
    
}

/// 时间戳转为日期的显示(在一分钟内显示几秒前，在一小时内显示几分钟前，在一天内显示几小时前，在一周内显示几天前，否则显示具体年月日)
+(NSString *)getBeforeTimeWithTimestamp:(NSString *)timestamp{
    // 计算现在距1970年多少秒
    NSDate *date = [NSDate date];
    NSTimeInterval currentTime= [date timeIntervalSince1970];
    // 计算现在的时间和发布消息的时间时间差
    double timeDiffence = currentTime - timestamp.doubleValue;
    // 根据秒数的时间差的不同，返回不同的日期格式
    if (timeDiffence <= 60) {
        return [NSString stringWithFormat:@"%.0f 秒前",timeDiffence];
    }else if (timeDiffence <= 3600){
        return [NSString stringWithFormat:@"%.0f 分钟前",timeDiffence / 60];
    }else if (timeDiffence <= 86400){
        return [NSString stringWithFormat:@"%.0f 小时前",timeDiffence / 3600];
    }else if (timeDiffence <= 604800){
        return [NSString stringWithFormat:@"%.0f 天前",timeDiffence / 3600 /24];
    }else{
        NSDate *oldTimeDate = [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        return [formatter stringFromDate:oldTimeDate];
    }
}


/// 指定格式转时间戳
+(NSString *)getTimestampWithTime:(NSString *)time Fomatter:(nonnull NSString *)fomatterStr{
    
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    fomatter.dateFormat = fomatterStr;
    NSDate *date = [fomatter  dateFromString:time];
    NSTimeInterval stamp = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f", stamp];
    
}

/// 时间转换为指定格式
+(NSString *)getTransferTimeWithTime:(NSString *)time{
    NSString *nextTime = time;
    NSArray *timeArray = [time componentsSeparatedByString:@":"];
    if (timeArray.count > 1) {
        nextTime = [NSString stringWithFormat:@"%@:%@", timeArray[0], timeArray[1]];
    }
    return nextTime;
}


@end
