//
//  BaseViewController.h
//  jiayunhui
//
//  Created by zmx on 16/1/13.
//  Copyright © 2016年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController <YHTTPServiceDelegate>

@property (nonatomic, strong) YHTTPService *service;

- (void)pushViewController:(UIViewController *)controller animated:(BOOL)animated;

- (void)showNoticeWithStatus:(NSString *)status;

@end
