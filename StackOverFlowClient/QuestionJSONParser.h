//
//  QuestionJSONParser.h
//  StackOverFlowClient
//
//  Created by Sau Chung Loh on 9/16/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionJSONParser : NSObject

+ (NSArray *)questionsFromJSONParsing:(NSDictionary *)json;

@end
