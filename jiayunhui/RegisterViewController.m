//
//  RegisterViewController.m
//  jiayunhui
//
//  Created by zmx on 16/1/17.
//  Copyright © 2016年 com. All rights reserved.
//

#import "RegisterViewController.h"
#import "AgreeViewController.h"

#define RequestRegister 0
#define RequestCheckPhone 1
#define RequestGetCaptcha 2

#define UIButtonStateDidChangeNotification @"UIButtonStateDidChange"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneText;

@property (weak, nonatomic) IBOutlet UITextField *pwdText;

@property (weak, nonatomic) IBOutlet UITextField *ensureText;

@property (weak, nonatomic) IBOutlet UILabel *sendLabel;

@property (weak, nonatomic) IBOutlet UIButton *protocolButton;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger time;

@property (nonatomic, copy) NSString *ensureStr;

@end

@implementation RegisterViewController

- (IBAction)changeEditing:(UITextField *)sender {
    if (sender.text.length >= 11) {
        NSString *pattern = @"^1[3|5|7|8][0-9]{9}$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        if (![predicate evaluateWithObject:sender.text]) {
            [self showNoticeWithStatus:@"请输入正确的手机号"];
            sender.text = nil;
            [self.phoneText becomeFirstResponder];
        }
    }
}

- (IBAction)canSeePwd:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.pwdText.secureTextEntry = NO;
    } else {
        self.pwdText.secureTextEntry = YES;
    }
}

- (IBAction)sendEnsureStr:(id)sender {
    if (self.phoneText.text.length < 11) {
        [self showNoticeWithStatus:@"请输入正确的手机号"];
        self.phoneText.text = nil;
        self.pwdText.text = nil;
        [self.phoneText becomeFirstResponder];
    } else if (self.pwdText.text.length < 6 || self.pwdText.text.length > 16) {
        [self showNoticeWithStatus:@"密码6-16位"];
        self.pwdText.text = nil;
        [self.pwdText becomeFirstResponder];
    } else {
        [self.service getHTTPRequestAsyncPath:[NSString stringWithFormat:@"%@/getCaptcha.do?mobilephone=%@&smstype=order", BaseURLStr, self.phoneText.text] HTTPHeader:nil parameters:nil requestServiceType:RequestServiceGeneral requestTag:RequestGetCaptcha];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        self.sendLabel.userInteractionEnabled = NO;
        self.sendLabel.backgroundColor = Color(0xe1, 0xe1, 0xe1);
        self.time = 60;
    }
}

- (IBAction)reg:(id)sender {
    [self.view endEditing:YES];
    [SVProgressHUD show];
    [self.service getHTTPRequestAsyncPath:[NSString stringWithFormat:@"%@checkMember.do?mobilephone=%@", BaseURLStr, self.phoneText.text] HTTPHeader:nil parameters:nil requestServiceType:RequestServiceGeneral requestTag:RequestCheckPhone];
}

- (IBAction)agree:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:UIButtonStateDidChangeNotification object:sender];
}

- (IBAction)readProtocol:(id)sender {
    AgreeViewController *avc = [[AgreeViewController alloc] init];
    avc.filename = @"tuikuanxy.html";
    avc.title = @"退款政策";
    [self pushViewController:avc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"用户注册";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:self.phoneText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:self.pwdText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:self.ensureText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UIButtonStateDidChangeNotification object:self.protocolButton];
}

- (void)textDidChange {
    BOOL ensureTextValid = [self isEnsureTextValid];
    if (ensureTextValid) {
        self.sendLabel.text = @"已验证";
        self.sendLabel.userInteractionEnabled = NO;
        [self.timer invalidate];
    } else if ([self.sendLabel.text isEqualToString:@"已验证"]) {
        self.sendLabel.text = @"发送验证码";
        self.sendLabel.backgroundColor = [UIColor redColor];
        self.sendLabel.userInteractionEnabled = YES;
    }
    
    BOOL fill = (self.phoneText.text.length > 0 && self.pwdText.text.length >= 6 && self.ensureText.text.length <= 16 && self.protocolButton.selected);
    self.registerButton.enabled = fill & ensureTextValid;
    if (self.registerButton.enabled) {
        self.registerButton.backgroundColor = Color(0xff, 0x48, 0x3e);
    } else {
        self.registerButton.backgroundColor = Color(0xec, 0xec, 0xed);
    }
}

- (void)updateTimer {
    self.time--;
    if (self.time > 0) {
        self.sendLabel.text = [NSString stringWithFormat:@"%ld秒后重发", self.time];
    } else {
        self.sendLabel.text = @"发送验证码";
        self.sendLabel.backgroundColor = [UIColor redColor];
        self.sendLabel.userInteractionEnabled = YES;
        [self.timer invalidate];
    }
}

- (BOOL)isEnsureTextValid {
    if (self.ensureText.text.length > 4) {
        self.ensureText.text = [self.ensureText.text substringToIndex:3];
    }
    return [self.ensureText.text isEqualToString:self.ensureStr];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)responseSuccess:(id)responseObject requestOperation:(AFHTTPRequestOperation *)requestOperation requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    [SVProgressHUD dismiss];
    if (requestTag == RequestGetCaptcha) {
        NSDictionary *dict = [responseObject objectFromJSONData];
        self.ensureStr = dict[@"captcha"];
    } else if (requestTag == RequestCheckPhone) {
        NSDictionary *dict = [responseObject objectFromJSONData];
        if ([dict[@"result"] intValue] == 103) {
            [self showNoticeWithStatus:@"该手机号已注册"];
            self.phoneText.text = nil;
            self.pwdText.text = nil;
            self.ensureText.text = nil;
            [self.phoneText becomeFirstResponder];
        } else {
            [self.service getHTTPRequestAsyncPath:[NSString stringWithFormat:@"%@memberRegist.do?mobilephone=%@&password=%@", BaseURLStr, self.phoneText.text, [MyMD5 md5:self.pwdText.text]] HTTPHeader:nil parameters:nil requestServiceType:RequestServiceGeneral requestTag:RequestRegister];
        }
    } else if (requestTag == RequestRegister) {
        NSDictionary *dict = [responseObject objectFromJSONData];
        if ([dict[@"result"] intValue] == 1) {
            SharedUser.isLogin = NO;
            [self showNoticeWithStatus:@"注册成功，请重新登录"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)responseFailure:(AFHTTPRequestOperation *)requestOperation error:(NSError *)error requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    [SVProgressHUD dismiss];
    if (requestTag == RequestGetCaptcha) {
        [self showNoticeWithStatus:@"验证码发送失败"];
    } else if (requestTag == RequestRegister) {
        [self showNoticeWithStatus:@"注册失败，请重新注册"];
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
