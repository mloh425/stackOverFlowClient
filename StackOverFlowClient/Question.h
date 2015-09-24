//
//  Question.h
//  StackOverFlowClient
//
//  Created by Sau Chung Loh on 9/16/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Question : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) UIImage *avatarPhoto;
@property (strong, nonatomic) NSString *ownerName;
@property (strong, nonatomic) NSString *ownerLink;
@property (strong, nonatomic) NSString *questionLink;
@end
