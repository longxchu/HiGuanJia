//
//  XLDMITools.m
//  xlzj
//
//  Created by 周绪刚 on 2017/1/21.
//  Copyright © 2017年 周绪刚. All rights reserved.
//

#import "XLDMITools.h"

@implementation XLDMITools

+ (void)commandStrCmdWith:(NSString *)strCmd withStrIndex:(NSString *)strIndex withValue:(id)value
{
    NSDictionary *commandDict = @{@"strCmd":strCmd,@"strIndex":strIndex,@"setValue":value};
    NSString *commandJson = [XLDictionary dictionaryToJson:commandDict];
    [linkon_op dmiJsonCommand:commandJson];
}

@end
