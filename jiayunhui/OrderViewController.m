//
//  OrderViewController.m
//  jiayunhui
//
//  Created by zmx on 16/1/16.
//  Copyright © 2016年 com. All rights reserved.
//

#import "OrderViewController.h"
#import "Order.h"
#import "OrderCell.h"
#import "PayViewController.h"
#import "OrderDetailViewController.h"

#define RequestOrder 0

@interface OrderViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *orders;

@end

static NSString *ID = @"order";

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单列表";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderCell" bundle:nil] forCellReuseIdentifier:ID];
    
    [SVProgressHUD show];
    [self.service getHTTPRequestAsyncPath:[NSString stringWithFormat:@"%@myOrderList.do?mobilephone=%@", BaseURLStr, SharedUser.mobilephone] HTTPHeader:nil parameters:nil requestServiceType:RequestServiceGeneral requestTag:RequestOrder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.order = self.orders[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Order *order = self.orders[indexPath.row];
    if ([order.pay isEqualToString:@"YES"]) {
        OrderDetailViewController *ovc = [[OrderDetailViewController alloc] init];
        ovc.title = order.servename;
        ovc.orderId = order.idstr;
        [self pushViewController:ovc animated:YES];
    } else {
        PayViewController *pvc = [[PayViewController alloc] init];
        pvc.orderID = order.idstr;
        [self pushViewController:pvc animated:YES];
    }
}

- (void)responseSuccess:(id)responseObject requestOperation:(AFHTTPRequestOperation *)requestOperation requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    if (requestTag == RequestOrder) {
        [SVProgressHUD dismiss];
        NSArray *orders = [responseObject objectFromJSONData];
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dict in orders) {
            Order *order = [Order orderWithDict:dict];
            [arrM addObject:order];
        }
        self.orders = arrM;
        [self.tableView reloadData];
        
        if (self.orders.count == 0) {
            [self showNoticeWithStatus:@"你还没有生成订单"];
        }
    }
}

- (void)responseFailure:(AFHTTPRequestOperation *)requestOperation error:(NSError *)error requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    if (requestTag == RequestOrder) {
        [SVProgressHUD dismiss];
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
