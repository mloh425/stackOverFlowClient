//
//  Errors.h
//  StackOverFlowClient
//
//  Created by Sau Chung Loh on 9/15/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kStackOverFlowErrorDomain;

typedef enum : NSUInteger {
  StackOverFlowBadJSON = 400,
  StackOverFlowBadRequest = 401,
  StackOverFlowInvalidToken = 498,
  StackOverFlowNotFound = 404,
  StackOverFlowInternalServerError = 500,
  StackOverFlowServiceUnavailable = 504,
  StackOverFlowTooManyAttempts,
  StackOverFlowInvalidParameter,
  StackOverFlowNeedAuthentication,
  StackOverFlowGeneralError,
  StackOverFlowNoConnection
} StackOverFlowErrorCodes;