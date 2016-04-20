//
//  ServiceDetailViewController.m
//  jiayunhui
//
//  Created by zmx on 16/1/18.
//  Copyright © 2016年 com. All rights reserved.
//

#import "ServiceDetailViewController.h"
#import "OrderViewController.h"
#import "WeChatView.h"
#import "WeiboViewController.h"

@interface ServiceDetailViewController () <UIWebViewDelegate, UIWebViewDelegate>

@property (weak, nonatomic) UIButton *rightButton;

@property (nonatomic, strong) UIAlertView *callAv;

@end

@implementation ServiceDetailViewController

- (void)clickRight {
    UIWebView *webView = (UIWebView *)self.view;
    if ([self.rightButton.currentTitle isEqualToString:@"一键下单"]) {
        [webView stringByEvaluatingJavaScriptFromString:@"toBuyServiceInfo()"];
        self.title = @"订单提交";
        [self.rightButton setTitle:@"立即下单" forState:UIControlStateNormal];
    } else {
        [webView stringByEvaluatingJavaScriptFromString:@"doPay()"];
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)loadView {
    self.view = [[UIWebView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.serviceName;
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, 80, 24);
    [button setTitle:@"一键下单" forState:UIControlStateNormal];
    button.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickRight) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderWidth = 0.8;
    button.layer.borderColor = [UIColor redColor].CGColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.rightButton = button;
    
    NSString *urlStr = @"";
    if (SharedUser.isLogin) {
        urlStr = [NSString stringWithFormat:@"%@flow?id=%@&uid=%@&from=ios", BaseImageURLStr, self.serviceId, SharedUser.uid];
    } else {
        urlStr = [NSString stringWithFormat:@"%@flow?id=%@&uid=-1&from=ios", BaseImageURLStr, self.serviceId];
    }
    
    UIWebView *webView = (UIWebView *)self.view;
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
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
        NSArray *arr = [host componentsSeparatedByString:@"&"];
        NSString *tmp = arr.firstObject;
        
        if ([tmp isEqualToString:@"home"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        if ([tmp isEqualToString:@"order"]) {
            SharedUser.mobilephone = arr[1];
            SharedUser.uid = arr[2];
            [self pushViewController:[[OrderViewController alloc] init] animated:YES];
        }
        
        if ([tmp isEqualToString:@"phone"]) {
            self.callAv = [[UIAlertView alloc] initWithTitle:@"拨打电话" message:@"010-84004091" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
            [self.callAv show];
        }
        
        if ([tmp isEqualToString:@"weixin"]) {
            WeChatView *wv = [[[NSBundle mainBundle] loadNibNamed:@"WeChatView" owner:nil options:nil] firstObject];
            [self.view addSubview:wv];
            wv.frame = self.view.bounds;
        }
        
        if ([tmp isEqualToString:@"weibo"]) {
            WeiboViewController *wvc = [[WeiboViewController alloc] init];
            [self pushViewController:wvc animated:YES];
        }
        
        return NO;
    }
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView == self.callAv) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://17092875286"]];
        }
    }
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
