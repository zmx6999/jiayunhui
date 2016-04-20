//
//  YHTTPService.h
//  ztesoftLibs2
//
//  Created by wangyang on 14-1-8.
//  Copyright (c) 2014年 ztesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHTTPServiceUseBlock.h"

@protocol YHTTPServiceDelegate;

#pragma mark - interface
@interface YHTTPService : NSObject

/**
 *  代理
 */
@property (weak,nonatomic) id<YHTTPServiceDelegate> delegate;

/**
 *  创建并返回一个新的 YHTTPService 实例
 *
 *  @return 一个新的 YHTTPService 实例
 */
+(instancetype)service;

/**
 *  直接发送 http 请求时，请求的 operation 会放入到这个队列中
 *
 *  @return 默认的执行队列
 */
+(NSOperationQueue*)sharedYHTTPServiceOperationQueue;

/**
 *  POST 一个 HTTP 请求
 *
 *  @param path               请求地址
 *  @param HTTPHeader         HTTP 请求头
 *  @param parameters         HTTP 请求参数
 *  @param requestServiceType 请求类型
 *  @param requestTag         请求标识
 *
 *  @return 生成的 HTTP 请求Operation
 */
-(AFHTTPRequestOperation*)postHTTPRequestAsyncPath:(NSString*)path
                                        HTTPHeader:(NSDictionary *)HTTPHeader
                                        parameters:(id)parameters
                                requestServiceType:(RequestServiceType)requestServiceType
                                        requestTag:(NSInteger)requestTag;

/**
 *  GET 一个 HTTP 请求
 *
 *  @param path               请求地址
 *  @param HTTPHeader         HTTP 请求头
 *  @param parameters         HTTP 请求参数
 *  @param requestServiceType 请求类型
 *  @param requestTag         请求标识
 *
 *  @return 生成的 HTTP 请求Operation
 */
-(AFHTTPRequestOperation*)getHTTPRequestAsyncPath:(NSString*)path
                                       HTTPHeader:(NSDictionary *)HTTPHeader
                                       parameters:(id)parameters
                               requestServiceType:(RequestServiceType)requestServiceType
                                       requestTag:(NSInteger)requestTag;

/**
 *  发送一个已经封装好的 NSMutableURLRequest 对象
 *
 *  @param URLRequest         已经封装好的 NSMutableURLRequest 对象
 *  @param requestServiceType 请求类型
 *  @param requestTag         请求标识
 *
 *  @return 生成的 HTTP 请求Operation
 */
-(AFHTTPRequestOperation*)sendHTTPRequestAsync:(NSMutableURLRequest *)URLRequest
                            requestServiceType:(RequestServiceType)requestServiceType
                                    requestTag:(NSInteger)requestTag;

/**
 *  生成一个AFHTTPRequestOperation对象,但并不放入执行队列中
 *
 *  @param URLRequest         已经封装好的 NSMutableURLRequest 对象
 *  @param requestServiceType 请求类型
 *  @param requestTag         请求标识
 *
 *  @return 生成的 HTTP 请求Operation
 */
-(AFHTTPRequestOperation*)HTTPRequestOperationWithRequest:(NSMutableURLRequest *)URLRequest
                                       requestServiceType:(RequestServiceType)requestServiceType
                                               requestTag:(NSInteger)requestTag;

/**
 *  取消所有的 http 请求，慎用
 */
+(void)cancelAllHttpRequest;

@end

#pragma mark - protocol
@protocol YHTTPServiceDelegate <NSObject>

@optional

/**
 *  响应成功
 *
 *  @param responseObject     经指定的 ResponseSerializer 解析好的响应对象
 *  @param requestOperation   HTTP请求Operation
 *  @param requestTag         请求标识
 *  @param otherFlags         其它标识或者数据
 */
-(void)responseSuccess:(id)responseObject
      requestOperation:(AFHTTPRequestOperation*)requestOperation
            requestTag:(NSInteger)requestTag
            otherFlags:(NSDictionary*)otherFlags;

/**
 *  响应失败
 *
 *  @param requestOperation   经指定的 ResponseSerializer 解析好的响应对象
 *  @param error              error
 *  @param requestTag         请求标识
 *  @param otherFlags         其它标识或者数据
 */
-(void)responseFailure:(AFHTTPRequestOperation*)requestOperation
                 error:(NSError*)error
            requestTag:(NSInteger)requestTag
            otherFlags:(NSDictionary*)otherFlags;

/**
 *  上传进度
 *
 *  @param request                   HTTP 请求
 *  @param progress                  当前进度
 *  @param totalBytesWritten         已经上传的字节数
 *  @param totalBytesExpectedToWrite 上传数据的总字节数
 *  @param requestTag                请求标识
 *  @param otherFlags                其它标识或者数据
 */
-(void)requestUploadProgress:(NSMutableURLRequest*)request
                    progress:(float)progress
           totalBytesWritten:(long long)totalBytesWritten
   totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite
                  requestTag:(NSInteger)requestTag
                  otherFlags:(NSDictionary*)otherFlags;

/**
 *  下载进度
 *
 *  @param request                  HTTP 请求
 *  @param progress                 当前进度
 *  @param totalBytesRead           已经下载的字节数
 *  @param totalBytesExpectedToRead 下载数据的总字节数
 *  @param requestTag               请求标识
 *  @param otherFlags               其它标识或者数据
 */
-(void)requestDownloadProgress:(NSMutableURLRequest*)request
                      progress:(float)progress
                totalBytesRead:(long long)totalBytesRead
      totalBytesExpectedToRead:(long long)totalBytesExpectedToRead
                    requestTag:(NSInteger)requestTag
                    otherFlags:(NSDictionary*)otherFlags;
@end
