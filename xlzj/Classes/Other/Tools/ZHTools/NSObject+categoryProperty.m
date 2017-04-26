//
//  NSObject+categoryProperty.m
//  sunflower
//
//  Created by Karsa wang on 10/20/14.
//  Copyright (c) 2014 shenbin. All rights reserved.
//

#import "NSObject+categoryProperty.h"
#import <objc/runtime.h>

static NSMutableDictionary *categoryPropertyDic = nil;

@implementation NSObject (categoryProperty)

- (NSString *)hashKey {
    return [NSNumber numberWithUnsignedInteger:[self hash]].description;
}

- (void)setObjectPropertyValue:(id)value forKey:(id <NSCopying>)key {
    if (!value) {
        return;
    }
    NSMutableDictionary *propertyMap = [categoryPropertyDic objectForKey:[self hashKey]];
    if (!propertyMap) {
        propertyMap = [NSMutableDictionary dictionary];
    }
    propertyMap = [NSMutableDictionary dictionaryWithDictionary:propertyMap];
    [propertyMap setObject:value forKey:key];
    if (!categoryPropertyDic) {
        categoryPropertyDic = [NSMutableDictionary dictionary];
    }
    [categoryPropertyDic setObject:propertyMap forKey:[self hashKey]];
}
- (id)objectPropertyValueForKey:(id <NSCopying>)key {
    return [[categoryPropertyDic objectForKey:[self hashKey]] objectForKey:key];
}
- (void)removePropertyValueForKey:(id <NSCopying>)key {
    NSMutableDictionary *propertyMap = [categoryPropertyDic objectForKey:[self hashKey]];
    if (!propertyMap) {
        propertyMap = [NSMutableDictionary dictionary];
    }
    propertyMap = [NSMutableDictionary dictionaryWithDictionary:propertyMap];
    [propertyMap removeObjectForKey:key];
    if (!categoryPropertyDic) {
        categoryPropertyDic = [NSMutableDictionary dictionary];
    }
    [categoryPropertyDic setObject:propertyMap forKey:[self hashKey]];
}
- (void)clearPropertyValue {
    [categoryPropertyDic removeObjectForKey:[self hashKey]];
}

+ (void)dumpClass {
    NSLog(@"***************variables lsit *********************");
    unsigned int count = 0;
    Ivar *list = class_copyIvarList([self class], &count);
    for (int i = 0 ; i < count; i ++) {
        Ivar var = list[i];
        NSLog(@"%s %s",ivar_getTypeEncoding(var),  ivar_getName(var));
    }
    NSLog(@"***************property lsit *********************");
    objc_property_t *pList = class_copyPropertyList([self class], &count);
    for (int i = 0 ; i < count; i ++) {
        objc_property_t var = pList[i];
        NSLog(@"%s %s",property_getAttributes(var), property_getName(var));
    }
    NSLog(@"***************method lsit *********************");
    Method *mList = class_copyMethodList([self class], &count);
    for (int i = 0 ; i < count; i ++) {
        Method var = mList[i];
        NSLog(@"%@", NSStringFromSelector(method_getName(var)));
    }
}


+ (void)setMethod:(SEL)selector withIMP:(SEL)other {
    Method md = class_getClassMethod([self class], selector);
    BOOL isClass = YES;
    if (!md) {
        md = class_getInstanceMethod([self class], selector);
        isClass = NO;
    }
    
    IMP imp = isClass?[[self class] methodForSelector:other]:[[self class] instanceMethodForSelector:other];//判断是不是class方法很重要，否则会失败
    if (md && imp) {
        method_setImplementation(md, imp);
    }
}

@end
