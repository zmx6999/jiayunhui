//
//  WeiboViewController.m
//  jiayunhui
//
//  Created by zmx on 16/1/12.
//  Copyright © 2016年 com. All rights reserved.
//

#import "WeiboViewController.h"

@interface WeiboViewController () <UIWebViewDelegate>

@end

@implementation WeiboViewController

- (void)loadView {
    self.view = [[UIWebView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *wv = (UIWebView *)self.view;
    wv.delegate = self;
    [wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://weibo.com/u/5640178675"]]];
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

@end
