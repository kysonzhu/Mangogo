//
//  MGTaskPool.m
//  Mongo
//
//  Created by zhujinhui on 16/10/18.
//  Copyright © 2016年 kyson. All rights reserved.
//

#import "MGTaskPool.h"

#import "MGNetworkService.h"
#import "MGNetworkServiceMediator.h"
#import <objc/runtime.h>

@interface TaskPoolDelegate : NSObject

@property (nonatomic, weak) id delegate;

@end

@implementation TaskPoolDelegate

@end

@interface TaskPoolDelegateManager : NSObject{
}

@property (nonatomic, strong) NSArray<TaskPoolDelegate *> *delegates;


-(void) addDelegate:(id) delegate;

-(void) removeDelegate:(id) delegate;

@end

@implementation TaskPoolDelegateManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegates = [[NSMutableArray alloc] init];
    }
    return self;
}

-(BOOL ) isDelegateExists:(id ) delegate{
    for (TaskPoolDelegate *delegateItem in self.delegates) {
        if (delegate == delegateItem.delegate) {
            return YES;
        }
    }
    return NO;
}


-(void) addDelegate:(id) delegate{
    if (![self isDelegateExists:delegate]) {
        //temp delegate
        TaskPoolDelegate *tempDelegate = [[TaskPoolDelegate alloc] init];
        tempDelegate.delegate = delegate;
        //temp delegates
        NSMutableArray *tempDelegates = [NSMutableArray arrayWithArray:self.delegates];
        [tempDelegates addObject:tempDelegate];
        self.delegates = tempDelegates;
    }
}

-(void) removeDelegate:(id) delegate{
    NSMutableArray *tempDelegates = [NSMutableArray array];
    for (TaskPoolDelegate *delegateItem in self.delegates) {
        if (delegateItem.delegate && delegateItem.delegate != delegate) {
            [tempDelegates addObject:delegateItem];
        }
    }
    self.delegates = tempDelegates;
}

@end


@interface MGTaskPool ()<MGNetworkServiceDelegate>{
}

@property (nonatomic, strong) NSOperationQueue *pool;
@property (nonatomic, strong) NSMutableArray *taskTokens;
@property (nonatomic, assign) NSInteger requestCount;
@property (nonatomic, strong) TaskPoolDelegateManager *delegateManager;
@property (nonatomic, copy) NSString *mediatorName;


@end

@implementation MGTaskPool

+(MGTaskPool *) shareInstance{
    static MGTaskPool * _instance = nil;
    static dispatch_once_t onceToken ;
    
    dispatch_once(&onceToken, ^{
        if (_instance == nil){
            _instance = [[self alloc] init] ;
            _instance.pool = [[NSOperationQueue alloc]init];
            [_instance.pool setMaxConcurrentOperationCount:5];
            _instance.taskTokens = [[NSMutableArray alloc]init];
            _instance.requestCount = 0;
            _instance.delegateManager = [[TaskPoolDelegateManager alloc] init];
        }
    });
    
    return _instance;
}

+(void)registerNetworkMediatorWithName:(NSString *) networkMediator{
    [self shareInstance].mediatorName = networkMediator;
}

-(void)addDelegate:(id<MGTaskPoolDelegate>)delegate{
    [self.delegateManager addDelegate:delegate];
}


-(void)doTaskWithService:(id<MGService>)service{
    if (nil == service.delegate) {
        service.delegate = self;
    }
    NSString *serviceName = service.serviceName;
    
    for (NSString *servieName in self.taskTokens) {
        if ([servieName isEqualToString:service.serviceName]) {
            ++_requestCount;
            serviceName = [NSString stringWithFormat:@"%@@%li",serviceName,(long)self.requestCount];
        }
    }
    [self.taskTokens addObject:serviceName];
    //    NSOperation *serviveOp = (NSOperation *) service;
    //    serviveOp.name = serviceName;
    [self.pool addOperation:(NSOperation *)service];
}



-(void)service:(MGNetworkService *)service serviceResponse:(MGNetwokResponse *)response{
    if (self.delegateManager.delegates.count > 0) {
#define KEY_ARGV1 @"argv1"
#define KEY_ARGV2 @"argv2"
        NSDictionary *requestObject = @{KEY_ARGV1:service,KEY_ARGV2:response};
        [self performSelectorOnMainThread:@selector(requestFinished:) withObject:requestObject waitUntilDone:YES];
    }
}

-(void)requestFinished:(NSDictionary *)dic{
    MGNetworkService *service = dic[KEY_ARGV1];
    MGNetwokResponse *response = dic[KEY_ARGV2];
    
    for (TaskPoolDelegate *delegate in self.delegateManager.delegates) {
        [delegate.delegate taskpool:self serviceFinished:service response:response];
    }
}

-(void)removeDelegate:(id<MGTaskPoolDelegate>)delegate{
    [self.delegateManager removeDelegate:delegate];
}

-(void)cancelServiceWithName:(NSString *)serviceName{
    //    for (NSOperation *opItem in self.pool.operations) {
    //        if ([opItem.name hasPrefix:serviceName]) {
    //            [opItem cancel];
    //        }
    //    }
}

-(NSArray *)delegates{
    return self.delegateManager.delegates;
}

@end






@implementation NSObject(NetworkService)

static void *requestTokenskey      = &requestTokenskey;

-(void)setRequestTokens:(NSArray *)requestTokens{
    objc_setAssociatedObject(self, &requestTokenskey, requestTokens, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSArray *)requestTokens{
    return objc_getAssociatedObject(self, &requestTokenskey);
}

extern void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector);

-(void)doServiceWithName:(NSString *)serviceName params:(NSDictionary *)params{
    NSAssert([[NSThread currentThread] isMainThread], @"NetworkService 目前只允许在主线程运行");
    NSString *mediatorName = NSStringFromClass([MGNetworkServiceMediator class]);
    Class mediatorNameClass = NSClassFromString([MGTaskPool shareInstance].mediatorName ? [MGTaskPool shareInstance].mediatorName: mediatorName);
    id networkService = [[mediatorNameClass alloc] initWithName:serviceName params:params];
    MGTaskPool *taskPool = [MGTaskPool shareInstance];
    [taskPool addDelegate:self];
    [taskPool doTaskWithService:networkService];
    //添加到token
    NSMutableArray *requestTokens = [[NSMutableArray alloc] initWithArray:self.requestTokens];
    //获取对象的唯一辨识，目前没什么好方法，暂时用hash
    NSString *resultServiceName = [NSString stringWithFormat:@"%lu.%@.%@",(unsigned long)self,serviceName,params];
    [requestTokens addObject:resultServiceName];
    self.requestTokens = requestTokens;
}


-(void)taskpool:(MGTaskPool *)pool serviceFinished:(id<MGService>)service response:(MGServiceResponse *)response{
    NSLog(@"requesttoken:%@",self.requestTokens);
    for (NSString *requestToken in self.requestTokens) {
        NSString *resultServiceName = [NSString stringWithFormat:@"%lu.%@.%@",(unsigned long)self,service.serviceName,((MGNetwokResponse *)response).requestParams];
        NSLog(@"requestToken:%@",requestToken);
        NSLog(@"resultServiceName:%@",resultServiceName);
        
        if ([requestToken isEqualToString:resultServiceName]) {
            [self serviceName:service.serviceName response:response];
            NSMutableArray *tempTokens = [NSMutableArray arrayWithArray:self.requestTokens];
            [tempTokens removeObject:resultServiceName];
            self.requestTokens = tempTokens;
        }
    }
}

-(void)serviceName:(NSString *)serviceName response:(MGServiceResponse *)response{}

-(void)cancelService{
    [[MGTaskPool shareInstance] removeDelegate:self];
    
    for (TaskPoolDelegate *delegateItem in [MGTaskPool shareInstance].delegates) {
        NSLog(@"delegateItem:+++++:%@",delegateItem.delegate);
    }
    
}

@end

