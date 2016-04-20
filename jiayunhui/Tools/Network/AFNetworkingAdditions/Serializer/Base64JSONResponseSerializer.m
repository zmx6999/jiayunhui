//
//  Base64JSONResponseSerializer.m
//  ztesoftLibs2
//
//  Created by wangyang on 14-1-23.
//  Copyright (c) 2014年 ztesoft. All rights reserved.
//

#import "Base64JSONResponseSerializer.h"
#import "YJSONKit.h"

@implementation Base64JSONResponseSerializer

+ (instancetype)serializer
{
    Base64JSONResponseSerializer *serializer = [[self alloc] init];
    
    return serializer;
}

-(id)responseObjectForResponse:(NSURLResponse *)response
                          data:(NSData *)data
                         error:(NSError *__autoreleasing *)error
{
    id responseObj=[data objectFromBase64JSONDataWithUTF8];
    [self printResponseObj:responseObj ForResponse:response];
    
    return responseObj;
}

#pragma mark - print log
- (void)printResponseObj:(id)responseObj ForResponse:(NSURLResponse*)response
{
    NSLog(@"\n\n------------- Response JSON String After Base64 --------------\
          \nURL: %@                                                      \
          \nresponse: %@                                                      \
          \n▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽\n\n"
          ,[[response URL] absoluteString],
          [responseObj JSONString]);
}
@end
