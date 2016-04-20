//
//  UserInfoCell.m
//  jiayunhui
//
//  Created by zmx on 16/1/18.
//  Copyright © 2016年 com. All rights reserved.
//

#import "UserInfoCell.h"
#import "SexButton.h"

@interface UserInfoCell () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIActionSheet *actionSheet;

@end

@implementation UserInfoCell

- (IBAction)changeSex:(SexButton *)sender {
    sender.sex = !sender.sex;
}

- (IBAction)changeIcon:(UITapGestureRecognizer *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"修改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet showInView:[self getViewController].view];
}

- (void)awakeFromNib {
    self.iconView.layer.cornerRadius = ScreenHeight * 0.059;
    self.iconView.layer.masksToBounds = YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [[self getViewController] presentViewController:picker animated:YES completion:nil];
            break;
        }
            
        case 1: {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [[self getViewController] presentViewController:picker animated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSData *data = UIImageJPEGRepresentation(image, 0.1);
    NSString *photourl = [GTMBase64 stringByEncodingData:data];
    if ([self.delegate respondsToSelector:@selector(userInfoCell:didSelectPhoto:)]) {
        [self.delegate userInfoCell:self didSelectPhoto:photourl];
    }
}

@end