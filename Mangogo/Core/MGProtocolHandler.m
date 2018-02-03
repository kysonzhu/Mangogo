//
//  MGProtocolHandler.m
//  Angejia
//
//  Created by kyson on 16/3/4.
//  Copyright © 2016年 Plan B Inc. All rights reserved.
//

#import "MGProtocolHandler.h"
#import <CommonCrypto/CommonHMAC.h>
#import <AdSupport/AdSupport.h>

@interface MGProtocolHandler ()

@property (nonatomic, strong) NSArray *httpMethodMap;

@end


@implementation MGProtocolHandler


- (instancetype)init
{
    self = [super init];
    
    if (self) {
    }
    return self;
}

-(NSDictionary *)defaultHttpHeaders{
    NSMutableDictionary *httpHeaders = [NSMutableDictionary dictionary];
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *useragent = [NSString stringWithFormat:@"medusa-ios,%@", appVersion];

    httpHeaders[@"User-Agent"] = useragent;
    
    return httpHeaders;
}


+ (NSString *)commonParamsStringForHeader{
    //NSString *header = [super  commonParamsStringForHeader];
    NSString* ifda = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return [NSString stringWithFormat:@"idfa=%@",ifda];

}


- (NSDictionary *)commonParams
{
    
    return nil;
}


@end
