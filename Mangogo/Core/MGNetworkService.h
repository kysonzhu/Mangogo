//
//  MGNetworkService.h
//  Angejia
//
//  Created by zhujinhui on 15/11/9.
//  Copyright © 2015年 Plan B Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGService.h"
#import "MGNetwokResponse.h"
#import "MGService.h"

@protocol MGNetworkServiceDelegate;


@interface MGNetworkService : NSOperation<MGService>

@property (nonatomic, copy) NSString *methodName;

@property (nonatomic, strong) NSArray *paramNames;

-(instancetype)initWithName:(NSString *) serviceName params:(NSDictionary *)params;

@end


@protocol MGNetworkServiceDelegate <NSObject>

-(void)service:(MGNetworkService *)service serviceResponse:(MGNetwokResponse *)response;

@end
