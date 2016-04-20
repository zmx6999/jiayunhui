//
//  BaseViewController.m
//  jiayunhui
//
//  Created by zmx on 16/1/13.
//  Copyright © 2016年 com. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (YHTTPService *)service {
    if (_service == nil) {
        _service = [YHTTPService service];
        _service.delegate = self;
    }
    return _service;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ControllerColor;
}

- (void)pushViewController:(UIViewController *)controller animated:(BOOL)animated {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationController pushViewController:controller animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)showNoticeWithStatus:(NSString *)status {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:status delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [av show];
}

@end
