//
//  User.h
//  jiayunhui
//
//  Created by zmx on 16/1/12.
//  Copyright © 2016年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *headphotourl;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *mobilephone;

@property (nonatomic, copy) NSString *userPassword;

@property (nonatomic, copy) NSString *cityID;

@property (nonatomic, assign) BOOL isLogin;

+ (instancetype)sharedUser;

@end
