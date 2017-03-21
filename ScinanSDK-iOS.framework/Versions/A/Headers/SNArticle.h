//
//  SNArticle.h
//  ScinanSDK-iOS
//
//  Created by User on 16/7/15.
//  Copyright © 2016年 felixlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNArticle : NSObject

@property (nonatomic, copy) NSString *article_id;

@property (nonatomic, assign) int article_type;

@property (nonatomic, copy) NSString *article_title;

@property (nonatomic, copy) NSString *thumb_url;

@property (nonatomic, copy) NSString *detail_url;

@property (nonatomic, assign) BOOL action;

@property (nonatomic, copy) NSString *thumb;

@property (nonatomic, copy) NSString *name;

@end
