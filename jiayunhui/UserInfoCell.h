//
//  UserInfoCell.h
//  jiayunhui
//
//  Created by zmx on 16/1/18.
//  Copyright © 2016年 com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SexButton.h"

@class UserInfoCell;

@protocol UserInfoCellDelegate <NSObject>

- (void)userInfoCell:(UserInfoCell *)userInfoCell didSelectPhoto:(NSString *)photourl;

@end

@interface UserInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumText;

@property (weak, nonatomic) IBOutlet SexButton *sexButton;

@property (nonatomic, weak) id<UserInfoCellDelegate> delegate;

@end
