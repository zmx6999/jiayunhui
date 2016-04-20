//
//  SettingViewController.m
//  jiayunhui
//
//  Created by zmx on 16/1/16.
//  Copyright © 2016年 com. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "LoginViewController.h"
#import "AgreeViewController.h"
#import "UserInfoViewController.h"
#import "OrderViewController.h"

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UMSocialUIDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *aboutBtn;

@property (weak, nonatomic) IBOutlet UIButton *callBtn;

@property (weak, nonatomic) IBOutlet UIButton *logBtn;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (nonatomic, strong) UIAlertView *callAv;

@property (nonatomic, strong) UIAlertView *clearAv;

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, copy) NSString *cachepath;

@end

static NSString *ID = @"settingCell";

@implementation SettingViewController

- (IBAction)loginOrOut:(id)sender {
    if (SharedUser.isLogin) {
        SharedUser.isLogin = NO;
        [self.logBtn setTitle:@"登录" forState:UIControlStateNormal];
    } else {
        [self login];
    }
}

- (IBAction)seeAbout:(id)sender {
    UIViewController *vc = [[UIViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    vc.title = @"关于我们";
    [self pushViewController:vc animated:YES];
}

- (IBAction)call:(id)sender {
    self.callAv = [[UIAlertView alloc] initWithTitle:@"拨打电话" message:@"010-84004091" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    [self.callAv show];
}

- (IBAction)retMoney:(id)sender {
    AgreeViewController *avc = [[AgreeViewController alloc] init];
    avc.filename = @"tuikuanxy.html";
    avc.title = @"退款政策";
    [self pushViewController:avc animated:YES];
}

- (IBAction)privacy:(id)sender {
    AgreeViewController *avc = [[AgreeViewController alloc] init];
    avc.filename = @"yinsixy.html";
    avc.title = @"隐私政策";
    [self pushViewController:avc animated:YES];
}

- (void)login {
    LoginViewController *lvc = [[LoginViewController alloc] init];
    [self pushViewController:lvc animated:YES];
}

- (NSArray *)images {
    if (_images == nil) {
        _images = @[@[@"persion", @"order", @"feedback", @"share"], @[@"trash"]];
    }
    return _images;
}

- (NSArray *)titles {
    if (_titles == nil) {
        _titles = @[@[@"个人资料", @"我的订单", @"意见反馈", @"推荐给朋友"] ,@[@"清除缓存"]];
    }
    return _titles;
}

- (NSString *)cachepath {
    if (_cachepath == nil) {
        _cachepath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        _cachepath = [_cachepath stringByAppendingPathComponent:@"zmx.jiayunhui"];
        NSLog(@"%@", _cachepath);
    }
    return _cachepath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"用户中心";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(login)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingCell" bundle:nil] forCellReuseIdentifier:ID];
    
    self.aboutBtn.layer.borderWidth = 1;
    self.aboutBtn.layer.borderColor = Color(0xb3, 0xb3, 0xb3).CGColor;
    
    self.callBtn.layer.borderWidth = 1;
    self.callBtn.layer.borderColor = Color(0xb3, 0xb3, 0xb3).CGColor;
    
    self.versionLabel.text = [NSString stringWithFormat:@"当前版本:%.1f", [[NSBundle mainBundle].infoDictionary[@"CFBundleVersion"] doubleValue]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"Settings"];
    if (SharedUser.isLogin) {
        [self.logBtn setTitle:[NSString stringWithFormat:@"账户：%@", SharedUser.mobilephone] forState:UIControlStateNormal];
    } else {
        [self.logBtn setTitle:@"登录" forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Settings"];
}

- (long long)getCacheSize {
    return [[[NSFileManager defaultManager] attributesOfItemAtPath:self.cachepath error:nil] fileSize];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.images.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.images[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.iv.image = [UIImage imageNamed:self.images[indexPath.section][indexPath.row]];
    cell.label.text = self.titles[indexPath.section][indexPath.row];
    cell.separatorLine.hidden = (indexPath.row == [self.images[indexPath.section] count] - 1);
    cell.arrow.hidden = (indexPath.section > 0);
    cell.sizeLabel.hidden = (indexPath.section == 0);
    if (cell.arrow.hidden) {
        cell.sizeLabel.text= [NSString stringWithFormat:@"%lldK", [self getCacheSize]];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = self.view.backgroundColor;
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = self.view.backgroundColor;
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 0) {
        self.clearAv = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"缓存确定要清空吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [self.clearAv show];
    } else {
        switch (indexPath.row) {
            case 0: {
                if (SharedUser.isLogin) {
                    [self pushViewController:[[UserInfoViewController alloc] init] animated:YES];
                } else {
                    [self login];
                }
                break;
            }
                
            case 1: {
                if (SharedUser.isLogin) {
                    [self pushViewController:[[OrderViewController alloc] init] animated:YES];
                } else {
                    LoginViewController *lvc = [[LoginViewController alloc] init];
                    lvc.type = @"order";
                    [self pushViewController:lvc animated:YES];
                }
                break;
            }
                
            case 2: {
                [self.navigationController pushViewController:[UMFeedback feedbackViewController]
                                                     animated:YES];
                break;
            }
                
            case 3: {
                [UMSocialSnsService presentSnsIconSheetView:self
                                                     appKey:@"569dae2f67e58e5fe6001cb4"
                                                  shareText:@"嘉芸汇企业服务平台，致力于为中国中小微企业服务，请关注微信，搜索“嘉芸汇“"
                                                 shareImage:[UIImage imageNamed:@"icon.png"]
                                            shareToSnsNames:@[UMShareToSina, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToEmail, UMShareToSms]
                                                   delegate:self];
                break;
            }
                
            default:
                break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView == self.callAv) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://17092875286"]];
        }
        if (alertView == self.clearAv) {
            [[NSFileManager defaultManager] removeItemAtPath:self.cachepath error:nil];
            SettingCell *cell = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
            cell.sizeLabel.text = [NSString stringWithFormat:@"%lldk", [self getCacheSize]];
        }
    }
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        [self showNoticeWithStatus:@"分享成功"];
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
