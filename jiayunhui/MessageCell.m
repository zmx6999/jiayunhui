//
//  MessageCell.m
//  jiayunhui
//
//  Created by zmx on 16/1/14.
//  Copyright © 2016年 com. All rights reserved.
//

#import "MessageCell.h"
#import "Message.h"

@interface MessageCell ()

@property (weak, nonatomic) IBOutlet UIView *innerView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation MessageCell

- (void)awakeFromNib {
    self.innerView.layer.borderWidth = 1;
    self.innerView.layer.borderColor = Color(0xd1, 0xd1, 0xd1).CGColor;
}

- (void)setMessage:(Message *)message {
    _message = message;
    
    self.titleLabel.text = message.title;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BaseImageURLStr, message.url]] placeholderImage:[UIImage imageNamed:@"mrtp1"]];
}

@end
