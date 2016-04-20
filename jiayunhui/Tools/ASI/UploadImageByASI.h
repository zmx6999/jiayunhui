//
//  UploadImageByASI.h
//  js-dx-zqt
//
//  Created by lidazhen on 15/3/2.
//  Copyright (c) 2015年 lidazhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
@protocol UploadImageByASIDelegate <NSObject>

@optional
-(void)uploadImageByASIFinish:(ASIFormDataRequest *)formRequest;
-(void)uploadImageByASIFail:(ASIFormDataRequest *)formRequest;
@end
@interface UploadImageByASI : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate>
@property (nonatomic, weak) id<UploadImageByASIDelegate> delegate;
-(void)uploadImagesWithURL:(NSURL *)url andArgs:(NSDictionary *)argDic andImageDataArray:(NSArray *) imageDataArray andImageName:(NSString *) imageName;
@end
