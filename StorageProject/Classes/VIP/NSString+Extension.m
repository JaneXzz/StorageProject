//
//  NSString+Extension.m
//  豆豆计算器
//
//  Created by 1 on 2019/7/24.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

#pragma mark --- 截取小数点
+(NSString *)stringDisposeWithDouble:(double)doubleValue{
    NSString *stringNumber = [NSString stringWithFormat:@"%f",doubleValue];
    //不包含.证明为整数,所以需要添加.00
    if([stringNumber rangeOfString:@"."].location == NSNotFound){
        NSString* string_comp = [NSString stringWithFormat:@"%@.00",stringNumber];
        return string_comp;
    }else{
        NSArray* arrays= [stringNumber componentsSeparatedByString:@"."];
        NSString* s_f= [arrays objectAtIndex:0];
        NSString* s_e = [arrays objectAtIndex:1];
        if(s_e.length>2) {
            s_e=[s_e substringWithRange:NSMakeRange(0,2)];
        }else if(s_e.length==1){
            s_e=[NSString stringWithFormat:@"%@0",s_e];
        }
        NSString* string_combine = [NSString stringWithFormat:@"%@.%@",s_f,s_e];
        return string_combine;
    }
    return @"";
}

+(BOOL)isBlankString:(NSString *)aStr {
    aStr = [NSString stringWithFormat:@"%@",aStr];
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!aStr.length) {
        return YES;
    }
    if ([aStr isEqualToString:@"(null)"]) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    
    return NO;
}

+ (NSString *)uuid{
    // create a new UUID which you own
    CFUUIDRef uuidref = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    CFStringRef uuid = CFUUIDCreateString(kCFAllocatorDefault, uuidref);
    
    NSString *result = (__bridge NSString *)uuid;
    //release the uuidref
    CFRelease(uuidref);
    // release the UUID
    CFRelease(uuid);
    
    return result;
}

@end
