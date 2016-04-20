//
//  ServiceViewController.m
//  jiayunhui
//
//  Created by zmx on 16/1/13.
//  Copyright © 2016年 com. All rights reserved.
//

#import "ServiceViewController.h"
#import "ServiceCell.h"
#import "Service.h"
#import "ServiceDetailViewController.h"

#define RequestGetService 0

@interface ServiceViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@property (nonatomic, weak) ZMXRefreshView *header;

@property (nonatomic, strong) NSArray *services;

@end

static NSString *ID = @"service";

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.titleName;
    [self setupCollectionView];
    [self setupRefreshView];
}

- (void)setupCollectionView {
    CGFloat width = (ScreenWidth - 2) / 2;
    self.layout.itemSize = CGSizeMake(width, width);
    [self.collectionView registerNib:[UINib nibWithNibName:@"ServiceCell" bundle:nil] forCellWithReuseIdentifier:ID];
}

- (void)setupRefreshView {
    ZMXRefreshView *header = [ZMXRefreshView refreshView];
    self.header = header;
    self.header.scrollView = self.collectionView;
    self.header.refreshBegin = ^ {
        [self loadData];
    };
    self.header.tag = [self.parentServiceID integerValue];
    [self.header beginRefreshing];
}

- (void)loadData {
    [self.service getHTTPRequestAsyncPath:[NSString stringWithFormat:@"%@getSubServiceList.do?cityid=%@&parentid=%@", BaseURLStr, SharedUser.cityID, self.parentServiceID] HTTPHeader:nil parameters:nil requestServiceType:RequestServiceGeneral requestTag:RequestGetService];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.services.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ServiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.service = self.services[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ServiceDetailViewController *svc = [[ServiceDetailViewController alloc] init];
    Service *service = self.services[indexPath.item];
    svc.serviceId = service.idstr;
    svc.serviceName = service.name;
    [self pushViewController:svc animated:YES];
}

- (void)responseSuccess:(id)responseObject requestOperation:(AFHTTPRequestOperation *)requestOperation requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    [self.header endRefreshing:YES];
    if (requestTag == RequestGetService) {
        NSArray *services = [responseObject objectFromJSONData];
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dict in services) {
            Service *service = [Service serviceWithDict:dict];
            [arrM addObject:service];
        }
        self.services = arrM;
        [self.collectionView reloadData];
    }
}

- (void)responseFailure:(AFHTTPRequestOperation *)requestOperation error:(NSError *)error requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    [self.header endRefreshing:NO];
    if (requestTag == RequestGetService) {
        [self showNoticeWithStatus:@"服务器返回错误"];
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
