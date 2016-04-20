//
//  SexButton.m
//  jiayunhui
//
//  Created by zmx on 16/1/18.
//  Copyright © 2016年 com. All rights reserved.
//

#import "SexButton.h"

@implementation SexButton

- (void)setSex:(BOOL)sex {
    _sex = sex;
    [self setImage:[UIImage imageNamed:sex ?@"women" : @"man"] forState:UIControlStateNormal];
}

@end
