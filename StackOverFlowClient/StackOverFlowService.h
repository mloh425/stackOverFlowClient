//
//  StackOverFlowService.h
//  StackOverFlowClient
//
//  Created by Sau Chung Loh on 9/15/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StackOverFlowService : NSObject
+ (void)questionsForSearchTerm:(NSString *)searchTerm completionHandler:(void(^)(NSArray *, NSError *))completionHandler;
+ (void)fetchMyProfile:(void(^)(NSArray *, NSError *))completionHandler ;
@end
