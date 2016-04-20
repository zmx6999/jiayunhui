//
//  UploadImageByASI.m
//  js-dx-zqt
//
//  Created by lidazhen on 15/3/2.
//  Copyright (c) 2015年 lidazhen. All rights reserved.
//

#import "UploadImageByASI.h"

@implementation UploadImageByASI

- (id)init
{
    self = [super init];
    
    if (self) {
        
    }
    return self;
}
-(void)uploadImagesWithURL:(NSURL *)url andArgs:(NSDictionary *)argDic  andImageDataArray:(NSArray *) imageDataArray andImageName:(NSString *)imageName{
    ASIFormDataRequest *form = [[ASIFormDataRequest alloc]
                                initWithURL:url] ;
    [form setTimeOutSeconds:60.0];
    form.delegate = self;
    [form setRequestMethod:@"POST"];
    [form setPostFormat:ASIMultipartFormDataPostFormat];
    [form setUploadProgressDelegate:self];
    [form setBytesSentBlock:^(unsigned long long size, unsigned long long total) {
        NSLog(@"###########%lld---%lld",size,total);
    }];
    if (argDic!=nil) {
         [form setPostValue:[[argDic allValues] objectAtIndex:0] forKey:[[argDic allKeys] objectAtIndex:0]];
    }
   
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyMMddHHMMss"];
   
    if (imageDataArray!=nil&&[imageDataArray count]>0) {
        for (NSData *imageData in imageDataArray) {
//            NSDate*date=[NSDate date];
//            NSString*dateStr=[formatter stringFromDate:date];
//            NSString *photoName = [NSString stringWithFormat:@"IMG_%@",dateStr];
             [form addData:imageData withFileName:imageName andContentType:@"image/png" forKey:@"fileData"];
        }
    }
    
 
    [form setDidFinishSelector:@selector(uploadFinish:)];
    [form setDidFailSelector:@selector(uploadFail:)];
    [form startSynchronous];
}
-(void)uploadFinish:(ASIFormDataRequest *)formRequest{
    if ([self.delegate conformsToProtocol:@protocol(UploadImageByASIDelegate)]) {
        if ([self.delegate respondsToSelector:@selector(uploadImageByASIFinish:)]) {
            [self.delegate uploadImageByASIFinish:formRequest];
        }
    }

}
-(void)uploadFail:(ASIFormDataRequest *)formRequest{
    
    if ([self.delegate conformsToProtocol:@protocol(UploadImageByASIDelegate)]) {
        if ([self.delegate respondsToSelector:@selector(uploadImageByASIFail:)]) {
            [self.delegate uploadImageByASIFinish:formRequest];
        }
    }
    
}
-(void)requestStarted:(ASIHTTPRequest *)request{
    NSLog(@"---start----");
}
-(void)requestFinished:(ASIHTTPRequest *)request{
 NSLog(@"---finsh----");
}
-(void)requestFailed:(ASIHTTPRequest *)request{
NSLog(@"---fail----");
}

-(void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes{
 NSLog(@"---didSendBytes----%lld",bytes);
}
-(void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength{
NSLog(@"---incrementUploadSizeBy----");
    
}

@end
