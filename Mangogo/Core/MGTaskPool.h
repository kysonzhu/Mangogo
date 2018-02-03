//
//  MGTaskPool.h
//  Mongo
//
//  Created by zhujinhui on 16/10/18.
//  Copyright © 2016年 kyson. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGService.h"

#import "MGServiceResponse.h"

@protocol MGTaskPoolDelegate;

/**
 * 任务池，用于处理耗时任务
 *
 *
 */
@interface MGTaskPool : NSObject

+(MGTaskPool *) shareInstance;

+(void)registerNetworkMediatorWithName:(NSString *) networkMediator;

-(void)doTaskWithService:(id<MGService>)service;

-(void)addDelegate:(id<MGTaskPoolDelegate>) delegate;

-(void)removeDelegate:(id<MGTaskPoolDelegate>) delegate;

-(void)cancelServiceWithName:(NSString *)serviceName;

@end


@protocol MGTaskPoolDelegate <NSObject>

-(void)taskpool:(MGTaskPool *) pool serviceFinished:(id<MGService> )service response:(MGServiceResponse *) response;

@end


@interface NSObject (NetworkService)<MGTaskPoolDelegate>

@property (nonatomic, strong) NSArray *requestTokens;

/**
 * 做网络请求
 */
-(void)doServiceWithName:(NSString *)serviceName params:(NSDictionary *)params;
/**
 * 网络请求回调
 */
-(void)serviceName:(NSString *)serviceName response:(MGServiceResponse *)response;

/**
 *
 * 取消服务
 */

-(void)cancelService;

@end

