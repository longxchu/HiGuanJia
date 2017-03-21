//
//  Base+TextField.m
//  xlzj
//
//  Created by Mr Liu on 2017/3/18.
//  Copyright © 2017年 周绪刚. All rights reserved.
//

#import "Base+TextField.h"

@implementation Base_TextField



-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    if(menuController) {
        
        [UIMenuController sharedMenuController].menuVisible = NO;
        
    }
    
    return NO;
    
}


@end
