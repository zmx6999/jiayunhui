//
//  Order.h
//  jiayunhui
//
//  Created by zmx on 16/1/16.
//  Copyright © 2016年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property(copy,nonatomic)NSString *orderno;

@property(copy,nonatomic)NSString *serviceid;

@property(copy,nonatomic)NSString *member;

@property(copy,nonatomic)NSString *pay;

@property(copy,nonatomic)NSString *iconurl;

@property(copy,nonatomic)NSString *servename;

@property(copy,nonatomic)NSString *finishNodeName;

@property(copy,nonatomic)NSString *finish;

@property(copy,nonatomic)NSString *placedate;

@property(copy,nonatomic)NSString *idstr;

@property(copy,nonatomic)NSString *finishNodeStatus;

+ (instancetype)orderWithDict:(NSDictionary *)dict;

@end
