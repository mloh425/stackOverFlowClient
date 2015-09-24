//
//  StackOverFlowService.m
//  StackOverFlowClient
//
//  Created by Sau Chung Loh on 9/15/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import "StackOverFlowService.h"
#import <AFNetworking/AFNetworking.h>
#import "Errors.h"
#import "QuestionJSONParser.h"
#import "MyProfileJSONParser.h"

@interface StackOverFlowService()


@end

@implementation StackOverFlowService

+ (void)questionsForSearchTerm:(NSString *)searchTerm completionHandler:(void(^)(NSArray *, NSError *))completionHandler {
  //endpoint is search, order =  desc/sort, activity - intitle, swift - site
  NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
  NSString *token = [defaults objectForKey:@"token"];
  NSString* finalSearchTerm = [searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"-"];
  NSString *finalURL = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/search?key=hMFNPdBO3lcsJwuhquwhFQ((&order=desc&sort=activity&access_token=%@&intitle=%@&site=stackoverflow", token, finalSearchTerm];
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager]; //Default URL session, object to make rq
  
//  responseObject = serialized data, ready to be parsed
  [manager GET:finalURL parameters:nil success:^(AFHTTPRequestOperation * operation, id responseObject) {
//    NSLog(@"%ld", operation.response.statusCode);
//    NSLog(@"%@", responseObject);
    NSArray *questions = [QuestionJSONParser questionsFromJSONParsing:responseObject];
    completionHandler(questions, nil);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if(operation.response) {
      NSError *stackOverFlowError = [self errorForStatusCode:operation.response.statusCode];
      dispatch_async(dispatch_get_main_queue(), ^{
        completionHandler(nil,stackOverFlowError);
      });
    } else {
      NSError *reachabilityError = [self checkReachability];
      if (reachabilityError) {
        completionHandler(nil, reachabilityError);
      }
    }
  }];
}

+ (void)fetchMyProfile:(void(^)(NSArray *, NSError *))completionHandler {
  NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
  NSString *token = [defaults objectForKey:@"token"];
  NSString *finalURL = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/me?key=hMFNPdBO3lcsJwuhquwhFQ((&order=desc&sort=reputation&access_token=%@&site=stackoverflow",token];
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:finalURL parameters:nil success:^(AFHTTPRequestOperation * operation, id responseObject) {
    NSArray *profile = [MyProfileJSONParser myProfileJSONParsing:responseObject];
    completionHandler(profile, nil);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if(operation.response) {
      NSError *stackOverFlowError = [self errorForStatusCode:operation.response.statusCode];
      dispatch_async(dispatch_get_main_queue(), ^{
        completionHandler(nil,stackOverFlowError);
      });
    } else {
      NSError *reachabilityError = [self checkReachability];
      if (reachabilityError) {
        completionHandler(nil, reachabilityError);
      }
    }
  }];
}

+ (NSError *)checkReachability {
  if (![AFNetworkReachabilityManager sharedManager].reachable) {
    NSError *error = [NSError errorWithDomain:kStackOverFlowErrorDomain code:StackOverFlowNoConnection userInfo: @{NSLocalizedDescriptionKey : @"Could not connect to servers, please try again when you have a connection"}];
    return error;
  }
  return nil;
}

+ (NSError *)errorForStatusCode:(NSInteger)statusCode {
  NSInteger errorCode;
  NSString *localizedDescription;
  
  switch (statusCode) {
    case 502:
      localizedDescription = @"Too many requests, please wait to make more";
      errorCode = StackOverFlowTooManyAttempts;
      break;
    case 400:
      localizedDescription = @"Invalid search term, please try another search";
      errorCode = StackOverFlowInvalidParameter;
      break;
    case 401:
      localizedDescription = @"You must sign in to access this feature";
      errorCode = StackOverFlowNeedAuthentication;
      break;
    default:
      localizedDescription = @"Could not complete operation, please try again later";
      errorCode = StackOverFlowGeneralError;
      break;
  }
  NSError *error = [NSError errorWithDomain:kStackOverFlowErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey : localizedDescription}];
  return error;
}
@end
