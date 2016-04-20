//
//  YHTTPServiceUseBlock.h
//  ztesoftLibs2
//
//  Created by wangyang on 14-1-9.
//  Copyright (c) 2014年 ztesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "YHTTPConst.h"

@interface YHTTPServiceUseBlock : NSObject

/**
 *  创建并返回一个新的 YHTTPServiceUseBlock 实例
 *
 *  @return 一个新的 YHTTPServiceUseBlock 实例
 */
+(instancetype)service;

/**
 *  直接发送 http 请求时，请求的 operation 会放入到这个队列中
 *
 *  @return 默认的执行队列
 */
+(NSOperationQueue*)sharedYHTTPServiceOperationQueue;

/**
 *  取消所有的 http 请求，慎用
 */
+(void)cancelAllHttpRequest;

/**
 *  发送一个请求（operation 已放入执行队列中）
 *
 *  @param method             @"POST" or @"GET" or @"PUT" or ...
 *  @param path               请求地址
 *  @param HTTPHeader         HTTP 请求头
 *  @param parameters         HTTP 请求参数
 *  @param requestServiceType 请求类型
 *  @param requestTag         请求标识
 *
 *  @return 生成的 HTTP 请求Operation
 */
-(AFHTTPRequestOperation*)sendHTTPRequestAsyncMethod:(NSString *)method
                                                Path:(NSString*)path
                                          HTTPHeader:(NSDictionary *)HTTPHeader
                                          parameters:(id)parameters
                                  requestServiceType:(RequestServiceType)requestServiceType
                                          requestTag:(NSInteger)requestTag;

/**
 *  发送一个请求，并设置响应成功和失败的回调 block（operation 已放入执行队列中）
 *
 *  @param method               @"POST" or @"GET" or @"PUT" or ...
 *  @param path                 请求地址
 *  @param HTTPHeader           HTTP 请求头
 *  @param parameters           HTTP 请求参数
 *  @param requestServiceType   请求类型
 *  @param requestTag           请求标识
 *  @param responseSuccessBlock 响应成功回调的 block
 *  @param responseFailureBlock 响应失败回调的 block
 *
 *  @return 生成的 HTTP 请求Operation
 */
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
                                                               NSDictionary *otherFlags)) responseFailureBlock;

/**
 *  发送一个已经封装好的 NSMutableURLRequest 对象（operation 已放入执行队列中）
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
 *  发送一个 NSMutableURLRequest 对象，并设置响应成功和失败回调的 block（operation 已放入执行队列中）
 *
 *  @param URLRequest           已经封装好的 NSMutableURLRequest 对象
 *  @param requestServiceType   请求类型
 *  @param requestTag           请求标识
 *  @param responseSuccessBlock 响应成功回调的 block
 *  @param responseFailureBlock 响应失败回调的 block
 *
 *  @return 生成的 HTTP 请求Operation
 */
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
                                                         NSDictionary *otherFlags)) responseFailureBlock;

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
 *  响应成功的 block
 */
-(void)setResponseSuccessBlock:(void (^)(id responseObject,AFHTTPRequestOperation *operation,NSInteger requestTag, NSDictionary *otherFlags)) responseSuccessBlock;

/**
 *  响应失败的 block
 */
-(void)setResponseFailureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error,NSInteger requestTag, NSDictionary *otherFlags)) responseFailureBlock;

/**
 *  上传进度的 block
 */
-(void)setUploadProgressBlock:(void (^)(NSMutableURLRequest *request, float progress, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, NSInteger requestTag, NSDictionary *otherFlags)) uploadProgressBlock;

/**
 *  下载进度的 block
 */
-(void)setDownloadProgressBlock:(void(^)(NSMutableURLRequest *request, float progress, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead, NSInteger requestTag, NSDictionary *otherFlags)) downloadProgressBlock;

@end
