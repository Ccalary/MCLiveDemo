//
//  NSString+Extend.m
//  JzyTest
//
//  Created by 姜志远 on 2017/5/27.
//  Copyright © 2017年 姜志远. All rights reserved.
//

#import "NSString+Extend.h"

#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(Encrypt)


-(NSString *)AES256EncryptWithKey:(NSString *)key {
    
    NSData *selfdata = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [selfdata length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCKeySizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [selfdata bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        selfdata = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
        selfdata = [GTMBase64 encodeData:selfdata];
        return [[NSString alloc] initWithData:selfdata encoding:NSUTF8StringEncoding];
    }
    
    free(buffer); //free the buffer;
    return nil;
    
}

-(NSString *)AES256DecryptWithKey:(NSString *)key {
    
    
    NSData *selfdata = [GTMBase64 decodeString:self];;
    
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [selfdata length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [selfdata bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        selfdata = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        return [[NSString alloc] initWithData:selfdata encoding:NSUTF8StringEncoding];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (NSString *)md5 {
    
    
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result );
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
- (NSString*) sha1
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}
@end

@implementation NSString (JSON)

-(NSDictionary *)jsonDeserialize
{
    NSDictionary* dict;
    if (self && ![self isKindOfClass:[NSNull class]] && ![self isEqualToString:@""] ) {
        NSError * parseError = nil;
        dict = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&parseError];
        return dict;
    }else {
        return dict;
    }
}

@end

@implementation NSString (Extend)

-(NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
@implementation NSString (Valid)

-(BOOL)isMobile
{
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[1][34578][0-9]{9}$"];
    if ([regextestcm evaluateWithObject:self] == YES)
    {
        return YES;
    }
    else {
        return NO;
    }
}
-(BOOL)isEmail
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end

@implementation NSString (Encode)


//URLEncode
- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                    (CFStringRef)self,
                                                                                                    (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                                                    NULL,
                                                                                                    kCFStringEncodingUTF8));
    return encodedString;
}
- (NSString *)URLDecodedString
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}


@end
@implementation NSString (UILabel_Font)


- (CGSize)sizeWithFont:(UIFont *)font {
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    
    return [self sizeWithAttributes:attributes];
}

- (CGSize)sizeWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setValue:font forKey:NSFontAttributeName];
    [attributes setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    return [self sizeWithAttributes:attributes];
}

- (CGSize)sizeWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing maxSize:(CGSize)maxSize {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setValue:font forKey:NSFontAttributeName];
    [attributes setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}

- (NSAttributedString *)getAttributedStringWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setValue:font forKey:NSFontAttributeName];
    [attributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [attributes setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self attributes:attributes];
    
    return attributedString;
}


@end
