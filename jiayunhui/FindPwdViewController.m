//
//  FindPwdViewController.m
//  jiayunhui
//
//  Created by zmx on 16/1/13.
//  Copyright © 2016年 com. All rights reserved.
//

#import "FindPwdViewController.h"

#define RequestGetPwd 0

@interface FindPwdViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *pwdText;

@property (weak, nonatomic) IBOutlet UITextField *ensureText;

@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation FindPwdViewController

- (IBAction)pwdCanSee:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.pwdText.secureTextEntry = NO;
    } else {
        self.pwdText.secureTextEntry = YES;
    }
}

- (IBAction)change:(id)sender {
    [self.view endEditing:YES];
    [SVProgressHUD show];
    [self.service getHTTPRequestAsyncPath:[NSString stringWithFormat:@"%@modifyPwd.do?mobilephone=%@&password=%@", BaseURLStr, self.mobilephone, [MyMD5 md5:self.pwdText.text]] HTTPHeader:nil parameters:nil requestServiceType:RequestServiceGeneral requestTag:RequestGetPwd];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:self.pwdText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:self.ensureText];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textDidChange {
    BOOL fill = (self.pwdText.text.length >= 6 && self.pwdText.text.length <= 16 && [self.ensureText.text isEqualToString:self.pwdText.text]);
    self.button.enabled = fill;
    if (fill) {
        self.button.backgroundColor = Color(0xff, 0x48, 0x3e);
    } else {
        self.button.backgroundColor = Color(0xec, 0xec, 0xed);
    }
}

- (void)responseSuccess:(id)responseObject requestOperation:(AFHTTPRequestOperation *)requestOperation requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    [SVProgressHUD dismiss];
    if (requestTag == RequestGetPwd) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设置成功，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }
}

- (void)responseFailure:(AFHTTPRequestOperation *)requestOperation error:(NSError *)error requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    [SVProgressHUD dismiss];
    if (requestTag == RequestGetPwd) {
        [self showNoticeWithStatus:@"设置失败"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSArray *controllers = self.navigationController.viewControllers;
        [self.navigationController popToViewController:controllers[controllers.count - 3] animated:NO];
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
