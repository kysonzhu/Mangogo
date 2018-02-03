//
//  NSObject+Network.h
//  Mongo
//
//  Created by kyson on 2016/11/30.
//  Copyright © 2016年 kyson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Mongo)


/**
 * 转换成json
 * 如果obj是 NSString类型的话，直接返回本身
 * 如果obj是 NSData类型的话，先转换成NSString类型，再返回
 * 如果obj是 NSArray或者NSDictionary，则转换成可用的json类型
 * 如果obj是其他的未知类型，则返回nil
 */
- (NSString *)mongo_JsonString;




/**
 * json转换成对象
 */
+ (instancetype)jsonObjectWithString:(NSString *)jsonStr;



@end
