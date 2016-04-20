//
//  OrderCell.m
//  jiayunhui
//
//  Created by zmx on 16/1/16.
//  Copyright © 2016年 com. All rights reserved.
//

#import "OrderCell.h"
#import "Order.h"

@interface OrderCell ()

@property (weak, nonatomic) IBOutlet UILabel *idLabel;

@property (weak, nonatomic) IBOutlet UILabel *payLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *finishLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation OrderCell

- (void)awakeFromNib {
    // Initialization code
    self.detailLabel.layer.borderWidth = 1;
    self.detailLabel.layer.borderColor = Color(0xa6, 0xa6, 0xa6).CGColor;
}

- (void)setOrder:(Order *)order {
    _order = order;
    
    self.idLabel.text = [NSString stringWithFormat:@"订单号：%@", order.orderno];
    if ([order.pay isEqualToString:@"YES"]) {
        self.payLabel.text = @"已支付";
        self.payLabel.textColor = [UIColor blackColor];
    } else {
        self.payLabel.text = @"未支付";
        self.payLabel.textColor = [UIColor redColor];
    }
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BaseImageURLStr, order.iconurl]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.finishLabel.text = [NSString stringWithFormat:@"%@  %@", order.finishNodeName, order.finishNodeStatus];
    self.timeLabel.text = order.placedate;
    self.serviceLabel.text = order.servename;
    
    if ([order.finish isEqualToString:@"YES"]) {
        self.idLabel.textColor = [UIColor grayColor];
        self.payLabel.textColor = [UIColor grayColor];
        self.finishLabel.textColor = [UIColor grayColor];
        self.timeLabel.textColor = [UIColor grayColor];
        self.serviceLabel.textColor = [UIColor grayColor];
        self.detailLabel.textColor = [UIColor grayColor];
        self.finishLabel.text = @"订单已完成";
    } else {
        self.idLabel.textColor = Color(0x45, 0x45, 0x45);
        self.finishLabel.textColor = Color(0x45, 0x45, 0x45);
        self.timeLabel.textColor = Color(0x45, 0x45, 0x45);
        self.serviceLabel.textColor = Color(0x45, 0x45, 0x45);
        self.detailLabel.textColor = [UIColor blackColor];
    }
}

@end
