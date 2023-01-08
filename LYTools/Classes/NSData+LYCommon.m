//
//  NSData+LYCommon.m
//  LYTools
//
//  Created by liyz on 2023/1/7.
//

#import "NSData+LYCommon.h"

#include <CommonCrypto/CommonCrypto.h>

@implementation NSData (LYCommon)

/// MD5加密
- (NSString *)smy_md5String{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/// AES加密
- (NSData*)ly_encryptedWithAESUsingKey:(NSString*)key iv:(NSString*)iv{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ivData = [iv dataUsingEncoding:NSUTF8StringEncoding];
    return [self ly_AES:kCCEncrypt content:self key:keyData iv:ivData];
}
- (NSData *)ly_AES:(CCOperation)AESType content:(NSData *)content key:(NSData *)key iv:(NSData *)iv{

   if ([iv length] != 16) {
       @throw [NSException exceptionWithName:@"SMYEncrypt"
                                      reason:@"Length of iv is wrong. Length of iv should be 16(128bits)"
                                    userInfo:nil];
   }
   if ([key length] != 16 && [key length] != 24 && [key length] != 32 ) {
       @throw [NSException exceptionWithName:@"SMYEncrypt"
                                      reason:@"Length of key is wrong. Length of iv should be 16, 24 or 32(128, 192 or 256bits)"
                                    userInfo:nil];
   }

   // setup output buffer
   size_t bufferSize = [content length] + kCCBlockSizeAES128;
   void *buffer = malloc(bufferSize);

   // do encrypt
   size_t encryptedSize = 0;
   CCCryptorStatus cryptStatus = CCCrypt(AESType,
                                         kCCAlgorithmAES128,
                                         kCCOptionPKCS7Padding,
                                         [key bytes],     // Key
                                         [key length],    // kCCKeySizeAES
                                         [iv bytes],       // IV
                                         [content bytes],
                                         [content length],
                                         buffer,
                                         bufferSize,
                                         &encryptedSize);

    if (cryptStatus == kCCSuccess) {
        // 成功
        return [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
    }
    //释放
    free(buffer);

    return nil;

}

/// AES解密
- (NSData*)ly_decryptedWithAESUsingKey:(NSString*)key iv:(NSString*)iv{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ivData = [iv dataUsingEncoding:NSUTF8StringEncoding];
    return [self ly_AES:kCCDecrypt content:self key:keyData iv:ivData];
}

/// base64编码
- (NSString *)ly_base64EncodedString{
    return [self ly_base64EncodedStringWithWrapWidth:0];
}
- (NSString *)ly_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth{
    if (![self length]) return nil;
    NSString *encoded = nil;
#if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_9 || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (![NSData instancesRespondToSelector:@selector(base64EncodedStringWithOptions:)])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        encoded = [self base64Encoding];
#pragma clang diagnostic pop

    }
    else
#endif
    {
        switch (wrapWidth)
        {
            case 64:
            {
                return [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            }
            case 76:
            {
                return [self base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
            }
            default:
            {
                encoded = [self base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
            }
        }
    }
    if (!wrapWidth || wrapWidth >= [encoded length])
    {
        return encoded;
    }
    wrapWidth = (wrapWidth / 4) * 4;
    NSMutableString *result = [NSMutableString string];
    for (NSUInteger i = 0; i < [encoded length]; i+= wrapWidth)
    {
        if (i + wrapWidth >= [encoded length])
        {
            [result appendString:[encoded substringFromIndex:i]];
            break;
        }
        [result appendString:[encoded substringWithRange:NSMakeRange(i, wrapWidth)]];
        [result appendString:@"\r\n"];
    }
    return result;
}

/// hex
- (NSString *)ly_hexString{
    if (self.length == 0) { return nil; }
    
    static const char HexEncodeChars[] = "0123456789ABCDEF";
    char *resultData;
    // malloc result data
    resultData = malloc([self length] * 2 +1);
    // convert imgData(NSData) to char[]
    unsigned char *sourceData = ((unsigned char *)[self bytes]);
    NSUInteger length = [self length];
    
    for (NSUInteger index = 0; index < length; index++) {
        // set result data
        resultData[index * 2] = HexEncodeChars[(sourceData[index] >> 4)];
        resultData[index * 2 + 1] = HexEncodeChars[(sourceData[index] % 0x10)];
    }
    
    resultData[[self length] * 2] = 0;
    
    // convert result(char[]) to NSString
    NSString *result = [NSString stringWithCString:resultData encoding:NSASCIIStringEncoding];
    sourceData = nil;
    free(resultData);
    
    return result;
}

/// base64编码
+ (NSData *)ly_dataWithBase64EncodedString:(NSString *)string{
    if (![string length]) return nil;
    NSData *decoded = nil;
#if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_9 || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (![NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        decoded = [[self alloc] initWithBase64Encoding:[string stringByReplacingOccurrencesOfString:@"[^A-Za-z0-9+/=]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [string length])]];
#pragma clang diagnostic pop
    }
    else
#endif
    {
        decoded = [[self alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    return [decoded length]? decoded: nil;
}

/// utf8编码
- (NSString *)ly_utf8String{
    NSString *result = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    return result;
}

@end
