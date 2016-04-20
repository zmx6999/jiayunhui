//
//  UserInfoViewController.m
//  jiayunhui
//
//  Created by zmx on 16/1/18.
//  Copyright © 2016年 com. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoCell.h"
#import "SexButton.h"
#import "ChangePwdViewController.h"

#define RequestSaveInfo 0
#define RequestSaveAvatar 1

@interface UserInfoViewController () <UITableViewDataSource, UITableViewDelegate, UserInfoCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) UIImageView *avatarView;

@property (weak, nonatomic) UITextField *usernameText;

@property (weak, nonatomic) SexButton *sexButton;

@property (nonatomic, copy) NSString *headphotourl;

@end

@implementation UserInfoViewController

- (UIImageView *)avatarView {
    if (_avatarView == nil) {
        UserInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        _avatarView = cell.iconView;
    }
    return _avatarView;
}

- (UITextField *)usernameText {
    if (_usernameText == nil) {
        UserInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
        _usernameText = cell.phoneNumText;
    }
    return _usernameText;
}

- (SexButton *)sexButton {
    if (_sexButton == nil) {
        UserInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
        _sexButton = cell.sexButton;
    }
    return _sexButton;
}

- (void)editOrSave:(UIBarButtonItem *)barButton {
    if ([barButton.title isEqualToString:@"编辑"]) {
        self.usernameText.enabled = YES;
        self.sexButton.enabled = YES;
        barButton.title = @"保存";
    } else {
        [self.view endEditing:YES];
        self.usernameText.enabled = NO;
        self.sexButton.enabled = NO;
        barButton.title = @"编辑";
        
        NSString *urlStr = [NSString stringWithFormat:@"%@memberEdit.do?mobilephone=%@&username=%@&sex=%d", BaseURLStr, SharedUser.mobilephone, self.usernameText.text, self.sexButton.sex];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [SVProgressHUD show];
        [self.service getHTTPRequestAsyncPath:urlStr HTTPHeader:nil parameters:nil requestServiceType:RequestServiceGeneral requestTag:RequestSaveInfo];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个人资料";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editOrSave:)];
}

- (void)userInfoCell:(UserInfoCell *)userInfoCell didSelectPhoto:(NSString *)photourl {
    [SVProgressHUD show];
    self.headphotourl = photourl;
    NSDictionary *params = @{@"mobilephone": SharedUser.mobilephone, @"headphoto": photourl};
    [self.service postHTTPRequestAsyncPath:[NSString stringWithFormat:@"%@memberEditPhoto.do", BaseURLStr] HTTPHeader:nil parameters:params requestServiceType:RequestServiceGeneral requestTag:RequestSaveAvatar];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section > 0 ?1 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = [NSString stringWithFormat:@"UserInfoCell%ld%ld", indexPath.section, indexPath.row];
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] firstObject];
    }
    cell.delegate = self;
    cell.iconView.image = [UIImage imageWithData:[GTMBase64 decodeString:self.headphotourl]];
    cell.phoneNumText.text = SharedUser.username ? : SharedUser.mobilephone;
    cell.sexButton.sex = ([SharedUser.sex intValue] > 0);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return ScreenHeight * 0.118 + 20;
    } else {
        return ScreenHeight * 0.08;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 0) {
        [self pushViewController:[[ChangePwdViewController alloc] init] animated:YES];
    }
}

- (void)responseSuccess:(id)responseObject requestOperation:(AFHTTPRequestOperation *)requestOperation requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    [SVProgressHUD dismiss];
    switch (requestTag) {
        case RequestSaveInfo: {
            SharedUser.username = self.usernameText.text;
            SharedUser.sex = [NSString stringWithFormat:@"%d", self.sexButton.sex];
            [self showNoticeWithStatus:@"保存成功"];
            break;
        }
            
        case RequestSaveAvatar: {
            SharedUser.headphotourl = self.headphotourl;
            self.avatarView.image = [UIImage imageWithData:[GTMBase64 decodeString:SharedUser.headphotourl]];
            break;
        }
            
        default:
            break;
    }
}

- (void)responseFailure:(AFHTTPRequestOperation *)requestOperation error:(NSError *)error requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    [SVProgressHUD dismiss];
    switch (requestTag) {         
        case RequestSaveInfo: {
            [self showNoticeWithStatus:@"服务器返回错误"];
        }
            
        case RequestSaveAvatar: {
            [self showNoticeWithStatus:@"修改头像失败"];
            break;
        }
            
        default:
            break;
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
