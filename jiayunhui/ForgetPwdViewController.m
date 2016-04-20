//
//  ForgetPwdViewController.m
//  jiayunhui
//
//  Created by zmx on 16/1/13.
//  Copyright © 2016年 com. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "FindPwdViewController.h"

#define RequestForgetPwd 0

@interface ForgetPwdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneText;

@property (weak, nonatomic) IBOutlet UITextField *ensureText;

@property (weak, nonatomic) IBOutlet UILabel *sendLabel;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, copy) NSString *ensureStr;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger time;

@end

@implementation ForgetPwdViewController

- (IBAction)sendEnsureCode:(id)sender {
    NSString *regular = @"^1[3|5|7|8][0-9]{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    if ([predicate evaluateWithObject:self.phoneText.text]) {
        [self.service getHTTPRequestAsyncPath:[NSString stringWithFormat:@"%@/getCaptcha.do?mobilephone=%@&smstype=order", BaseURLStr, self.phoneText.text] HTTPHeader:nil parameters:nil requestServiceType:RequestServiceGeneral requestTag:RequestForgetPwd];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        self.sendLabel.backgroundColor = Color(0xe1, 0xe1, 0xe1);
        self.time = 60;
        self.sendLabel.userInteractionEnabled = NO;
    } else {
        [self showNoticeWithStatus:@"请输入正确的手机号"];
        self.phoneText.text = nil;
    }
}

- (IBAction)next:(id)sender {
    [self.view endEditing:YES];
    FindPwdViewController *fvc = [[FindPwdViewController alloc] init];
    fvc.mobilephone = self.phoneText.text;
    [self pushViewController:fvc animated:YES];
}

- (void)updateTimer {
    self.time--;
    if (self.time > 0) {
        self.sendLabel.text = [NSString stringWithFormat:@"%ld秒后重发", self.time];
    } else {
        self.sendLabel.text = @"发送验证码";
        self.sendLabel.backgroundColor = [UIColor redColor];
        self.sendLabel.userInteractionEnabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"找回密码";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:self.phoneText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:self.ensureText];
}

- (void)textDidChange {
    BOOL fill = (self.phoneText.text.length > 0 && self.ensureText.text.length > 0);
    BOOL ensureValid = [self isEnsureTextValid];
    if (ensureValid) {
        self.sendLabel.text = @"已验证";
        self.sendLabel.userInteractionEnabled = NO;
        [self.timer invalidate];
    } else if ([self.sendLabel.text isEqualToString:@"已验证"]) {
        self.sendLabel.text = @"发送验证码";
        self.sendLabel.userInteractionEnabled = YES;
        self.sendLabel.backgroundColor = [UIColor redColor];
    }
    
    self.nextButton.enabled = fill & ensureValid;
    if (self.nextButton.enabled) {
        self.nextButton.backgroundColor = Color(0xff, 0x48, 0x3e);
    } else {
        self.nextButton.backgroundColor = Color(0xec, 0xec, 0xed);
    }
}

- (BOOL)isEnsureTextValid {
    if (self.ensureText.text.length > 4) {
        self.ensureText.text = [self.ensureText.text substringToIndex:3];
    }
    return [self.ensureText.text isEqualToString:self.ensureStr];
}

- (void)responseSuccess:(id)responseObject requestOperation:(AFHTTPRequestOperation *)requestOperation requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    if (requestTag == RequestForgetPwd) {
        NSDictionary *dict = [responseObject objectFromJSONData];
        self.ensureStr = dict[@"captcha"];
    }
}

- (void)responseFailure:(AFHTTPRequestOperation *)requestOperation error:(NSError *)error requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    if (requestTag == RequestForgetPwd) {
        [self showNoticeWithStatus:@"验证码发送失败"];
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
