//
//  NSString+LYCommon.m
//  LYTools
//
//  Created by liyz on 2023/1/6.
//

#import "NSString+LYCommon.h"

#import "NSData+LYCommon.h"


@implementation NSString (LYCommon)

/// 判断字符串是否为空 - 非空YES 空NO
+(BOOL)ly_isNotNull:(id)object{
    
    if ([object isEqual:[NSNull null]]){
        return NO;
    }else if ([object isKindOfClass:[NSNull class]]){
        return NO;
    }else if (object==nil){
        return NO;
    }else if ([object isKindOfClass:[NSString class]]){
        if ([[object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
            return NO;
        }
    }
    return YES;
    
}

/// 对字符串进行非空处理 - 如果空返回@""
+(NSString *)ly_convertNull:(id)object{
    
    if ([object isEqual:@"NULL"] || [object isKindOfClass:[NSNull class]] || [object isEqual:[NSNull null]] || [object isEqual:NULL] || [[object class] isSubclassOfClass:[NSNull class]] || object == nil || object == NULL ){
        return @"";
    }
    if ([object isKindOfClass:[NSString class]]){
        if ([object isEqualToString:@"<null>"] || [object isEqualToString:@"(null)"]){
            return @"";
        } else{
            return [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
    }
    if ([object isKindOfClass:[NSNumber class]]){
        return [NSString stringWithFormat:@"%@",object];
    }
    return @"";
    
}

/// 生成指定位数的随机字符串 - 数字+字母
+(NSString *)ly_randomlyGeneratedStringWithLenth:(NSInteger)lenth{
    
//    NSString *resultStr = [[NSString alloc] init];
//    for (int i = 0; i < lenth; i++){
//        int number = arc4random() % 36; // 数字10+字母26
//        if (number < 10){
//            int figure = arc4random() % 10; // 0-10取数字
//            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
//            resultStr = [resultStr stringByAppendingString:tempString];
//        } else {
//            int figure = (arc4random() % 26) + 97; // 10-36取字母
//            char character = figure;
//            NSString *tempString = [NSString stringWithFormat:@"%c", character];
//            resultStr = [resultStr stringByAppendingString:tempString];
//        }
//    }
//    return resultStr;
    static NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < lenth; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
    
}

/// 图形验证码随机值
+(NSString *)ly_randomlyGeneratedImgCode{
    
    static int kNumber = 4;
    static NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
    
}

/// url编码
/// 编码前 https://www.哈哈.com
/// 编码后 https%3A//www.%E5%93%88%E5%93%88.com
/// unicode与中文转化 https://www.哈哈.com   -- https://www.\u54C8\u54C8.com
-(NSString *)ly_URLEncodedString{
    
    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@";
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet *allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < self.length) {
            NSUInteger length = MIN(self.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            range = [self rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [self substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;
    } else {
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)self,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
    }

}

/// url解码
-(NSString *)ly_URLDecodedString{
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]){
        return [self stringByRemovingPercentEncoding];
    } else {
        CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+"
                                                            withString:@" "];
        decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                NULL,
                                                                (__bridge CFStringRef)decoded,
                                                                CFSTR(""),
                                                                en);
        return decoded;
    }

}

/// 是否是邮箱
-(BOOL)ly_isEmailAddress{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
    
}

/// 是否是手机号
-(BOOL)ly_isMobileNumber{
    
    NSString *tempMobile = self;
    tempMobile = [tempMobile stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // 手机号位数不是11位
    if (tempMobile.length != 11) {
        return NO;
    }
    tempMobile = [tempMobile stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    // 手机号不是纯数字
    if (tempMobile.length >0) {
        return NO;
    }
    return YES;
    
}

/// 用户名
-(BOOL)ly_isUserName{
    
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL result = [userNamePredicate evaluateWithObject:self];
    return result;
    
}

/// 用户昵称效验
-(BOOL)ly_isUserNickName{
    
    if ([self isEqualToString:@""]){
        return YES;
    } else {
        NSString *eSymbol = @"[-`=\\[\\];',./~!@#$%^&*()_+{}|:\"<>?`~！@#￥%……&*（）——+{}|：“《》？`【】、；’。、，\\\\]";
        NSString *cEx = @"[\u4e00-\u9fa5]+";//中文
        NSString *eEx = @"[0-9a-zA-Z]+";//英文
        NSString *nineEx = @"[➋➌➍➎➏➐➑➒…”/]+";//九宫格
        NSPredicate *eSymobl_Pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",eSymbol];
        NSPredicate *cEx_Pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",cEx];
        NSPredicate *eEx_Pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",eEx];
        NSPredicate *nineEx_pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nineEx];
        if([eSymobl_Pre evaluateWithObject:self]||
           [cEx_Pre evaluateWithObject:self]||
           [eEx_Pre evaluateWithObject:self]||
           [nineEx_pre evaluateWithObject:self]
           ){
            return YES;
        } else {
            return NO;
        }
    }
    
}

/// 是否是密码规则
-(BOOL)ly_isPassword{
    
    //设置密码强度限制，如大小写字母、数字、特殊符号至少四选三，长度不少于 8-16 位。
    NSString *passWordRegex = @"^(?![a-zA-Z]+$)(?![A-Z0-9]+$)(?![A-Z\\W_]+$)(?![a-z0-9]+$)(?![a-z\\W_]+$)(?![0-9\\W_]+$)[a-zA-Z0-9\\W_]{8,16}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    BOOL result =[passWordPredicate evaluateWithObject:self];
    return result;

}

/// 身份证号
-(BOOL)ly_isIdentityCardNum{
    
    NSString *idCard = self;
    // 新身份证长度
    int newIDLen = 18;
    BOOL isNew =(idCard.length == newIDLen);
    
    if (![self checkLength:idCard newIDFlag:isNew]) {
        return NO;
    }
    NSString *idDate =[self getIDDate:idCard newIDFlag:isNew];
    if (![ self checkDate:idDate] ) {
        return NO;
    }
    if (isNew) {
        NSString *checkFlag =[self getCheckFlag:idCard];
        NSString *theFlag =[idCard substringWithRange:NSMakeRange(idCard.length -1,1)];
        if (![checkFlag isEqualToString:theFlag]) {
            return NO;
        }
    }else{
        return NO;
    }
    return YES;
    
}
// 获取新身份证的最后一位:检验位
- (NSString *)getCheckFlag:(NSString *)idCard{
    NSString *CheckCode = @"10X98765432";
    int sum = 0;
    int fMod =11;
    NSMutableArray *Wi =[[NSMutableArray alloc] init];
    
    //初始化wi［］数组
    for (int i=0; i< 17; i++) {
        int k =(int)pow(2, 17 -i);
        [ Wi addObject: [NSNumber numberWithInt:k%fMod]];
    }
    
    // 进行加权求和
    for (int i = 0; i < 17; i++) {
        sum += [[idCard substringWithRange:NSMakeRange(i, 1)] intValue]*[Wi[i] intValue];
        
    }
    // 取模运算，得到模值
    int iCode = sum % fMod;
    return [CheckCode substringWithRange:NSMakeRange(iCode, 1)];
}
//身份证号码效验，长度
- (BOOL)checkLength:(NSString *)idCard newIDFlag:(BOOL)newIDFlag{
    int oldIDLen = 15;
    int newIDLen = 18;
    BOOL right =(idCard.length ==oldIDLen)||(idCard.length ==newIDLen);
    newIDFlag =false;
    if (right) {
        newIDFlag =(idCard.length ==newIDLen);
    }
    return right;
}
// 获取时间串
- (NSString *)getIDDate:(NSString *)idCard newIDFlag:(BOOL)newIDFlag{
    NSMutableString *dateStr =[[NSMutableString alloc] init];
    int fPart = 6;  // 身份证前部分字符数
    NSString *yearFlag =@"19"; // 新身份证年份标志
    
    if (newIDFlag){
        //NSString *s = [@"123456789012345678" substringWithRange:NSMakeRange(2,4)];
        dateStr =[NSMutableString stringWithString:[idCard substringWithRange:NSMakeRange(fPart,8)]];
    }else{
        dateStr =[NSMutableString stringWithFormat:@"%@%@",yearFlag,[idCard substringWithRange:NSMakeRange(fPart,6)]];
    }
    return dateStr;
}
// 判断时间合法性
- (BOOL)checkDate:(NSString *)dateSource {
    NSString *dateStr =[NSString stringWithFormat:@"%@-%@-%@",[dateSource substringWithRange:NSMakeRange(0, 4)],[dateSource substringWithRange:NSMakeRange(4, 2)],[dateSource substringWithRange:NSMakeRange(6,2)]];
    
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFormatter.timeZone=[[NSTimeZone alloc]initWithName:@"GMT"];
    NSDate *date =[dateFormatter dateFromString:dateStr];
    @try {
        return (date != nil);
    }
    @catch (NSException *exception) {
        return NO;
    }
}

/// 判断是不是网络地址
-(BOOL)ly_isValidUrl{
    
    NSString *urlRegexChar = @"^(https://|http://)[\\s\\S]*";
    NSPredicate *urlPassWordPredicateChar = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",urlRegexChar];
    BOOL result = [urlPassWordPredicateChar evaluateWithObject:self];
    return result;
    
}

/// 纯汉字
-(BOOL)ly_isValidChinese{
    
    NSString *chineseRegex = @"^[\u4e00-\u9fa5]+$";
    NSPredicate *chinesePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",chineseRegex];
    BOOL result = [chinesePredicate evaluateWithObject:self];
    return result;
    
}

/// 是否包含汉字
-(BOOL)ly_isValidIncludeChinese{
    
    NSString *passWord = self;
    BOOL isChinese = NO;
    for(NSInteger i=0; i< [passWord length];i++) {
        NSInteger a = [passWord characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) {
            //判断输入的是否是中文
            isChinese = YES;
        }
    }
    return isChinese;
    
}

/// 姓名脱敏
-(NSString *)ly_realNameDesensitization{
    
    NSString *realName = self;
    NSInteger realNameLength = realName.length;
    if (realNameLength > 1) {
        NSString *star = [@"" stringByPaddingToLength:1 withString: @"*" startingAtIndex:0];
        NSString *realNameStarString = [realName stringByReplacingCharactersInRange:NSMakeRange(0, 1)  withString:star];
        realName = realNameStarString;
    }
    return realName;
    
}

/// 手机号脱敏
-(NSString *)ly_mobilePhoneDesensitization{
    
    NSString *mobilePhone = self;
    NSInteger mobilePhoneLength = mobilePhone.length;
    if (mobilePhoneLength > 10) {
        NSString *star = [@"" stringByPaddingToLength:4 withString: @"*" startingAtIndex:0];
        NSString *mobilePhoneStarString = [mobilePhone stringByReplacingCharactersInRange:NSMakeRange(3, 4)  withString:star];
        mobilePhone = mobilePhoneStarString;
    }
    return mobilePhone;
    
}

/// 身份证号脱敏
-(NSString *)ly_idCardDesensitization{
    
    NSString *idCard = self;
    NSInteger idCardLength = idCard.length;
    if (idCardLength > 2) {
        NSString *star = [@"" stringByPaddingToLength:idCardLength-2 withString: @"*" startingAtIndex:0];
        NSString *idCardStarString = [idCard stringByReplacingCharactersInRange:NSMakeRange(1, idCard.length-2)  withString:star];
        idCard = idCardStarString;
    }
    return idCard;
    
}

/// 银行卡号脱敏
-(NSString *)ly_bankCardDesensitization{
    
    NSString *bankCard = self;
    NSInteger bankCardLength = bankCard.length;
    if (bankCardLength > 10) {
        NSString *star = [@"" stringByPaddingToLength:bankCardLength-10 withString: @"*" startingAtIndex:0];
        NSString *bankCardStarString = [bankCard stringByReplacingCharactersInRange:NSMakeRange(6, bankCard.length-10)  withString:star];
        bankCard = bankCardStarString;
    }
    return bankCard;
    
}

/// 家庭地址脱敏
-(NSString *)ly_homeAddressDesensitization{
    
    NSString *homeAddress = self;
    NSInteger homeAddressLength = homeAddress.length;
    if (homeAddressLength > 2&&homeAddressLength<=8) {
        NSString *star = [@"" stringByPaddingToLength:homeAddressLength-2 withString: @"*" startingAtIndex:0];
        NSString *mobilePhoneStarString = [homeAddress stringByReplacingCharactersInRange:NSMakeRange(0, homeAddress.length-2)  withString:star];
        homeAddress = mobilePhoneStarString;
    }else if (homeAddressLength>8){
        NSString *star = [@"" stringByPaddingToLength:homeAddressLength-4 withString: @"*" startingAtIndex:0];
        NSString *mobilePhoneStarString = [homeAddress stringByReplacingCharactersInRange:NSMakeRange(0, homeAddress.length-4)  withString:star];
        homeAddress = mobilePhoneStarString;
    }
    return homeAddress;
    
}

/// md5加密
-(NSString *)ly_md5String{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] ly_md5String];
}

/// AES加密
/// @param key 长度一般为16（AES算法所能支持的密钥长度可以为128,192,256位（也即16，24，32个字节））
/// @param iv iv
/// @param resultBase64 YES 返回base64字符串 ,NO返回hex字符串
-(NSString *)ly_encryptedAESUsingKey:(NSString*)key iv:(NSString *)iv ResultBase64:(BOOL)resultBase64{
    
    NSData *encryptedData = [[self dataUsingEncoding:NSUTF8StringEncoding] ly_encryptedWithAESUsingKey:key iv:iv];
    NSString *encryptedString;
    if (resultBase64){
        encryptedString = [encryptedData ly_base64EncodedString];
    } else {
        encryptedString = [encryptedData ly_hexString];
    }
    return encryptedString;
}

/// AES解密
- (NSString *)ly_decryptedAESUsingKey:(NSString*)key iv:(NSString*)iv{
    
    NSData *decrypted = [[NSData ly_dataWithBase64EncodedString:self] ly_decryptedWithAESUsingKey:key iv:iv];
    NSString *decryptedString = [decrypted ly_utf8String];
    return decryptedString;
    
}

/// RSA加密
+(NSString *)ly_encryptRSAString:(NSString *)str publicKey:(NSString *)pubKey{
    NSData *data = [self encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] publicKey:pubKey];
    NSString *ret = [data ly_base64EncodedString];
    return ret;
}
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey{
    if(!data || !pubKey){
        return nil;
    }
    SecKeyRef keyRef = [self addPublicKey:pubKey];
    if(!keyRef){
        return nil;
    }
    return [self encryptData:data withKeyRef:keyRef];
}
+ (NSData *)encryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(keyRef,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", (int)status);
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}
+ (SecKeyRef)addPublicKey:(NSString *)key{
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = [NSData ly_dataWithBase64EncodedString:key];
    data = [self stripPublicKeyHeader:data];
    if(!data){
        return nil;
    }
#if TARGET_OS_IOS && !defined(APP_SMYWIDGET_EXTENSIONS)

    @synchronized ([UIApplication sharedApplication]) {
        
#endif
    //a tag to read/write keychain storage
    NSString *tag = @"RSA_Until_PubKeyKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);
    
    // Add persistent version of the key to system keychain
    [publicKey setObject:data forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
#if TARGET_OS_IOS && !defined(APP_SMYWIDGET_EXTENSIONS)

    }
#endif
}
+ (NSData *)stripPublicKeyHeader:(NSData *)d_key{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    // Now make a new NSData from this buffer
    return ([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}


/// RSA解密
+(NSString *)ly_decryptRSAString:(NSString *)str privateKey:(NSString *)privKey{
    if (!str) return nil;
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [self decryptData:data privateKey:privKey];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}
+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey{
    if(!data || !privKey){
        return nil;
    }
    SecKeyRef keyRef = [self addPrivateKey:privKey];
    if(!keyRef){
        return nil;
    }
    return [self decryptData:data withKeyRef:keyRef];
}
+ (SecKeyRef)addPrivateKey:(NSString *)key{
    NSRange spos = [key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = [NSData ly_dataWithBase64EncodedString:key];
    data = [self stripPrivateKeyHeader:data];
    if(!data){
        return nil;
    }
#if TARGET_OS_IOS && !defined(APP_SMYWIDGET_EXTENSIONS)

    @synchronized ([UIApplication sharedApplication]) {
#endif
    //a tag to read/write keychain storage
    NSString *tag = @"RSA_Until_PrivateKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *privateKey = [[NSMutableDictionary alloc] init];
    [privateKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [privateKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)privateKey);
    
    // Add persistent version of the key to system keychain
    [privateKey setObject:data forKey:(__bridge id)kSecValueData];
    [privateKey setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id)
     kSecAttrKeyClass];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)privateKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [privateKey removeObjectForKey:(__bridge id)kSecValueData];
    [privateKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
#if TARGET_OS_IOS && !defined(APP_SMYWIDGET_EXTENSIONS)

    }
#endif
}
+ (NSData *)stripPrivateKeyHeader:(NSData *)d_key{
    // Skip ASN.1 private key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 22; //magic byte at offset 22
    
    if (0x04 != c_key[idx++]) return nil;
    
    //calculate length of the key
    unsigned int c_len = c_key[idx++];
    int det = c_len & 0x80;
    if (!det) {
        c_len = c_len & 0x7f;
    } else {
        int byteCount = c_len & 0x7f;
        if (byteCount + idx > len) {
            //rsa length field longer than buffer
            return nil;
        }
        unsigned int accum = 0;
        unsigned char *ptr = &c_key[idx];
        idx += byteCount;
        while (byteCount) {
            accum = (accum << 8) + *ptr;
            ptr++;
            byteCount--;
        }
        c_len = accum;
    }
    
    // Now make a new NSData from this buffer
    return [d_key subdataWithRange:NSMakeRange(idx, c_len)];
}
+ (NSData *)decryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8 *outbuf = malloc(block_size);
    size_t src_block_size = block_size;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyDecrypt(keyRef,
                               kSecPaddingNone,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", (int)status);
            ret = nil;
            break;
        }else{
            //the actual decrypted data is in the middle, locate it!
            int idxFirstZero = -1;
            int idxNextZero = (int)outlen;
            for ( int i = 0; i < outlen; i++ ) {
                if ( outbuf[i] == 0 ) {
                    if ( idxFirstZero < 0 ) {
                        idxFirstZero = i;
                    } else {
                        idxNextZero = i;
                        break;
                    }
                }
            }
            
            [ret appendBytes:&outbuf[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

/// 计算宽度
-(CGFloat)ly_getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    return [self ly_getSizeWithFont:font constrainedToSize:size].width;
}

/// 计算高度
-(CGFloat)ly_getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    return [self ly_getSizeWithFont:font constrainedToSize:size].height;
}
- (CGSize)ly_getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    CGSize resultSize = CGSizeZero;
    if (self.length <= 0) {
        return resultSize;
    }
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    resultSize = [self boundingRectWithSize:CGSizeMake(floor(size.width), floor(size.height))//用相对小的 width 去计算 height / 小 heigth 算 width
                                    options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                 attributes:@{NSFontAttributeName: font,
                                              NSParagraphStyleAttributeName: style}
                                    context:nil].size;
    resultSize = CGSizeMake(floor(resultSize.width + 1), floor(resultSize.height + 1));//上面用的小 width（height） 来计算了，这里要 +1
    return resultSize;
}


@end
