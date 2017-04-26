//
//  SN7681Sender.h
//  QianpaSuper
//
//  Created by User on 2016/11/9.
//  Copyright © 2016年 Scinan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SN7681Sender : NSObject

- (void)startWithSSID:(NSString*)ssid Password:(NSString *)password;

- (void)stop;

@end
