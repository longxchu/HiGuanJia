//
//  NSObject+categoryProperty.h
//  sunflower
//
//  Created by Karsa wang on 10/20/14.
//  Copyright (c) 2014 shenbin. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 使用之后必须手动调用clearPropertyValue释放内存
 */
@interface NSObject (categoryProperty)
- (void)setObjectPropertyValue:(id)value forKey:(id <NSCopying>)key;
- (id)objectPropertyValueForKey:(id <NSCopying>)key;
- (void)removePropertyValueForKey:(id <NSCopying>)key;
- (void)clearPropertyValue;
- (NSString *)hashKey;
+ (void)dumpClass;
+ (void)setMethod:(SEL)selector withIMP:(SEL)other;
@end
