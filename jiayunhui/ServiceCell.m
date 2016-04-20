//
//  ServiceCell.m
//  jiayunhui
//
//  Created by zmx on 16/1/13.
//  Copyright © 2016年 com. All rights reserved.
//

#import "ServiceCell.h"
#import "Service.h"

@interface ServiceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ServiceCell

- (void)setService:(Service *)service {
    _service = service;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BaseImageURLStr, service.iconurl]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

@end
