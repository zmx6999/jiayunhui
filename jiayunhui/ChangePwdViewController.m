//
//  ChangePwdViewController.m
//  jiayunhui
//
//  Created by zmx on 16/1/18.
//  Copyright © 2016年 com. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "LoginViewController.h"

#define RequestChangePwd 0

@interface ChangePwdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPwdText;

@property (weak, nonatomic) IBOutlet UITextField *pwdText;

@property (weak, nonatomic) IBOutlet UITextField *rePwdText;

@property (weak, nonatomic) IBOutlet UIButton *changeButton;

@end

@implementation ChangePwdViewController

- (IBAction)change:(id)sender {
    [self.view endEditing:YES];
    if (![[MyMD5 md5:self.oldPwdText.text] isEqualToString:SharedUser.userPassword]) {
        [self showNoticeWithStatus:@"原密码输入错误"];
        self.oldPwdText.text = nil;
        self.pwdText.text = nil;
        self.rePwdText.text = nil;
        [self.oldPwdText becomeFirstResponder];
    } else {
        [SVProgressHUD show];
        [self.service getHTTPRequestAsyncPath:[NSString stringWithFormat:@"%@modifyPwd.do?mobilephone=%@&password=%@", BaseURLStr, SharedUser.mobilephone, [MyMD5 md5:self.pwdText.text]] HTTPHeader:nil parameters:nil requestServiceType:RequestServiceGeneral requestTag:RequestChangePwd];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改密码";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:self.oldPwdText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:self.pwdText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:self.rePwdText];
}

- (void)textDidChange {
    self.changeButton.enabled = (self.oldPwdText.text.length >= 6 && self.oldPwdText.text.length <= 16 && self.pwdText.text.length >= 6 && self.pwdText.text.length <= 16 && [self.rePwdText.text isEqualToString:self.pwdText.text]);
    if (self.changeButton.enabled) {
        self.changeButton.backgroundColor = Color(0xff, 0x48, 0x3e);
    } else {
        self.changeButton.backgroundColor = Color(0xec, 0xec, 0xed);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)responseSuccess:(id)responseObject requestOperation:(AFHTTPRequestOperation *)requestOperation requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    [SVProgressHUD dismiss];
    if (requestTag == RequestChangePwd) {
        [self showNoticeWithStatus:@"修改成功，请重新登录"];
        SharedUser.isLogin = NO;
        [self pushViewController:[[LoginViewController alloc] init] animated:YES];
        NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [controllers removeObjectAtIndex:controllers.count - 2];
        self.navigationController.viewControllers = controllers;
    }
}

- (void)responseFailure:(AFHTTPRequestOperation *)requestOperation error:(NSError *)error requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    [SVProgressHUD dismiss];
    if (requestTag == RequestChangePwd) {
        [self showNoticeWithStatus:@"服务器返回错误"];
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
