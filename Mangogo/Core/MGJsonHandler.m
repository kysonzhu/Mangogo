//
//  MGJsonHandler.m
//  Angejia
//
//  Created by kyson on 15/11/26.
//  Copyright © 2015年 Plan B Inc. All rights reserved.
//

#import "MGJsonHandler.h"
#import "MGNetwokResponse.h"


@implementation MGJsonHandler

/**
 将返回结果做解析，如果是正确的Json格式则返回字典，否则返回相关错误信息

 @param responseAddr <#responseAddr description#>
 @return <#return value description#>
 */
+(MGNetwokResponse *)convertToErrorResponse:(MGNetwokResponse **)responseAddr{
    MGNetwokResponse *response = (*responseAddr);
    NSString *jsonString = response.rawJson;
    if (!jsonString || jsonString.length == 0) {
        response.errorMessage = SERVICE_RESPONSE_NORESPONSE_DESC;
        return response;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    //judge if the raw json is json,if is not json error will not be nil,then return directly
    if (error) {
        response.errorCode = ERRORCODE_JSONPARSER;
        response.errorMessage = @"Json解析异常";
        return response;
    }
    
    if ([jsonObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *jsonDictionary = (NSDictionary *) jsonObject;
        if (YES != [jsonDictionary[@"isSuccess"] boolValue]) {
            NSInteger errorcode = [jsonDictionary[@"code"] integerValue];
            response.errorCode = errorcode;
        }else{
            response.errorCode = ERRORCODE_NOERROR;
        }
        
        if (nil != jsonDictionary[@"errorMsg"]) {
            NSString *errorMessage = jsonDictionary[@"errorMsg"];
            response.errorMessage = errorMessage;
        }
        
        response.rawResponseDictionary = jsonDictionary;
        id data = jsonDictionary[@"data"];
        if ([data isKindOfClass:[NSDictionary class]] || [data isKindOfClass:[NSArray class]] ) {
            response.responseObject = data;
        }else{
            NSLog(@"error object：%s",__func__);
        }
        
    }else if ([jsonObject isKindOfClass:[NSArray class]]){
        NSArray *objArray = (NSArray *) jsonObject;
        response.rawResponseArray = objArray;
        
    }
    return response;
}


+(MGNetwokResponse *)handleDemandJsonWithResponse:(MGNetwokResponse **)responseAddr{
    return nil;
}


@end
