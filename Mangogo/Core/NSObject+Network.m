//
//  NSObject+Network.m
//  Mongo
//
//  Created by kyson on 2016/11/30.
//  Copyright © 2016年 kyson. All rights reserved.
//

#import "NSObject+Network.h"

@implementation NSObject(Mongo)


- (NSString *)mongo_JsonString {
    
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    } else if ([self isKindOfClass:[NSData class]]) {
        return [[NSString alloc] initWithData:(NSData *)self encoding:NSUTF8StringEncoding];
    }
    
    if (![self isKindOfClass:[NSDictionary class]] &&
        ![self isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    if (error) {
        NSLog(@"json convert error, object = %@", self);
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData
                                 encoding:NSUTF8StringEncoding];
}



+ (instancetype)jsonObjectWithString:(NSString *)jsonStr {
    if (jsonStr == nil || (![jsonStr isKindOfClass:[NSString class]])) {
        return nil;
    }
    NSError *error = nil;
    id v = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                           options:NSJSONReadingMutableContainers
                                             error:&error];
    if (error) {
        NSLog(@"你妹，什么破 json: %@", jsonStr);
        return nil;
    }
    
    return v;
}

@end
