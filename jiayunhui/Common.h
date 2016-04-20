//
//  Common.h
//  jiayunhui
//
//  Created by zmx on 16/1/12.
//  Copyright © 2016年 com. All rights reserved.
//
#import "UIView+ZMX.h"
#import "SVProgressHUD.h"
#import "YHTTPService.h"
#import "YJSONKit.h"
#import "MyMD5.h"
#import "BaseViewController.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"
#import "User.h"
#import "GTMBase64.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMFeedback.h"
#import "MobClick.h"
#import "ASIFormDataRequest.h"
#import "ZMXRefreshView.h"

#define ScreenBounds ([UIScreen mainScreen].bounds)
#define ScreenSize (ScreenBounds.size)
#define ScreenWidth (ScreenSize.width)
#define ScreenHeight (ScreenSize.height)

#define Color(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]
#define ControllerColor Color(245, 245, 245)

#define DefaultURLStr @"www.jiayunhui.com"
#define BaseURLStr [@"http://" stringByAppendingFormat:@"%@/admin/api/", DefaultURLStr]
#define BaseImageURLStr [@"http://" stringByAppendingFormat:@"%@/admin/", DefaultURLStr]

#define SharedUser [User sharedUser]

#define iOS8 ([UIDevice currentDevice].systemVersion.intValue >= 8.0)