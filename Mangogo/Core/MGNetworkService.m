//
//  MGNetworkService.m
//  Angejia
//
//  Created by zhujinhui on 15/11/9.
//  Copyright © 2015年 Plan B Inc. All rights reserved.
//

#import "MGNetworkService.h"

@interface MGNetworkService ()

@property (nonatomic,copy)          NSString *innerServiceName;
@property (nonatomic,strong)        NSDictionary *innerRequestParams;
@property (nonatomic,assign)        id<MGNetworkServiceDelegate> innerDelegate;

@end


@implementation MGNetworkService


-(instancetype)initWithName:(NSString *)serviceName params:(NSDictionary *)params{
    if (self = [super init]) {
        NSParameterAssert(serviceName);
        self.serviceName = serviceName;
        self.requestParams = params;
    }
    return self;
}

-(void)serviceDidStart{
    
}

-(void)main{
    @autoreleasepool {
        if (self.isCancelled) return;
        [self serviceDidStart];
        NSString *method = self.methodName;
        SEL service =NSSelectorFromString(method);
        NSAssert(service != nil, @"method can not be nil");
        NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:service];
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:self];
        [invocation setSelector:service];
        [invocation retainArguments];
        
        /**
         * get result and call back
         */
        MGNetwokResponse *__autoreleasing response = nil;
        if (self.isCancelled) return;
        
        [invocation invoke];
        [invocation getReturnValue:&response];
        
        if (self.isCancelled) return;
        if (self.delegate && [self.delegate respondsToSelector:@selector(service:serviceResponse:)]) {
            if (nil == response) {
                NSLog(@"kyson:%@:no response",self);
            }else{
                response.requestParams = self.requestParams;
                [self.delegate service:self serviceResponse:response];
            }
            
        }
        
    }

    
}

-(void)doAction{
    
}


-(void)setServiceName:(NSString *)serviceName{
    _innerServiceName = serviceName;
}

-(NSString *)serviceName{
    return _innerServiceName;
}

-(void)setRequestParams:(NSDictionary *)requestParams{
    _innerRequestParams = requestParams;
}

-(NSDictionary *)requestParams{
    return _innerRequestParams;
}

-(void)setDelegate:(id)delegate{
    _innerDelegate = delegate;
}


-(id)delegate{
    return _innerDelegate;
}

-(void)dealloc{
    self.delegate = nil;
}

@end
