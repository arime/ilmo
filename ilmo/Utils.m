//
//  Utils.m
//  ilmo
//
//  Created by Ari Metsähalme on 10/27/12.
//
//

#import "Utils.h"
#include <CommonCrypto/CommonDigest.h>

@implementation Utils

+(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+(id) formattedObjectForKey:(NSString*)key from:(NSDictionary*)dict
{
    return [dict objectForKey:key];
}

@end
