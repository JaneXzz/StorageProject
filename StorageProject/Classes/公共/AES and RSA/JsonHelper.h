#ifndef __JSON_HELPER_H__
#define __JSON_HELPER_H__

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif
    NSMutableDictionary* JsonHelperDictionaryFromData(NSData* data);
    NSMutableArray* JsonHelperArrayFromData(NSData* data);
    
    NSMutableDictionary* JsonHelperDictionaryFromString(NSString* str);
    NSMutableArray* JsonHelperArrayFromString(NSString* str);
    
    NSString* JsonHelperToString(id object);
    NSDictionary* JsonHelperGetJson(NSDictionary* jvParent, NSString* szKey);
    BOOL JsonHelperGetBool(NSDictionary* jvParent, NSString* szKey);
    NSString* JsonHelperGetString(NSDictionary* jvParent, NSString* szKey, NSString* defaultValue);
    int JsonHelperGetInt(NSDictionary* jvParent, NSString* szKey, int defaultValue);
    float JsonHelperGetFloat(NSDictionary* jvParent, NSString* szKey, float defaultValue);
    int64_t JsonHelperGetLong(NSDictionary* jvParent, NSString* szKey, int64_t defaultValue);
    NSArray* JsonHelperGetArray(NSDictionary* jvParent, NSString* szKey);

    
    id JsonHelperGetStringData(NSDictionary* jvParent, NSString* szKey);
    NSNumber* JsonHelperGetIntData(NSDictionary* jvParent, NSString* szKey);
    NSNumber* JsonHelperGetFloatData(NSDictionary* jvParent, NSString* szKey);
    NSNumber* JsonHelperGetLongData(NSDictionary* jvParent, NSString* szKey);
    
#ifdef __cplusplus
}
#endif

#endif
