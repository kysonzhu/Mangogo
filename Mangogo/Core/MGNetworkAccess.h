//
//  MGNetworkAccess.h
//  Angejia
//
//  Created by kyson on 15/11/26.
//  Copyright © 2015年 Plan B Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGNetwokResponse.h"
#import "MGProtocolHandler.h"

#define TIMEOUT_INTERVAL 16.0

typedef enum _RequestType{
    RequestTypePost,
    RequestTypePostMap = RequestTypePost,
    RequestTypePostJson,
    RequestTypeGet,
}RequestType;

/**
 * @brief As the name implies,NetworkAccess is used to dealing with network request,now it can dealing with request such as get,post and so on.
 */

@interface MGNetworkAccess : NSObject
#define HOST_MOCK @"HOST_MOCK"

@property (nonatomic,strong) MGProtocolHandler *protocolHandler;

/*
 *服务器主机名
 *
 *
 */
@property (nonatomic, copy) NSString *host;
/*
 * 模块路径
 */
@property (nonatomic, copy) NSString *modulePath;
/*
 * 请求方式
 */
@property (nonatomic, assign) RequestType requestType;
/*
 * 初始化
 */
-(instancetype)initWithHost:(NSString *) host modulePath:(NSString *) path;
/**
 * 本地json，当HOST地址为Mock的时候，可以指明要加载的本地JSON文件
 */
@property (nonatomic, copy) NSString *localJsonName;
/*
 * http请求
 */
-(MGNetwokResponse *)doServiceRequestWithName:(NSString *)serviceName params:(NSDictionary *) params;

@end
