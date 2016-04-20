//
//  CityViewController.h
//  jiayunhui
//
//  Created by zmx on 16/1/14.
//  Copyright © 2016年 com. All rights reserved.
//

#import "BaseViewController.h"

@class CityViewController;

@protocol CityViewControllerDelegate <NSObject>

- (void)cityViewController:(CityViewController *)cityViewController didSetCity:(NSString *)city;

@end

@interface CityViewController : BaseViewController

@property (nonatomic, weak) id<CityViewControllerDelegate> delegate;

@end
