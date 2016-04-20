//
//  Base64JSONRequestSerializer.h
//  ztesoftLibs2
//
//  Created by wangyang on 14-1-23.
//  Copyright (c) 2014年 ztesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64JSONRequestSerializer : NSObject

+ (instancetype)serializer;

-(NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                URLString:(NSString *)path
                               parameters:(NSDictionary *)parameters;

@end
