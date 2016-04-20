//
//  ViewController.m
//  jiayunhui
//
//  Created by zmx on 16/1/12.
//  Copyright © 2016年 com. All rights reserved.
//

#import "ViewController.h"
#import "HomeCell.h"
#import "HomeCell2.h"
#import "HomeCell3.h"
#import "LoginViewController.h"
#import "ServiceViewController.h"
#import "MessageViewController.h"
#import "CCLocationManager.h"
#import "MMLocationManager.h"
#import "CityViewController.h"
#import "SettingViewController.h"
#import "OrderViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, CityViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *cellImages;
@property (nonatomic, strong) NSArray *parentServiceIDs;
@property (nonatomic, strong) NSArray *titleNames;

@property (nonatomic, strong) NSArray *cell2Images;
@property (nonatomic, strong) NSArray *cell2Titles;

@property (nonatomic, strong) CLLocationManager *manager;

@property (nonatomic, copy) NSString *city;

@end

@implementation ViewController

- (NSArray *)cellImages {
    if (_cellImages == nil) {
        _cellImages = @[@"gsfw", @"csfw", @"rlfw", @"zxfw"];
    }
    return _cellImages;
}

- (NSArray *)parentServiceIDs {
    if (_parentServiceIDs == nil) {
        _parentServiceIDs = @[@"111", @"112", @"114", @"136"];
    }
    return _parentServiceIDs;
}

- (NSArray *)titleNames {
    if (_titleNames == nil) {
        _titleNames = @[@"工商服务", @"财税服务", @"人力服务", @"专项服务"];
    }
    return _titleNames;
}

- (NSArray *)cell2Images {
    if (_cell2Images == nil) {
        _cell2Images = @[@"home_news", @"home_order"];
    }
    return _cell2Images;
}

- (NSArray *)cell2Titles {
    if (_cell2Titles == nil) {
        _cell2Titles = @[@"新闻资讯", @"我的订单"];
    }
    return _cell2Titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (reachability.currentReachabilityStatus == NotReachable) {
        [self showNoticeWithStatus:@"没有可用网络,请您先设置网络"];
    } else {
        [self setupUI];
        [self setupCity];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"Home"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Home"];
}

- (void)setupUI {
    self.navigationItem.title = @"嘉芸汇";
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, 25, 25);
    [button setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = NO;
    [button addTarget:self action:@selector(settings) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)setupCity {
    if (iOS8) {
        self.manager = [[CLLocationManager alloc] init];
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        [self.manager requestAlwaysAuthorization];
        [self.manager requestWhenInUseAuthorization];
        
        [[CCLocationManager shareLocation] getCity:^(NSString *addressString) {
            NSArray *cities = [addressString componentsSeparatedByString:@"市"];
            self.city = cities.firstObject;
            if (![self.city isEqualToString:@"北京"]) {
                [self showNoticeWithStatus:@"当前城市暂未开通服务,已开通城市为北京"];
            }
            [self setupLeftBarButtonItem];
        }];
    } else {
        [[MMLocationManager shareLocation] getCity:^(NSString *addressString) {
            NSArray *cities = [addressString componentsSeparatedByString:@"市"];
            self.city = cities.firstObject;
            if (![self.city isEqualToString:@"北京"]) {
                [self showNoticeWithStatus:@"当前城市暂未开通服务,已开通城市为北京"];
            }
            [self setupLeftBarButtonItem];
        }];
    }
}

- (void)setupLeftBarButtonItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.city style:UIBarButtonItemStylePlain target:self action:@selector(cityList)];
}

- (void)cityList {
    CityViewController *cvc = [[CityViewController alloc] init];
    cvc.delegate = self;
    [self pushViewController:cvc animated:YES];
}

- (void)settings {
    SettingViewController *svc = [[SettingViewController alloc] init];
    [self pushViewController:svc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 4) {
        HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"home"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:nil options:nil] firstObject];
        }
        cell.imgName = self.cellImages[indexPath.row];
        return cell;
    } else if (indexPath.row < 6) {
        HomeCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"home2"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeCell2" owner:nil options:nil] firstObject];
        }
        cell.imgName = self.cell2Images[indexPath.row - 4];
        cell.title = self.cell2Titles[indexPath.row - 4];
        return cell;
    } else {
        HomeCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"home3"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeCell3" owner:nil options:nil] firstObject];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 4) {
        return ScreenWidth * 1.09;
    } else if (indexPath.row < 6) {
        return 50;
    } else {
        return 270;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        case 1:
        case 2:
        case 3: {
            ServiceViewController *svc = [[ServiceViewController alloc] init];
            svc.parentServiceID = self.parentServiceIDs[indexPath.row];
            svc.titleName = self.titleNames[indexPath.row];
            [self pushViewController:svc animated:YES];
            break;
        }
            
        case 4: {
            MessageViewController *mvc = [[MessageViewController alloc] init];
            [self pushViewController:mvc animated:YES];
            break;
        }
            
        case 5: {
            if (SharedUser.isLogin) {
                OrderViewController *ovc = [[OrderViewController alloc] init];
                [self pushViewController:ovc animated:YES];
            } else {
                LoginViewController *lvc = [[LoginViewController alloc] init];
                lvc.type = @"home";
                [self pushViewController:lvc animated:YES];
            }
            break;
        }
            
        default:
            break;
    }
}

- (void)cityViewController:(CityViewController *)cityViewController didSetCity:(NSString *)city {
    self.city = city;
    self.navigationItem.leftBarButtonItem.title = city;
}

@end