//
//  SNFood.h
//  sdk-demo
//
//  Created by User on 16/3/9.
//  Copyright © 2016年 Scinan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNFood : NSObject

@property (nonatomic, strong) NSArray *steps;

@property (nonatomic, copy) NSString *food_menu_id;

@property (nonatomic, copy) NSString *food_menu_name;

@property (nonatomic, copy) NSString *category_id;

@property (nonatomic, copy) NSString *category_name;

@property (nonatomic, copy) NSString *producer;

@property (nonatomic, copy) NSString *img_url;

@property (nonatomic, strong) NSArray *tool;

@property (nonatomic, strong) NSArray *material;

@property (nonatomic, copy) NSString *Description;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *company_id;

@property (nonatomic, copy) NSString *is_run;

@property (nonatomic, copy) NSString *run_command;

@property (nonatomic, copy) NSString *run_time;

@property (nonatomic, copy) NSString *share_url;

@property (nonatomic, copy) NSString *favorite;

@property (nonatomic, copy) NSString *share;

@property (nonatomic, copy) NSString *comment;

@property (nonatomic, copy) NSString *download;

@property (nonatomic, copy) NSString *cook;

@property (nonatomic, copy) NSString *agree;

@property (nonatomic, copy) NSString *disagree;

@property (nonatomic, copy) NSString *grade;

@property (nonatomic, assign) NSInteger device_type;

@property (nonatomic, assign) BOOL isFavorite;

@property (nonatomic, assign) int menu_type;

@property (nonatomic, copy) NSString *buy_url;

@end
