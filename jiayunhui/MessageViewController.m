//
//  MessageViewController.m
//  jiayunhui
//
//  Created by zmx on 16/1/14.
//  Copyright © 2016年 com. All rights reserved.
//

#import "MessageViewController.h"
#import "Message.h"
#import "MessageCell.h"
#import "MessageDetailViewController.h"

#define RequestGetMessage 0

@interface MessageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, weak) ZMXRefreshView *header;

@property (nonatomic, strong) NSArray *messages;

@end

static NSString *ID = @"message";

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"新闻资讯";
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:ID];
    [self setupRefreshView];
}

- (void)setupRefreshView {
    ZMXRefreshView *header = [ZMXRefreshView refreshView];
    self.header = header;
    self.header.scrollView = self.tableView;
    self.header.refreshBegin = ^{
        [self loadData];
    };
    self.header.tag = 100;
    [self.header beginRefreshing];
}

- (void)loadData {
    [self.service getHTTPRequestAsyncPath:[NSString stringWithFormat:@"%@messageList.do", BaseURLStr] HTTPHeader:nil parameters:nil requestServiceType:RequestServiceGeneral requestTag:RequestGetMessage];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.message = self.messages[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messages[indexPath.row];
    MessageDetailViewController *mvc = [[MessageDetailViewController alloc] init];
    mvc.href = message.href;
    [self pushViewController:mvc animated:YES];
}

- (void)responseSuccess:(id)responseObject requestOperation:(AFHTTPRequestOperation *)requestOperation requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    [self.header endRefreshing:YES];
    if (requestTag == RequestGetMessage) {
        NSArray *messages = [responseObject objectFromJSONData];
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dict in messages) {
            Message *message = [Message messageWithDict:dict];
            [arrM addObject:message];
        }
        self.messages = arrM;
        [self.tableView reloadData];
    }
}

- (void)responseFailure:(AFHTTPRequestOperation *)requestOperation error:(NSError *)error requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    [self.header endRefreshing:NO];
    if (requestTag == RequestGetMessage) {
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
