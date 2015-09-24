//
//  MyProfileJSONParser.h
//  StackOverFlowClient
//
//  Created by Sau Chung Loh on 9/17/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyProfileJSONParser : NSObject

+ (NSArray *)myProfileJSONParsing:(NSDictionary *)json;

@end
