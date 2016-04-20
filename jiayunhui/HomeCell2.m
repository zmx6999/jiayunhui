//
//  HomeCell2.m
//  jiayunhui
//
//  Created by zmx on 16/1/12.
//  Copyright © 2016年 com. All rights reserved.
//

#import "HomeCell2.h"

@interface HomeCell2 ()

@property (weak, nonatomic) IBOutlet UIImageView *iv;

@property (weak, nonatomic) IBOutlet UILabel *titleView;

@end

@implementation HomeCell2

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;
    self.iv.image = [UIImage imageNamed:imgName];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleView.text = title;
}

@end
