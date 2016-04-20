//
//  YHTTPServiceUseBlock.m
//  ztesoftLibs2
//
//  Created by wangyang on 14-1-9.
//  Copyright (c) 2014年 ztesoft. All rights reserved.
//

#import "YHTTPServiceUseBlock.h"
#import "Base64JSONRequestSerializer.h"
#import "Base64JSONResponseSerializer.h"

@interface YHTTPServiceUseBlock()

@property (strong,nonatomic) void (^responseSuccessBlock)(id responseObject,AFHTTPRequestOperation *operation,NSInteger requestTag, NSDictionary *otherFlags);

@property (strong,nonatomic) void (^responseFailureBlock)(AFHTTPRequestOperation *operation, NSError *error, NSInteger requestTag, NSDictionary *otherFlags);

@property (strong,nonatomic) void (^uploadProgressBlock)(NSMutableURLRequest *request, float progress, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, NSInteger requestTag, NSDictionary *otherFlags);

@property (strong,nonatomic) void (^downloadProgressBlock)(NSMutableURLRequest *request, float progress, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead, NSInteger requestTag, NSDictionary *otherFlags);

@end

@implementation YHTTPServiceUseBlock

//创建并返回一个新的 YHTTPServiceUseBlock 实例
+(instancetype)service
{
    return [[YHTTPServiceUseBlock alloc]init];
}

//默认的执行队列
+(NSOperationQueue*)sharedYHTTPServiceOperationQueue
{
    static NSOperationQueue *_sharedYHTTPServiceOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedYHTTPServiceOperationQueue = [[NSOperationQueue alloc] init];
    });
    
    return _sharedYHTTPServiceOperationQueue;
}

//取消所有的 http 请求
+(void)cancelAllHttpRequest
{
    NSArray *operations=[[YHTTPServiceUseBlock sharedYHTTPServiceOperationQueue] operations];
    for (NSOperation *operation in operations)
    {
        if ([operation isKindOfClass:[AFHTTPRequestOperation class]])
        {
            [operation cancel];
        }
    }
}

//发送一个请求
-(AFHTTPRequestOperation*)sendHTTPRequestAsyncMethod:(NSString *)method
                                                Path:(NSString*)path
                                          HTTPHeader:(NSDictionary *)HTTPHeader
                                          parameters:(id)parameters
                                  requestServiceType:(RequestServiceType)requestServiceType
                                          requestTag:(NSInteger)requestTag
{
    NSMutableURLRequest *request;
    
#pragma mark 设置 RequestSerializer
    switch (requestServiceType)
    {
        case RequestServiceGeneral:
        {
            request=[[AFHTTPRequestSerializer serializer] requestWithMethod:method URLString:path parameters:parameters error:nil];
            break;
        }
        case RequestServiceIresJSON:
        {
            request=[[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:path parameters:parameters error:nil];
            break;
        }
        case RequestServiceIresJSONWithUTF8Base64:
        {
            request=[[Base64JSONRequestSerializer serializer] requestWithMethod:method URLString:path parameters:parameters];
            break;
        }
        case RequestServiceGetImageAndCacheIt:
        {
            request=[[AFHTTPRequestSerializer serializer] requestWithMethod:method URLString:path parameters:parameters error:nil];
            [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
            break;
        }
        default:
            break;
    }
    
    for (NSString *key in HTTPHeader)
    {
        [request setValue:[HTTPHeader objectForKey:key] forHTTPHeaderField:key];
    }
    
    [request setValue:@"IResource" forHTTPHeaderField:@"User-Agent"];
    
    AFHTTPRequestOperation *requestOperation=[self sendHTTPRequestAsync:request
                                                     requestServiceType:requestServiceType
                                                             requestTag:requestTag];
    return requestOperation;
}

//发送一个请求，并设置响应成功和失败的 block
-(AFHTTPRequestOperation*)sendHTTPRequestAsyncMethod:(NSString *)method
                                                Path:(NSString*)path
                                          HTTPHeader:(NSDictionary *)HTTPHeader
                                          parameters:(id)parameters
                                  requestServiceType:(RequestServiceType)requestServiceType
                                          requestTag:(NSInteger)requestTag
                                responseSuccessBlock:(void (^)(id responseObject,
                                                               AFHTTPRequestOperation *operation,
                                                               NSInteger requestTag,
                                                               NSDictionary *otherFlags)) responseSuccessBlock
                                responseFailureBlock:(void (^)(AFHTTPRequestOperation *operation,
                                                               NSError *error,
                                                               NSInteger requestTag,
                                                               NSDictionary *otherFlags)) responseFailureBlock
{
    self.responseSuccessBlock=responseSuccessBlock;
    self.responseFailureBlock=responseFailureBlock;
    
    return [self sendHTTPRequestAsyncMethod:method
                                       Path:path
                                 HTTPHeader:HTTPHeader
                                 parameters:parameters
                         requestServiceType:requestServiceType
                                 requestTag:requestTag];
}

//发送一个 NSMutableURLRequest 对象
-(AFHTTPRequestOperation*)sendHTTPRequestAsync:(NSMutableURLRequest *)URLRequest
                            requestServiceType:(RequestServiceType)requestServiceType
                                    requestTag:(NSInteger)requestTag
{
    AFHTTPRequestOperation *requestOperation = [self HTTPRequestOperationWithRequest:URLRequest
                                                                  requestServiceType:requestServiceType
                                                                          requestTag:requestTag];
    
    [[YHTTPServiceUseBlock sharedYHTTPServiceOperationQueue] addOperation:requestOperation];
    
    return requestOperation;
}

//发送一个 NSMutableURLRequest 对象，并设置响应成功和失败的 block
-(AFHTTPRequestOperation*)sendHTTPRequestAsync:(NSMutableURLRequest *)URLRequest
                            requestServiceType:(RequestServiceType)requestServiceType
                                    requestTag:(NSInteger)requestTag
                          responseSuccessBlock:(void (^)(id responseObject,
                                                         AFHTTPRequestOperation *operation,
                                                         NSInteger requestTag,
                                                         NSDictionary *otherFlags)) responseSuccessBlock
                          responseFailureBlock:(void (^)(AFHTTPRequestOperation *operation,
                                                         NSError *error,
                                                         NSInteger requestTag,
                                                         NSDictionary *otherFlags)) responseFailureBlock
{
    self.responseSuccessBlock=responseSuccessBlock;
    self.responseFailureBlock=responseFailureBlock;
    
    return [self sendHTTPRequestAsync:URLRequest requestServiceType:requestServiceType requestTag:requestTag];
}

//生成一个AFHTTPRequestOperation对象
-(AFHTTPRequestOperation*)HTTPRequestOperationWithRequest:(NSMutableURLRequest *)URLRequest
                                       requestServiceType:(RequestServiceType)requestServiceType
                                               requestTag:(NSInteger)requestTag
{
#ifdef DEBUG
    [self printHTTPRequestLog:URLRequest];   //打印请求
#endif
    
    AFHTTPRequestOperation *requestOperation=[[AFHTTPRequestOperation alloc] initWithRequest:URLRequest];
    
#pragma mark 设置 ResponseSerializer
    switch (requestServiceType)
    {
        case RequestServiceIresJSON:
        {
            [requestOperation setResponseSerializer:[AFJSONResponseSerializer serializer]];
            break;
        }
        case RequestServiceIresJSONWithUTF8Base64:
        {
            [requestOperation setResponseSerializer:[Base64JSONResponseSerializer serializer]];
            break;
        }
        case RequestServiceGetImageAndCacheIt:
        {
            [requestOperation setResponseSerializer:[AFImageResponseSerializer serializer]];
            break;
        }
        default:
            break;
    }
    
    //响应返回
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#ifdef DEBUG
        [self printHTTPResponesLog:operation];  //打印响应
#endif
        
        switch (requestServiceType)
        {
            case RequestServiceGeneral:
            case RequestServiceGetImageAndCacheIt:
            {
                if (self.responseSuccessBlock)
                {
                    NSDictionary *otherFlags=@{OTHER_FLAGS_REQUEST_SERVICE_TYPE:[NSString stringWithFormat:@"%ld",(long)requestServiceType]};
                    self.responseSuccessBlock(responseObject,operation,requestTag,otherFlags);
                }
                
                break;
            }
            case RequestServiceIresJSON:
            case RequestServiceIresJSONWithUTF8Base64:
            {
                NSString *result=[responseObject objectForKey:@"result"];
                if ([result isEqualToString:@"000"])
                {
                    if (self.responseSuccessBlock)
                    {
                        NSDictionary *otherFlags=@{OTHER_FLAGS_REQUEST_SERVICE_TYPE:[NSString stringWithFormat:@"%ld",(long)requestServiceType]};
                        self.responseSuccessBlock(responseObject,operation,requestTag,otherFlags);
                    }
                }
                else
                {
                    if (self.responseFailureBlock)
                    {
                        NSError *error=[NSError errorWithDomain:@"IRES_ERROR"
                                                           code:[result integerValue]
                                                       userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(result, nil)}];
                        
                        NSDictionary *otherFlags=@{OTHER_FLAGS_REQUEST_SERVICE_TYPE:[NSString stringWithFormat:@"%ld",(long)requestServiceType]};
                        self.responseFailureBlock(operation,error,requestTag,otherFlags);
                    }
                }
                break;
            }
            default:
                break;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (self.responseFailureBlock)
        {
            NSDictionary *otherFlags=@{OTHER_FLAGS_REQUEST_SERVICE_TYPE:[NSString stringWithFormat:@"%ld",(long)requestServiceType]};
            self.responseFailureBlock(operation,error,requestTag,otherFlags);
        }
    }];
    
    //上传进度
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
        
        if (self.uploadProgressBlock)
        {
            if (totalBytesExpectedToWrite>0)
            {
                float progress=(float)totalBytesWritten/totalBytesExpectedToWrite;
                
                NSDictionary *otherFlags=@{OTHER_FLAGS_REQUEST_SERVICE_TYPE:[NSString stringWithFormat:@"%ld",(long)requestServiceType]};
                self.uploadProgressBlock(URLRequest,progress,totalBytesWritten,totalBytesExpectedToWrite,requestTag,otherFlags);
            }
        }
    }];
    
    //下载进度
    [requestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead) {
        
        if (self.downloadProgressBlock)
        {
            if (totalBytesExpectedToRead>0)
            {
                float progress=(float)totalBytesRead/totalBytesExpectedToRead;
                
                NSDictionary *otherFlags=@{OTHER_FLAGS_REQUEST_SERVICE_TYPE:[NSString stringWithFormat:@"%ld",(long)requestServiceType]};
                self.downloadProgressBlock(URLRequest,progress,totalBytesRead,totalBytesExpectedToRead,requestTag,otherFlags);
            }
        }
    }];
    
    return requestOperation;
}

#pragma mark - getter && setter
-(void)setResponseSuccessBlock:(void (^)(id responseObject,AFHTTPRequestOperation *operation,NSInteger requestTag, NSDictionary *otherFlags)) responseSuccessBlock
{
    _responseSuccessBlock=responseSuccessBlock;
}

-(void)setResponseFailureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error, NSInteger requestTag, NSDictionary *otherFlags)) responseFailureBlock
{
    _responseFailureBlock=responseFailureBlock;
}

-(void)setUploadProgressBlock:(void (^)(NSMutableURLRequest *request, float progress, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, NSInteger requestTag, NSDictionary *otherFlags)) uploadProgressBlock;
{
    _uploadProgressBlock=uploadProgressBlock;
}

-(void)setDownloadProgressBlock:(void(^)(NSMutableURLRequest *request, float progress, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead, NSInteger requestTag, NSDictionary *otherFlags))downloadProgressBlock
{
    _downloadProgressBlock=downloadProgressBlock;
}

#pragma mark - print log
- (void)printHTTPRequestLog:(NSMutableURLRequest* )request
{
    NSString *body=@"";
    
    if ([request HTTPBody])
    {
         body= [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    }
    else if([request HTTPBodyStream])
    {
        NSInputStream *inputStream = [request HTTPBodyStream];
        [inputStream open];

        NSInteger maxLength = 128;
        uint8_t readBuffer [maxLength];
        BOOL endOfStreamReached = NO;
        
        while (! endOfStreamReached)
        {
            NSInteger bytesRead = [inputStream read:readBuffer maxLength:maxLength];
            if (bytesRead == 0)
            {
                endOfStreamReached = YES;
            }
            else if (bytesRead == -1)
            {
                endOfStreamReached = YES;
            }
            else
            {
                for (NSInteger i=0; i<bytesRead; i++)
                {
                    if (readBuffer[i]!='\0')
                    {
                        NSString *readBufferString = [[NSString alloc] initWithBytesNoCopy:&readBuffer[i]
                                                                                    length:1
                                                                                  encoding:NSUTF8StringEncoding
                                                                              freeWhenDone:NO];
                        
                        if (readBufferString)
                        {
                            body =[body stringByAppendingString:readBufferString];
                        }
                        else
                        {
                            body =[body stringByAppendingString:@"?"];
                            break;
                        }
                    }
                }
            }
        }
    }
    
    NSLog(@"\n-------------------  Http Request Start --------------------------    \
          \nURL:            \n%@\n                                                     \
          \nRequestHeaders: \n%@\n                                                     \
          \nRequestBody:    \n%@\n                                                      \
          \n---------------------  Http Request End ----------------------------\n\n\n"
          ,[request URL],[request allHTTPHeaderFields],body);
    
}

- (void)printHTTPResponesLog:(AFHTTPRequestOperation* )requestOperation
{
    NSLog(@"\n-------------------  Http Respones Start-------------------------     \
          \nResult Code:    %ld                                                      \
          \nURL:            %@                                                      \
          \nResponseHeaders:%@                                                      \
          \nResponseBody:   %@                                                      \
          \n---------------------  Http Respones End----------------------------\n\n\n"
          ,(long)[requestOperation.response statusCode],[requestOperation.response URL],[requestOperation.response allHeaderFields],[requestOperation responseString]);
}
@end
