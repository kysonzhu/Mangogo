//
//  MGProtocolHandler.h
//  Angejia
//
//  Created by kyson on 16/3/4.
//  Copyright © 2016年 Plan B Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MGProtocolHandler : NSObject

@property (nonatomic, strong ,readonly) NSDictionary *defaultHttpHeaders;

@property (nonatomic, strong ) NSDictionary * additionHttpHeaders;



- (NSDictionary *)commonParams;
@end
