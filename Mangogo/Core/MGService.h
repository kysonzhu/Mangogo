//
//  MGService.h
//  Angejia
//
//  Created by zhujinhui on 15/11/9.
//  Copyright © 2015年 Plan B Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * 服务协议，所谓的服务就是为业务端提供相应的功能，服务有一些特点：
 *1.需要指明服务名和要请求的服务参数
 *2.可能比较耗时
 常见的服务有：
 *1. 网络服务
 *2.数据库服务
 *3.音视频服务
 */

@protocol MGService<NSObject>

@property (nonatomic, copy ) NSString *serviceName;

@property (nonatomic, strong) NSDictionary *requestParams;


@property (nonatomic, assign) id delegate;

@end
