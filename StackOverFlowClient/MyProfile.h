//
//  MyProfile.h
//  StackOverFlowClient
//
//  Created by Sau Chung Loh on 9/17/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfile : NSObject

@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) UIImage *avatarPhoto;
@property (strong, nonatomic) NSString *ownerName;
@property (strong, nonatomic) NSString *ownerLink;
@property (strong, nonatomic) NSNumber *reputation;
@end
