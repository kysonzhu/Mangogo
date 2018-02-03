//
//  MGMockAccess.h
//  Angejia
//
//  Created by kyson on 15/11/26.
//  Copyright © 2015年 Plan B Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGNetworkServiceMediator.h"
#import "MGNetwokResponse.h"

/**
 * 挡板数据，主要由以下作用：
 *1.模拟网络请求（通过networkservice）
 *2.缓存本地数据，例如城市区块数据，如果请求失败，则直接加载本地文件
 */
@interface MGMockAccess : NSObject

/**
 * jsonFileName:json文件名，不需要带扩展名（默认扩展名是JSON）
 */
-(MGNetwokResponse *)doHttpRequestWithJsonFileNamed:(NSString *)jsonFileName;

@end
