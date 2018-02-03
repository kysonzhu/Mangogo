//
//  MGJsonHandler.h
//  Angejia
//
//  Created by kyson on 15/11/26.
//  Copyright © 2015年 Plan B Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGNetwokResponse.h"
@interface MGJsonHandler : NSObject


+(MGNetwokResponse *)convertToErrorResponse:(MGNetwokResponse **)responseAddr;


+(MGNetwokResponse *)handleDemandJsonWithResponse:(MGNetwokResponse **)responseAddr;



@end
