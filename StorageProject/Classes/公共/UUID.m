//
//  UUID.m
//  豆豆计算器
//
//  Created by 1 on 2019/10/29.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "UUID.h"
#import "KeyChainStore.h"
#import "LoginPublic.h"

@implementation UUID

+(NSString*)getUUID {
    
    NSString*strUUID = (NSString*)[KeyChainStore load:KEY_UUID];
    //首次执行该方法时，uuid为空
    if([strUUID isEqualToString:@""]|| !strUUID)
    { //生成一个uuid的方法
        CFUUIDRef uuidRef= CFUUIDCreate(kCFAllocatorDefault);

        strUUID = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault,uuidRef));
        //将该uuid保存到keychain
        [KeyChainStore save:KEY_UUID data:strUUID];
    }
    return strUUID;
    
}
 
@end
