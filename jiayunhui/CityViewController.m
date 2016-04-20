//
//  CityViewController.m
//  jiayunhui
//
//  Created by zmx on 16/1/14.
//  Copyright © 2016年 com. All rights reserved.
//

#import "CityViewController.h"
#import "CityCell.h"

#define RequestGetCityList 0

@interface CityViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *openCities;

@property (nonatomic, strong) NSArray *noOpenCities;

@end

static NSString *ID = @"city";

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"城市区域";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CityCell" bundle:nil] forCellReuseIdentifier:ID];
    
    [self.service getHTTPRequestAsyncPath:[NSString stringWithFormat:@"%@getCityList.do", BaseURLStr] HTTPHeader:nil parameters:nil requestServiceType:RequestServiceGeneral requestTag:RequestGetCityList];
}

- (void)responseSuccess:(id)responseObject requestOperation:(AFHTTPRequestOperation *)requestOperation requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    if (requestTag == RequestGetCityList) {
        NSArray *cities = [responseObject objectFromJSONData];
        
        NSMutableArray *openM = [NSMutableArray array];
        NSMutableArray *noOpenM = [NSMutableArray array];
        for (int i = 0; i < cities.count; i++) {
            if ([[cities[i] valueForKey:@"openstatus"] isEqualToString:@"已开通"]) {
                [openM addObject:[cities[i] valueForKey:@"name"]];
            } else {
                [noOpenM addObject:[cities[i] valueForKey:@"name"]];
            }
        }
        self.openCities = openM;
        self.noOpenCities = noOpenM;
        [self.tableView reloadData];
    }
}

- (void)responseFailure:(AFHTTPRequestOperation *)requestOperation error:(NSError *)error requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    if (requestTag == RequestGetCityList) {
        [self showNoticeWithStatus:@"服务器返回错误"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section > 0 ?self.noOpenCities.count : self.openCities.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CityCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (indexPath.section == 0) {
        cell.label.textColor = [UIColor redColor];
        cell.label.text = self.openCities[indexPath.row];
    } else {
        cell.label.textColor = [UIColor lightGrayColor];
        cell.label.text = self.noOpenCities[indexPath.row];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *nibName = @"OpenCitySectionHeader";
    if (section > 0) {
        nibName = @"NoOpenCitySectionHeader";
    }
    return [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] firstObject];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section > 0 ?55 : 45);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section== 0) {
        if ([self.delegate respondsToSelector:@selector(cityViewController:didSetCity:)]) {
            [self.delegate cityViewController:self didSetCity:self.openCities[indexPath.row]];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self showNoticeWithStatus:@"暂未开通服务"];
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
