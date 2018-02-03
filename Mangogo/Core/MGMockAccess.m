;//
//  MGMockAccess.m
//  Angejia
//
//  Created by kyson on 15/11/26.
//  Copyright © 2015年 Plan B Inc. All rights reserved.
//

#import "MGMockAccess.h"
#import "MGJsonHandler.h"

@implementation MGMockAccess


-(MGNetwokResponse *)doHttpRequestWithJsonFileNamed:(NSString *)jsonFileName{
    MGNetwokResponse *response = [[MGNetwokResponse alloc]init];
    NSError *error = nil;
    NSStringEncoding encoding;
    if (!jsonFileName) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"json"];
        NSString *string = [[NSString alloc ]initWithContentsOfFile:path usedEncoding:&encoding error:&error];
        response.rawJson = string;
        [MGJsonHandler convertToErrorResponse:&response];
        NSLog(@"%@:mock data:%@",self,string);
    }else{
        NSString *path = [[NSBundle mainBundle] pathForResource:jsonFileName ofType:@"json"];
        NSString *string = [[NSString alloc ]initWithContentsOfFile:path usedEncoding:&encoding error:&error];
        response.rawJson = string;
        [MGJsonHandler convertToErrorResponse:&response];
        NSLog(@"%@:mock data:%@",self,string);
    }
    response.errorCode = ERRORCODE_MOCK;
    response.errorMessage = @"测试数据";
    return response;
}


@end
