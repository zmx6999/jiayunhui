//
//  HomeCell.m
//  jiayunhui
//
//  Created by zmx on 16/1/12.
//  Copyright © 2016年 com. All rights reserved.
//

#import "HomeCell.h"

@interface HomeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iv;

@end

@implementation HomeCell

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;    
    self.iv.image = [UIImage imageNamed:imgName];
}

@end
