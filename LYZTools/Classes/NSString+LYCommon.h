//
//  NSString+LYCommon.h
//  LYTools
//
//  Created by liyz on 2023/1/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LYCommon)

/// 判断字符串是否为空 - 非空YES 空NO
+(BOOL)ly_isNotNull:(id)object;

/// 对字符串进行非空处理 - 如果空返回@""
+(NSString *)ly_convertNull:(id)object;

/// 生成指定位数的随机字符串 - 数字+大小写字母
+(NSString *)ly_randomlyGeneratedStringWithLenth:(NSInteger)lenth;

/// 图形验证码随机值 4位 包括数字+大小写字母
+(NSString *)ly_randomlyGeneratedImgCode;

/// url编码
-(NSString *)ly_URLEncodedString;

/// url解码
-(NSString *)ly_URLDecodedString;

#pragma mark - 常用的正则表达式
/// 是否是邮箱
-(BOOL)ly_isEmailAddress;

/// 是否是手机号
-(BOOL)ly_isMobileNumber;

/// 用户名
-(BOOL)ly_isUserName;

/// 用户昵称效验
-(BOOL)ly_isUserNickName;

/// 是否是密码规则 - 大小写字母+数字+特殊符号至少四选三，长度不少于 8-16 位
-(BOOL)ly_isPassword;

/// 身份证号
-(BOOL)ly_isIdentityCardNum;

/// 判断是不是网络地址
-(BOOL)ly_isValidUrl;

/// 纯汉字
-(BOOL)ly_isValidChinese;

/// 是否包含汉字
-(BOOL)ly_isValidIncludeChinese;

#pragma mark - 常用脱敏
/// 姓名脱敏 - 第一个字脱敏 *国庆
-(NSString *)ly_realNameDesensitization;

/// 手机号脱敏 第三到四位脱敏 199----5878
-(NSString *)ly_mobilePhoneDesensitization;

/// 身份证号脱敏 除了首尾，中间都脱敏 4---------------------5
-(NSString *)ly_idCardDesensitization;

/// 银行卡号脱敏 除了前六后四，中间都脱敏  110257----------8055
-(NSString *)ly_bankCardDesensitization;

/// 家庭地址脱敏 除了后四位，前面都脱敏 -------------------李家坝村
-(NSString *)ly_homeAddressDesensitization;

#pragma mark - 加解密 MD5 AES RSA
/// md5加密 32位
-(NSString *)ly_md5String;

/// sha1加密 40位
-(NSString *)ly_sha1String;

/// sha256加密 64位
-(NSString *)ly_sha256String;

/// sha512加密 128位
-(NSString *)ly_sha512String;

/// AES加密
/// @param key 长度一般为16（AES算法所能支持的密钥长度可以为128,192,256位（也即16，24，32个字节））
/// @param iv iv
/// @param resultBase64 YES 返回base64字符串 ,NO返回hex字符串
-(NSString *)ly_encryptedAESUsingKey:(NSString*)key iv:(NSString *)iv ResultBase64:(BOOL)resultBase64;

/// AES解密
- (NSString *)ly_decryptedAESUsingKey:(NSString*)key iv:(NSString*)iv;

/// RSA加密
+(NSString *)ly_encryptRSAString:(NSString *)str publicKey:(NSString *)pubKey;

/// RSA解密
+(NSString *)ly_decryptRSAString:(NSString *)str privateKey:(NSString *)privKey;

#pragma mark - 字符串计算
/// 计算宽度
-(CGFloat)ly_getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

/// 计算高度
-(CGFloat)ly_getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

#pragma mark - 其他方法
/// json字符串转字典
+(NSDictionary *)ly_dictionaryWithJSONString:(NSString *)jsonString;

/// 字典转json字符串
+(NSString *)ly_JSONStringWithDictionary:(NSDictionary *)dic;

#pragma mark - 富文本字符串
/// 指定文字指定颜色 (如：还没有账号？注册)
+(NSMutableAttributedString *)setAttriText:(NSString *)attriText Color:(UIColor *)color FirstText:(NSString *)firstText FirstColor:(UIColor *)firstCorlor;

/// 指定一处文字指定颜色和大小 ( 如：0.00(lovc) )
+(NSMutableAttributedString *)setAttriText:(NSString *)attriText Color:(UIColor *)color Font:(CGFloat)font FirstText:(NSString *)firstText FirstColor:(UIColor *)firstCorlor FirstFont:(CGFloat)firstFont;

/// 传font进来，可加粗
+(NSMutableAttributedString *)setAttBoldText:(NSString *)attriText Color:(UIColor *)color Font:(UIFont *)font FirstText:(NSString *)firstText FirstColor:(UIColor *)firstCorlor FirstFont:(UIFont *)firstFont;

/// 指定两处文字指定颜色和大小 ( 如：1.00 eth ≈ 6.66 lovc )
+(NSMutableAttributedString *)setAttriText:(NSString *)attriText Color:(UIColor *)color Font:(CGFloat)font FirstText:(NSString *)firstText FirstColor:(UIColor *)firstCorlor FirstFont:(CGFloat)firstFont SecondtText:(NSString *)secondText SecondColor:(UIColor *)secondCorlor SecondFont:(CGFloat)secondFont;



@end

NS_ASSUME_NONNULL_END
