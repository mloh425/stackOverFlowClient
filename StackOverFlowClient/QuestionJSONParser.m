//
//  QuestionJSONParser.m
//  StackOverFlowClient
//
//  Created by Sau Chung Loh on 9/16/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import "QuestionJSONParser.h"
#import "Question.h"


@implementation QuestionJSONParser

+ (NSArray *)questionsFromJSONParsing:(NSDictionary *)json {
  NSMutableArray *questions = [[NSMutableArray alloc] init];
  NSArray *items = json[@"items"];
  for (NSDictionary *item in items) {
    Question *question = [[Question alloc] init];
    question.title = item[@"title"];
    NSDictionary *owner = item[@"owner"];
    question.ownerName = owner[@"display_name"];
    question.avatarURL = owner[@"profile_image"];
    question.ownerLink = owner[@"link"];
    question.questionLink = item[@"link"];
    [questions addObject:question];
  }
  return questions;
}

@end
