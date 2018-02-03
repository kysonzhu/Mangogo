//
//  MGNetwokResponse.h
//  Angejia
//
//  Created by kyson on 15/11/26.
//  Copyright © 2015年 Plan B Inc. All rights reserved.
//

#import "MGServiceResponse.h"

#define  ERRORCODE_MOCK 90909090
#define SERVICE_RESPONSE_NORESPONSE 1111111
#define SERVICE_RESPONSE_NORESPONSE_DESC NSLocalizedString(@"数据异常",nil)
#define ERRORCODE_NOCHANGE 304
#define ERRORCODE_CREATE_SUCCESS 201
#define ERRORCODE_JSONPARSER 12510
#define ERRORCODE_NOERROR 0

@interface MGNetwokResponse : MGServiceResponse

@property (nonatomic, retain) NSDictionary *requestParams;
@property (nonatomic, assign) NSInteger statusCode;

@end
