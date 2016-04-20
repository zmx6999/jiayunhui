//
//  ViewController.m
//  图片压缩尺寸
//
//  Created by zmx on 16/1/28.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIWebViewDelegate>

@property (nonatomic, strong) ASIFormDataRequest *request;

@property (nonatomic, copy) NSString *backId;

@end

@implementation OrderDetailViewController

- (void)loadView {
    self.view = [[UIWebView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIWebView *webView = (UIWebView *)self.view;
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@orderdetail?oid=%@&mobile=%@&from=ios", BaseImageURLStr, self.orderId, SharedUser.mobilephone]]]];
//    [self changeHeadPhoto];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"网络无法连接"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = request.URL;
    if ([url.scheme isEqualToString:@"myphoto"]) {
        NSString *host = url.host;
        NSArray *arr = [host componentsSeparatedByString:@"&"];
        self.backId = arr[1];
        [self changeHeadPhoto];
        return NO;
    }
    return YES;
}

- (void)changeHeadPhoto {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
            break;
        }
            
        case 1: {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo {
    [picker dismissViewControllerAnimated:YES completion:nil];
    //图片压缩尺寸
    UIImage *compressImage = [self compressImage:image toSize:CGSizeMake(200, 200)];
    
    
    //本地沙盒缓存
    NSString *basepath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"images"];
    [[NSFileManager defaultManager] createDirectoryAtPath:basepath withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *filepath = [basepath stringByAppendingPathComponent:@"cachephoto.jpg"];
    NSData *data = UIImageJPEGRepresentation(compressImage, 1.0);
    [data writeToFile:filepath atomically:YES];
    
    //上传服务器
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/user", BaseImageURLStr]]];
//    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://192.168.31.196/upload.php"]];
    self.request.requestMethod = @"POST";
    self.request.timeOutSeconds = 20;
    [self.request addFile:filepath forKey:@"file"];
    
    __weak typeof(self.request) weakRequest = self.request;
    __weak typeof(self) weakSelf = self;
    [self.request setCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [(UIWebView *)weakSelf.view stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"previewImage(\"%@\",\"%@\")", weakRequest.responseString, weakSelf.backId]];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[weakRequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
            if ([dict[@"success"] intValue] > 0) {
                [weakSelf showNoticeWithStatus:@"图片上传成功"];
            } else {
                [weakSelf showNoticeWithStatus:@"图片上传失败, 请稍后重试!"];
            }
        });
    }];
    [self.request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showNoticeWithStatus:@"图片上传失败, 请稍后重试!"];
        });
    }];
    
    [self.request startAsynchronous];
}

- (UIImage *)compressImage:(UIImage *)image toSize:(CGSize)size {
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    CGFloat widthFactor = width / imageWidth;
    CGFloat heightFactor = height / imageHeight;
    
    CGFloat factor = (widthFactor > heightFactor ?heightFactor : widthFactor);
    CGFloat compressWidth = imageWidth * factor;
    CGFloat compressHeight = imageHeight * factor;
    
    CGRect rect = CGRectZero;
    rect.size.width = compressWidth;
    rect.size.height = compressHeight;
    
    if (widthFactor > heightFactor) {
        rect.origin.x = (width - compressWidth) * 0.5;
    } else {
        rect.origin.y = (height - compressHeight) * 0.5;
    }
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:rect];
    UIImage *compressImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressImage;
}

@end