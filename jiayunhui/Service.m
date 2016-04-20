//
//  Service.m
//  jiayunhui
//
//  Created by zmx on 16/1/13.
//  Copyright © 2016年 com. All rights reserved.
//

#import "Service.h"

@implementation Service

+ (instancetype)serviceWithDict:(NSDictionary *)dict {
    Service *service = [[self alloc] init];
    [service setValuesForKeysWithDictionary:dict];
    return service;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.idstr = value;
    }
}

@end
