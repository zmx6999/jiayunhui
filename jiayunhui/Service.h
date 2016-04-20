//
//  Service.h
//  jiayunhui
//
//  Created by zmx on 16/1/13.
//  Copyright © 2016年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Service : NSObject

@property (nonatomic,copy)NSString *idstr;

@property (nonatomic,copy)NSString * cityid;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *iconurl;

+ (instancetype)serviceWithDict:(NSDictionary *)dict;

@end
