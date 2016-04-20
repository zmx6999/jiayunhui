//
//  LaunchViewController.m
//  jiayunhui
//
//  Created by zmx on 16/1/13.
//  Copyright © 2016年 com. All rights reserved.
//

#import "LaunchViewController.h"
#import "ViewController.h"

#define RequestGetCityID 0

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.service getHTTPRequestAsyncPath:[NSString stringWithFormat:@"%@getCityList.do", BaseURLStr] HTTPHeader:nil parameters:nil requestServiceType:RequestServiceGeneral requestTag:RequestGetCityID];
}

- (void)responseSuccess:(id)responseObject requestOperation:(AFHTTPRequestOperation *)requestOperation requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    if (requestTag == RequestGetCityID) {
        NSArray *cities = [responseObject objectFromJSONData];
        for (int i = 0; i < cities.count; i++) {
            if ([[cities[i] valueForKey:@"name"] isEqualToString:@"北京"]) {
                SharedUser.cityID = [cities[i] valueForKey:@"id"];
                break;
            }
        }
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]] animated:YES completion:nil];
    }
}

- (void)responseFailure:(AFHTTPRequestOperation *)requestOperation error:(NSError *)error requestTag:(NSInteger)requestTag otherFlags:(NSDictionary *)otherFlags {
    if (requestTag == RequestGetCityID) {
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
