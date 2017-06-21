//
//  NSString+Hash.m
//
//  Created by Tom Corwine on 5/30/12.
//

#import "NSString+Hash.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (Hash)

- (NSString *)md5String
{
	const char *string = self.UTF8String;
	int length = (int)strlen(string);
	unsigned char bytes[CC_MD5_DIGEST_LENGTH];
	CC_MD5(string, length, bytes);
	return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}
#pragma mark - Helpers

- (NSString *)stringFromBytes:(unsigned char *)bytes length:(int)length
{
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < length; i++)
        [mutableString appendFormat:@"%02x", bytes[i]];
    return [NSString stringWithString:mutableString];
}


@end
