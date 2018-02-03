//
//  AGJServiceResponse.h
//  Angejia
//
//  Created by zhujinhui on 15/10/18.
//  Copyright © 2015年 Plan B Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define ERRORCODE_NOERROR 200

@interface MGServiceResponse : NSObject

@property (nonatomic, assign)   NSInteger errorCode;
@property (nonatomic, copy)     NSString  *errorMessage;
@property (nonatomic, copy)     NSString  *rawJson;
@property (nonatomic, strong)   NSDictionary *rawResponseDictionary;
@property (nonatomic, strong)   NSArray *rawResponseArray;
@property (nonatomic, strong)   id responseObject;



@end
