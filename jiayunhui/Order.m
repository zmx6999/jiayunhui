//
//  Order.m
//  jiayunhui
//
//  Created by zmx on 16/1/16.
//  Copyright © 2016年 com. All rights reserved.
//

#import "Order.h"

@implementation Order

+ (instancetype)orderWithDict:(NSDictionary *)dict {
    Order *order = [[self alloc] init];
    [order setValuesForKeysWithDictionary:dict];
    return order;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.idstr = value;
    }
}

@end
