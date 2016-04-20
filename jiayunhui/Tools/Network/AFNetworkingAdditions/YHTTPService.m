//
//  YHTTPService.m
//  ztesoftLibs2
//
//  Created by wangyang on 14-1-8.
//  Copyright (c) 2014年 ztesoft. All rights reserved.
//

#import "YHTTPService.h"

@implementation YHTTPService
{
    YHTTPServiceUseBlock *_httpServiceUserBlock;
}

//创建并返回一个新的 YHTTPServiceUseBlock 实例
+(instancetype)service
{
    return [[YHTTPService alloc]init];
}

#pragma mark - init
-(id)init
{
    self=[super init];
    if (self)
    {
        _httpServiceUserBlock = [YHTTPServiceUseBlock service];
    }
    return self;
}

#pragma mark - method
//默认的执行队列
+(NSOperationQueue*)sharedYHTTPServiceOperationQueue
{
    return [YHTTPServiceUseBlock sharedYHTTPServiceOperationQueue];
}

//post 一个请求
-(AFHTTPRequestOperation*)postHTTPRequestAsyncPath:(NSString*)path
                                        HTTPHeader:(NSDictionary *)HTTPHeader
                                        parameters:(id)parameters
                                requestServiceType:(RequestServiceType)requestServiceType
                                        requestTag:(NSInteger)requestTag
{
    [self setDelegateToBlock];
    
    return [_httpServiceUserBlock sendHTTPRequestAsyncMethod:@"POST"
                                                        Path:path
                                                  HTTPHeader:HTTPHeader
                                                  parameters:parameters
                                          requestServiceType:requestServiceType
                                                  requestTag:requestTag];
}

//get 一个请求
-(AFHTTPRequestOperation*)getHTTPRequestAsyncPath:(NSString*)path
                                       HTTPHeader:(NSDictionary *)HTTPHeader
                                       parameters:(id)parameters
                               requestServiceType:(RequestServiceType)requestServiceType
                                       requestTag:(NSInteger)requestTag
{
    [self setDelegateToBlock];
    
    return [_httpServiceUserBlock sendHTTPRequestAsyncMethod:@"GET"
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
    [self setDelegateToBlock];
    
    return [_httpServiceUserBlock sendHTTPRequestAsync:URLRequest
                                    requestServiceType:requestServiceType
                                            requestTag:requestTag];
}

//生成一个AFHTTPRequestOperation对象,但并不放入执行队列中
-(AFHTTPRequestOperation*)HTTPRequestOperationWithRequest:(NSMutableURLRequest *)URLRequest
                                       requestServiceType:(RequestServiceType)requestServiceType
                                               requestTag:(NSInteger)requestTag
{
    [self setDelegateToBlock];
    
    return [_httpServiceUserBlock HTTPRequestOperationWithRequest:URLRequest
                                               requestServiceType:requestServiceType
                                                       requestTag:requestTag];
}

//取消所有的 http 请求
+(void)cancelAllHttpRequest
{
    [YHTTPServiceUseBlock cancelAllHttpRequest];
}

#pragma mark - private method
//设置代理去响应 http 请求事件
-(void)setDelegateToBlock
{
    __weak __typeof(self) weakSelf=self;
    
    [_httpServiceUserBlock setResponseSuccessBlock:^(id responseObject, AFHTTPRequestOperation *operation, NSInteger requestTag, NSDictionary *otherFlags) {
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(responseSuccess:requestOperation:requestTag:otherFlags:)])
        {
            [strongSelf.delegate responseSuccess:responseObject
                              requestOperation:operation
                                    requestTag:requestTag
                                    otherFlags:otherFlags];
        }
    }];
    
    [_httpServiceUserBlock setResponseFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error, NSInteger requestTag, NSDictionary *otherFlags) {
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(responseFailure:error:requestTag:otherFlags:)])
        {
            [strongSelf.delegate responseFailure:operation
                                         error:error
                                    requestTag:requestTag
                                    otherFlags:otherFlags];
        }
    }];
    
    [_httpServiceUserBlock setUploadProgressBlock:^(NSMutableURLRequest *request, float progress, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite,NSInteger requestTag, NSDictionary *otherFlags) {
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(requestUploadProgress:progress:totalBytesWritten:totalBytesExpectedToWrite:requestTag:otherFlags:)])
        {
            [strongSelf.delegate requestUploadProgress:request
                                            progress:progress
                                   totalBytesWritten:totalBytesWritten
                           totalBytesExpectedToWrite:totalBytesExpectedToWrite
                                          requestTag:requestTag
                                          otherFlags:otherFlags];
        }
    }];
    
    [_httpServiceUserBlock setDownloadProgressBlock:^(NSMutableURLRequest *request, float progress, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead, NSInteger requestTag, NSDictionary *otherFlags) {
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(requestDownloadProgress:progress:totalBytesRead:totalBytesExpectedToRead:requestTag:otherFlags:)])
        {
            [strongSelf.delegate requestDownloadProgress:request
                                              progress:progress
                                        totalBytesRead:totalBytesRead
                              totalBytesExpectedToRead:totalBytesExpectedToRead
                                            requestTag:requestTag
                                            otherFlags:otherFlags];
        }
    }];
}

@end
