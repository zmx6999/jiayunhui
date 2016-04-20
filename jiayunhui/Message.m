//
//  Message.m
//  jiayunhui
//
//  Created by zmx on 16/1/14.
//  Copyright © 2016年 com. All rights reserved.
//

#import "Message.h"

@implementation Message

+ (instancetype)messageWithDict:(NSDictionary *)dict {
    Message *message = [[self alloc] init];
    [message setValuesForKeysWithDictionary:dict];
    return message;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.idstr = value;
    }
}

@end
