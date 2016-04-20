//
//  Message.h
//  jiayunhui
//
//  Created by zmx on 16/1/14.
//  Copyright © 2016年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property(nonatomic, copy) NSString *url;

@property(nonatomic, copy) NSString *idstr;

@property(nonatomic, copy) NSString *title;

@property(nonatomic, copy) NSString *href;

@property(nonatomic, copy) NSString *templatetype;

@property(nonatomic, copy) NSString *addDate;

+ (instancetype)messageWithDict:(NSDictionary *)dict;

@end
