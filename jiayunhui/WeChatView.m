
//
//  WeChatView.m
//  jiayunhui
//
//  Created by zmx on 16/1/12.
//  Copyright © 2016年 com. All rights reserved.
//

#import "WeChatView.h"

@interface WeChatView () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *qrCodeIv;

@property (nonatomic, strong) UIAlertView *saveAv;
@property (nonatomic, strong) UIAlertView *finishAv;

@end

@implementation WeChatView

- (IBAction)remove:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)saveQRCode:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.saveAv = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否保存到相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [self.saveAv show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == self.saveAv) {
        if (buttonIndex == 1) {
            UIImageWriteToSavedPhotosAlbum(self.qrCodeIv.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = @"保存图片成功";
    if (error != nil) {
        msg = @"保存图片失败";
    }
    self.finishAv = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [self.finishAv show];
}

@end
