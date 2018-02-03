//
//  MGNetworkAccess.m
//  Angejia
//
//  Created by kyson on 15/11/26.
//  Copyright © 2015年 Plan B Inc. All rights reserved.
//

#import "MGNetworkAccess.h"
#import "MGMockAccess.h"
#import "MGJsonHandler.h"

@interface MGNetworkAccess ()<NSURLSessionDelegate>{
    
    dispatch_semaphore_t semaphore;
}

@property (nonatomic, assign) BOOL      isMockAccess;
@property (nonatomic, strong) NSError   *mError;
@property (nonatomic, strong) NSURLResponse *mURLResponse;
@property (nonatomic, strong) NSMutableData *mResponseData;

@end

@implementation MGNetworkAccess


/**
 初始化函数
 @param host 主机
 @param path 模块
 @return 自身
 */
-(instancetype)initWithHost:(NSString *) host modulePath:(NSString *)path{
    if (self = [super init]) {
        self.host = host;
        self.modulePath = path;
        /**
         * Judge if it is mock access
         */
        if ([_host isEqualToString:HOST_MOCK] ) {
            self.isMockAccess = YES;
        }else{
            self.isMockAccess = NO;
        }
        semaphore = dispatch_semaphore_create(0);
    }
    return self;
}


-(NSMutableURLRequest *)requestWithServiceName:(NSString *)serviceName params:(NSDictionary *) params{
    NSString *requestURL = [self requestURLWithHost:self.host module:self.modulePath service:serviceName];
    return [self requestWithURL:requestURL params:params];
}


/**
 生成基础的请求服务URL

 @param host 主机名
 @param mudule 模块名
 @param serviceName 服务名
 @return 生成的URL
 */
-(NSString *)requestURLWithHost:(NSString *)host module:(NSString *)mudule service:(NSString *)serviceName{
    //判断主机是否存在
    if (nil == self.host) {
        return nil;
    }
    NSString *requestURLString = nil;
    //判断模块是否存在
    if (self.modulePath && self.modulePath.length > 0) {
        requestURLString = [NSString stringWithFormat:@"%@/%@",self.host,self.modulePath];
    }else{
        requestURLString = self.host;
    }
    //判断服务是否存在
    if (nil != serviceName) {
        requestURLString = [NSString stringWithFormat:@"%@/%@",requestURLString,serviceName];
    }
    return requestURLString;
}


-(NSMutableURLRequest *)requestWithURL:(NSString *) requestURL params:(NSDictionary *)params
{
    NSMutableURLRequest *request2 = nil;
    switch (self.requestType)
    {
        case RequestTypeGet:{
            if (params.allKeys.count > 0)
            {
                requestURL = [requestURL stringByAppendingString:@"&"];
                for (NSInteger index = 0; index < params.allKeys.count; ++ index)
                {
                    NSString *paramsKey = params.allKeys[index];
                    requestURL = [requestURL stringByAppendingFormat:@"%@=%@",paramsKey,params[paramsKey]];
                    if (index != params.allKeys.count - 1) {
                        requestURL = [requestURL stringByAppendingString:@"&"];
                    }
                }
            }else{
                NSLog(@"there is no params");
            }
            requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            request2 = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:requestURL]];
            [request2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        }
            break;
        case RequestTypePost:
        {
            request2 = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:requestURL]];
#define REQUESTMETHOD_POST @"POST"
            [request2 setHTTPMethod:REQUESTMETHOD_POST ];
            [request2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
            
            //set http post body
            NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc]initWithDictionary:params];
            NSInteger keyCount = [[tempDictionary allKeys] count];
            NSMutableString *string = [[NSMutableString alloc]init];
            NSArray *arrKey = [tempDictionary allKeys];
            for (int i = 0 ; i < keyCount; ++i) {
                NSString *key = [arrKey objectAtIndex:i];
                NSString *value = [params objectForKey:key];
                if (0 == i) {
                    [string appendFormat:@"%@=%@",key,value];
                }else{
                    [string appendFormat:@"&%@=%@",key,value];
                }
            }
            NSLog(@"kyson:%@:post data:%@",self,string);
            NSData *bodyData = [string dataUsingEncoding:NSUTF8StringEncoding];
            [request2 setHTTPBody:bodyData];
        }
            break;
        case RequestTypePostJson:{
            request2 = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:requestURL]];
            [request2 setHTTPMethod:@"POST"];
            [request2 setValue:@"application/json" forHTTPHeaderField:@"content-type"];
            
            if(params){
                NSError *parserError= nil;
                NSData *jsonData = nil;
                @try {
                    jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&parserError];
                    [request2 setHTTPBody:jsonData];
                }
                @catch (NSException *exception) {
                    NSAssert(1!=1, @"json parse wrong!");
                    NSLog(@"%@:kyson exception :%@",self,exception);
                }
                NSLog(@"kyson:%@:%@",self,requestURL);
            }else{
                NSLog(@"No params");
            }
            
            
        }
            break;
            
        default:
            break;
    }
    //set header
    for (NSString *keyItem in [self.protocolHandler defaultHttpHeaders].allKeys) {
        [request2 setValue:[self.protocolHandler defaultHttpHeaders][keyItem] forHTTPHeaderField:keyItem];
    }
    
    if ([self.protocolHandler additionHttpHeaders]) {
        for (NSString *keyItem in [self.protocolHandler additionHttpHeaders].allKeys) {
            [request2 setValue:[self.protocolHandler additionHttpHeaders][keyItem] forHTTPHeaderField:keyItem];
        }
    }else{
        //no addtion
    }
    
    request2.timeoutInterval = TIMEOUT_INTERVAL;
    // use any cache
    request2.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    return request2;
    
}

-(NSMutableURLRequest *)commonHandleOfRequestString:(NSString *) urlString{
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
    request2.timeoutInterval = TIMEOUT_INTERVAL;
    // use any cache
    request2.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    return request2;
}


/**
 做请求

 @param serviceName 服务名
 @param params 参数
 @return 网络返回值
 */
-(MGNetwokResponse *)doServiceRequestWithName:(NSString *)serviceName params:(NSDictionary *) params{
    NSMutableURLRequest *request = nil;
    /**
     * Judge if it is mock access
     */
    if ([_host isEqualToString:HOST_MOCK] ) {
        MGMockAccess *mock = [[MGMockAccess alloc]init];
        return [mock doHttpRequestWithJsonFileNamed:self.localJsonName];
    }
    request = [self requestWithServiceName:serviceName params:params];
    MGNetwokResponse *response = [self doHttpRequestAndGetResponse:request];
    return response;
}



/**
 HTTP网络请求主体

 @param request 请求主体
 @return 返回结果
 */
-(MGNetwokResponse *)doHttpRequestAndGetResponse:(NSURLRequest *)request {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *inProcessSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [inProcessSession dataTaskWithRequest:request];
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    ////请求结束后，获得结束的信号，以下代码开始对结果进行处理
    NSString *receivedString = [[NSString alloc] initWithData:self.mResponseData encoding:NSUTF8StringEncoding];
    MGNetwokResponse *tempResponse = [[MGNetwokResponse alloc] init];
    tempResponse.rawJson = receivedString;
    
    NSError *tempError = self.mError;
    if (tempError) {
        if (NSURLErrorCannotConnectToHost == tempError.code ) {
            tempResponse.errorMessage = @"连接服务器失败，请稍后再试";
            tempResponse.errorCode = NSURLErrorCannotConnectToHost;
        }else if (NSURLErrorTimedOut == tempError.code){
            tempResponse.errorMessage = @"超时，请稍后再试";
            tempResponse.errorCode = NSURLErrorTimedOut;
        }else if(NSURLErrorNotConnectedToInternet == tempError.code){
            tempResponse.errorCode = NSURLErrorNotConnectedToInternet;
            tempResponse.errorMessage = @"当前网络不可用，请检查网络";
        }else{
            //do nothing
            //            response.errorCode = 89898989;
            //            response.errorMessage = @"服务器被连接失败";
        }
        NSLog(@"error : %@",tempError.description);
    }else{
        if ([self.mURLResponse isMemberOfClass:[NSHTTPURLResponse class]]) {
            tempResponse.statusCode = ((NSHTTPURLResponse *)self.mURLResponse).statusCode;
        }else{
            //do nothing
        }
        [MGJsonHandler convertToErrorResponse:&tempResponse];
        
        NSLog(@"\n###########\n request url:%@\n ###########\n http header:%@ \n ###########\n HTTPBody:%@ \n result:%@ \n ###########\n error code :%li",request.URL.absoluteString,request.allHTTPHeaderFields,[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding],tempResponse.rawJson,(long)tempResponse.errorCode);
    }
    [inProcessSession finishTasksAndInvalidate];
    
    return tempResponse;
}



- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    
    NSString *method = challenge.protectionSpace.authenticationMethod;
    NSLog(@"%@", method);
    
    if([method isEqualToString:NSURLAuthenticationMethodServerTrust]){
        
        NSString *host = challenge.protectionSpace.host;
        NSLog(@"%@", host);
        
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        return;
    }
    
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"client" ofType:@"p12"];
    NSData *PKCS12Data = [[NSData alloc] initWithContentsOfFile:thePath];
    CFDataRef inPKCS12Data = (CFDataRef)CFBridgingRetain(PKCS12Data);
    SecIdentityRef identity;
    
    // 读取p12证书中的内容
    OSStatus result = [self extractP12Data:inPKCS12Data toIdentity:&identity];
    if(result != errSecSuccess){
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        return;
    }
    
    SecCertificateRef certificate = NULL;
    SecIdentityCopyCertificate (identity, &certificate);
    
    const void *certs[] = {certificate};
    CFArrayRef certArray = CFArrayCreate(kCFAllocatorDefault, certs, 1, NULL);
    
    NSURLCredential *credential = [NSURLCredential credentialWithIdentity:identity certificates:(NSArray*)CFBridgingRelease(certArray) persistence:NSURLCredentialPersistencePermanent];
    
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}

-(OSStatus) extractP12Data:(CFDataRef)inP12Data toIdentity:(SecIdentityRef*)identity {
    
    OSStatus securityError = errSecSuccess;
    
    CFStringRef password = CFSTR("the_password");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import(inP12Data, options, &items);
    
    if (securityError == 0) {
        CFDictionaryRef ident = CFArrayGetValueAtIndex(items,0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(ident, kSecImportItemIdentity);
        *identity = (SecIdentityRef)tempIdentity;
    }
    
    if (options) {
        CFRelease(options);
    }
    
    return securityError;
}


// 接收到服务器的响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSLog(@"didReceiveResponse");
    self.mURLResponse = response;
    
    completionHandler(NSURLSessionResponseAllow);
}
// 接收到服务器返回的数据(可能多次调用)
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"didReceiveData");
    [self.mResponseData appendData:data];
}


// 请求完毕
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"didCompleteWithError");
    self.mError = error;
    
    dispatch_semaphore_signal(semaphore);
    
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler{
    
}

-(NSMutableData *)mResponseData{
    if (!_mResponseData) {
        _mResponseData = [NSMutableData data];
    }
    
    return _mResponseData;
}

- (void)dealloc {
    
}

@end
