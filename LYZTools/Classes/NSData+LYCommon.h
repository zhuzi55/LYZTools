//
//  NSData+LYCommon.h
//  LYTools
//
//  Created by liyz on 2023/1/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (LYCommon)

/// MD5加密
- (NSString *)ly_md5String;

/// AES加密
- (NSData*)ly_encryptedWithAESUsingKey:(NSString*)key iv:(NSString*)iv;

/// AES解密
- (NSData*)ly_decryptedWithAESUsingKey:(NSString*)key iv:(NSString*)iv;

/// base64编码
- (NSString *)ly_base64EncodedString;

/// hex
- (NSString *)ly_hexString;

/// base64编码
+ (NSData *)ly_dataWithBase64EncodedString:(NSString *)string;

/// utf8编码
- (NSString *)ly_utf8String;

@end

NS_ASSUME_NONNULL_END
