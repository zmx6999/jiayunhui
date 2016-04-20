//
//  Base64JSONResponseSerializer.h
//  ztesoftLibs2
//
//  Created by wangyang on 14-1-23.
//  Copyright (c) 2014年 ztesoft. All rights reserved.
//

#import "AFURLResponseSerialization.h"

@interface Base64JSONResponseSerializer : AFHTTPResponseSerializer

+ (instancetype)serializer;

@end
