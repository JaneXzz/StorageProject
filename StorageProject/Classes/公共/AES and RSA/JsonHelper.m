#ifndef __JSON_HELPER_SOURCE__
#define __JSON_HELPER_SOURCE__

#include "JsonHelper.h"

#ifdef __cplusplus
extern "C" {
#endif
    static id jsonObject(NSData* data)
    {
        NSError* error = nil;
        if (data) {
            NSUInteger length = [data length];
            if (length > 0) {
                const char* bytes = (const char*)[data bytes];
                if (bytes[length-1] == 0) {
                    data = [data subdataWithRange:NSMakeRange(0, length-1)];
                }
            }
            id ptrJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            return ptrJson;
        } else {
            return nil;
        }
    }
    
    NSMutableDictionary* JsonHelperDictionaryFromData(NSData* data)
    {
        NSMutableDictionary* ptrJson = jsonObject(data);
        if (![ptrJson isKindOfClass:[NSDictionary class]])
            ptrJson = nil;
        return ptrJson;
    }
    
    NSMutableArray* JsonHelperArrayFromData(NSData* data)
    {
        NSMutableArray* ptrJson = jsonObject(data);
        if (![ptrJson isKindOfClass:[NSArray class]])
            ptrJson = nil;
        return ptrJson;
    }
    
    NSMutableDictionary* JsonHelperDictionaryFromString(NSString* str)
    {
        if ([str isKindOfClass:[NSString class]])
            return JsonHelperDictionaryFromData([str dataUsingEncoding:NSUTF8StringEncoding]);
        return nil;
    }
    NSMutableArray* JsonHelperArrayFromString(NSString* str)
    {
        if ([str isKindOfClass:[NSString class]])
            return JsonHelperArrayFromData([str dataUsingEncoding:NSUTF8StringEncoding]);
        return nil;
        
    }

    NSString* JsonHelperToString(id object)
    {
        @try {
            NSData* data = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
            if (data) {
                return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
        return nil;
    }


    NSDictionary* JsonHelperGetJson(NSDictionary* jvParent, NSString* szKey)
    {
        if (![jvParent isKindOfClass:[NSDictionary class]]) return nil;
        
        NSObject* value = [jvParent valueForKey:szKey];
        if ([value isKindOfClass:[NSDictionary class]])
            return (NSDictionary*)value;
        return nil;
    }
    
    NSString* JsonHelperGetString(NSDictionary* jvParent, NSString* szKey, NSString* defaultValue)
    {
        if (![jvParent isKindOfClass:[NSDictionary class]]) return defaultValue;
        
        NSObject* value = [jvParent valueForKey:szKey];
        if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]])
            return defaultValue;
        
        if ([value isKindOfClass:[NSString class]])
            return (NSString*)value;
        
        if ([value isKindOfClass:[NSNull class]])
            return defaultValue;
        
        if (value)
            return [NSString stringWithFormat:@"%@", value];
        
        return defaultValue;
    }
    
    BOOL JsonHelperGetBool(NSDictionary* jvParent, NSString* szKey)
    {
        if (![jvParent isKindOfClass:[NSDictionary class]]) return NO;
        
        NSObject* value = [jvParent valueForKey:szKey];
        if ([value respondsToSelector:@selector(boolValue)])
            return [(NSNumber*)value boolValue];
        return NO;
    }
    int JsonHelperGetInt(NSDictionary* jvParent, NSString* szKey, int defaultValue)
    {
        if (![jvParent isKindOfClass:[NSDictionary class]]) return defaultValue;
        
        NSObject* value = [jvParent valueForKey:szKey];
        if ([value respondsToSelector:@selector(intValue)])
            return [(NSNumber*)value intValue];
        return defaultValue;
    }
    float JsonHelperGetFloat(NSDictionary* jvParent, NSString* szKey, float defaultValue) {
        if (![jvParent isKindOfClass:[NSDictionary class]]) return defaultValue;
        
        NSObject* value = [jvParent valueForKey:szKey];
        if ([value respondsToSelector:@selector(floatValue)])
            return [(NSNumber*)value floatValue];
        return defaultValue;
    }

    int64_t JsonHelperGetLong(NSDictionary* jvParent, NSString* szKey, int64_t defaultValue)
    {
        if (![jvParent isKindOfClass:[NSDictionary class]]) return defaultValue;
        
        NSObject* value = [jvParent valueForKey:szKey];
        if ([value respondsToSelector:@selector(longLongValue)])
            return [(NSNumber*)value longLongValue];
        return defaultValue;
    }
    NSArray* JsonHelperGetArray(NSDictionary* jvParent, NSString* szKey)
    {
        NSObject* value = [jvParent valueForKey:szKey];
        if ([value isKindOfClass:[NSArray class]])
            return (NSArray*)value;
        return nil;
    }
    
    
    id JsonHelperGetStringData(NSDictionary* jvParent, NSString* szKey)
    {
        if (![jvParent isKindOfClass:[NSDictionary class]]) return nil;
        
        NSObject* value = [jvParent valueForKey:szKey];
        if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]])
            return nil;
        
        if ([value isKindOfClass:[NSString class]])
            return (NSString*)value;
        
        if ([value isKindOfClass:[NSNull class]])
            return value;
        
        if (value)
            return [NSString stringWithFormat:@"%@", value];
        
        return nil;
    }
    
    NSNumber* JsonHelperGetIntData(NSDictionary* jvParent, NSString* szKey)
    {
        if (![jvParent isKindOfClass:[NSDictionary class]]) return nil;
        
        NSObject* value = [jvParent valueForKey:szKey];
        if ([value respondsToSelector:@selector(intValue)])
            return @([(NSNumber*)value intValue]);
        return nil;
    }
    
    NSNumber* JsonHelperGetFloatData(NSDictionary* jvParent, NSString* szKey)
    {
        if (![jvParent isKindOfClass:[NSDictionary class]]) return nil;
        
        NSObject* value = [jvParent valueForKey:szKey];
        if ([value respondsToSelector:@selector(floatValue)])
            return @([(NSNumber*)value floatValue]);
        return nil;
    }
    
    NSNumber* JsonHelperGetLongData(NSDictionary* jvParent, NSString* szKey)
    {
        if (![jvParent isKindOfClass:[NSDictionary class]]) return nil;
        
        NSObject* value = [jvParent valueForKey:szKey];
        if ([value respondsToSelector:@selector(longLongValue)])
            return @([(NSNumber*)value longLongValue]);
        return nil;
    }


#ifdef __cplusplus
}
#endif

#endif
