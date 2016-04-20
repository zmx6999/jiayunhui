//
//  PayViewController.m
//  jiayunhui
//
//  Created by zmx on 16/1/16.
//  Copyright © 2016年 com. All rights reserved.
//

#import "PayViewController.h"

@interface PayViewController () <UIWebViewDelegate>

@end

@implementation PayViewController

- (void)loadView {
    self.view = [[UIWebView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单支付";
    
    UIWebView *webView = (UIWebView *)self.view;
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@order/iosPay?oid=%@&uid=%@", BaseImageURLStr, self.orderID, SharedUser.uid]]]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"网络无法连接"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = request.URL;
    if ([url.scheme isEqualToString:@"myapp"]) {
        NSString *host = url.host;
        if ([host isEqualToString:@"pay"]) {
            UIViewController *vc = [[UIViewController alloc] initWithNibName:@"OfflineViewController" bundle:nil];
            vc.title = @"账户信息";
            [self pushViewController:vc animated:YES];
        } else {
            [self showNoticeWithStatus:@"目前只支持线下支付"];
        }
        return NO;
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
