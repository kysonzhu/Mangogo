//
//  UserCenterNetworkServiceMediator.m
//  Mongo
//
//  Created by kyson on 03/02/2018.
//  Copyright © 2018 kyson. All rights reserved.
//

#import "UserCenterNetworkServiceMediator.h"
#import "MGNetworkAccess.h"

@interface UserCenterNetworkServiceMediator()

@end

@implementation UserCenterNetworkServiceMediator

-(void)serviceDidStart{
    
}

-(MGNetwokResponse *)doKysonIndex{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:@"http://www.kyson.cn" modulePath:nil];
    MGNetwokResponse *response = [networkAccess doServiceRequestWithName:nil params:nil];
    return response;
}

-(void)setServiceName:(NSString *)serviceName{
    super.serviceName = serviceName;
    if ([self.serviceName isEqualToString:SERVICENAME_KYSON_INDEX]) {
        self.methodName = NSStringFromSelector(@selector(doKysonIndex));
    }
}

@end
