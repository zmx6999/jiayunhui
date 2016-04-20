//
//  YHTTPConst.h
//  ztesoftLibs2
//
//  Created by wangyang on 14-1-8.
//  Copyright (c) 2014年 ztesoft. All rights reserved.
//

#ifndef ztesoftLibs2_YHTTPConst_h
#define ztesoftLibs2_YHTTPConst_h

/**
 *  请求类型
 */
typedef NS_ENUM(NSInteger, RequestServiceType)
{
    /**
     *  普通的 http 请求，不对请求做特殊处理
     */
    RequestServiceGeneral,
    /**
     *  爱资源定义的传输报文规范，会对一个请求添加 ires 规定的 http 头，封装相应参数成 json 形式。并解析响应的 json 数据，分析 result 是否为 000
     */
    RequestServiceIresJSON,
    /**
     *  爱资源定义的经 UTF8 编码再 Base64 编码后的 json 数据报文，在 RequestServiceIresJSON 基础上增加了 UTF8 编码再 Base64 编码
     */
    RequestServiceIresJSONWithUTF8Base64,
    /**
     *  从服务器请求图片，并缓存它
     */
    RequestServiceGetImageAndCacheIt
};

/**
 *  otherFlags 里的 key 值
 */
#define OTHER_FLAGS_REQUEST_SERVICE_TYPE @"RequestServiceType"

#endif
