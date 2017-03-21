//
//  XLDMITools.h
//  xlzj
//
//  Created by 周绪刚 on 2017/1/21.
//  Copyright © 2017年 周绪刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLDictionary.h"

@interface XLDMITools : NSObject

+ (void)commandStrCmdWith:(NSString *)strCmd withStrIndex:(NSString *)strIndex withValue:(id)value;

@end
