//
//  HomeCell3.m
//  jiayunhui
//
//  Created by zmx on 16/1/12.
//  Copyright © 2016年 com. All rights reserved.
//

#import "HomeCell3.h"
#import "WeChatView.h"
#import "WeiboViewController.h"

@interface HomeCell3 () <UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertView *callAv;

@end

@implementation HomeCell3

- (IBAction)call:(id)sender {
    self.callAv = [[UIAlertView alloc] initWithTitle:@"拨打电话" message:@"010-84004091" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    [self.callAv show];
}

- (IBAction)wechat:(id)sender {
    WeChatView *wv = [[[NSBundle mainBundle] loadNibNamed:@"WeChatView" owner:nil options:nil] firstObject];
    UIViewController *vc = [self getViewController];
    [vc.view addSubview:wv];
    wv.frame = vc.view.bounds;
}

- (IBAction)weibo:(id)sender {
    WeiboViewController *wvc = [[WeiboViewController alloc] init];
    [(BaseViewController *)[self getViewController] pushViewController:wvc animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView == self.callAv) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://17092875286"]];
        }
    }
}

@end
