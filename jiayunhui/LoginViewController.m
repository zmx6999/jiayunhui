//
//  LoginViewController.m
//  jiayunhui
//
//  Created by zmx on 16/1/12.
//  Copyright © 2016年 com. All rights reserved.
//

#import "LoginViewController.h"
#import "OrderViewController.h"
#import "UserInfoViewController.h"
#import "ForgetPwdViewController.h"
#import "RegisterViewController.h"

#define RequestLogin 0

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneText;

@property (weak, nonatomic) IBOutlet UITextField *pwdText;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (IBAction)pwdCanSee:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.pwdText.secureTextEntry = NO;
    } else {
        self.pwdText.secureTextEntry = YES;
    }
}

- (IBAction)forgetPwd:(id)sender {
    [self pushViewController:[[ForgetPwdViewController alloc] init] animated:YES];
}

- (IBAction)login:(id)sender {
    [self.view endEditing:YES];
    [SVProgressHUD show];
    [self.service getHTTPRequestAsyncPath:[BaseURLStr stringByAppendingFormat:@"memberLogin.do?mobilephone=%@&password=%@", self.phoneText.text, [MyMD5 md5:self.pwdText.text]] HTTPHeader:nil parameters:nil requestServiceType:RequestServiceGeneral requestTag:RequestLogin];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reg {
    RegisterViewController *rvc = [[RegisterViewController alloc] init];
    [self pushViewController:rvc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(reg)];
    self.title = @"用户登录";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:self.phoneText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:self.pwdText];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textDidChange {
    BOOL fill = (self.phoneText.text.length > 0 && self.pwdText.text.length > 0);
    self.loginButton.enabled = fill;
    if (fill) {
        self.loginButton.backgroundColor = Color(0xff, 0x48, 0x3e);
    } else {
        self.loginButton.backgroundColor = Color(0xec, 0xec, 0xed);
    }
}

- (void)responseSuccess:(id)responseObject requestOperation:(AFHTTPRequestOperation *)requestOperation requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    if (requestTag == RequestLogin) {
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [responseObject objectFromJSONData];
        
        if ([dict[@"result"] boolValue]) {
            [SharedUser setValuesForKeysWithDictionary:dict];
            SharedUser.isLogin = YES;
            SharedUser.userPassword = [MyMD5 md5:self.pwdText.text];
            
            if ([self.type isEqualToString:@"home"] || [self.type isEqualToString:@"order"]) {
                OrderViewController *ovc = [[OrderViewController alloc] init];
                [self pushViewController:ovc animated:YES];
                NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                [controllers removeObjectAtIndex:controllers.count - 2];
                self.navigationController.viewControllers = controllers;
            } else {
                UserInfoViewController *uvc = [[UserInfoViewController alloc] init];
                [self pushViewController:uvc animated:YES];
                NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                [controllers removeObjectAtIndex:controllers.count - 2];
                self.navigationController.viewControllers = controllers;
            }
        } else {
            [self showNoticeWithStatus:@"账号或密码错误"];
            self.pwdText.text = nil;
        }
    }
}

- (void)responseFailure:(AFHTTPRequestOperation *)requestOperation error:(NSError *)error requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    if (requestTag == RequestLogin) {
        [SVProgressHUD dismiss];
        [self showNoticeWithStatus:@"登录失败"];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
