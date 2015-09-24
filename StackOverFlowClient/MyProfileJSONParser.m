//
//  MyProfileJSONParser.m
//  StackOverFlowClient
//
//  Created by Sau Chung Loh on 9/17/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import "MyProfileJSONParser.h"
#import "MyProfile.h"

@implementation MyProfileJSONParser

+ (NSArray *)myProfileJSONParsing:(NSDictionary *)json {
  NSMutableArray *profile = [[NSMutableArray alloc] init];
  NSArray *items = json[@"items"];
  for (NSDictionary *item in items) {
    MyProfile *myProfile = [[MyProfile alloc] init];
    myProfile.ownerName = item[@"display_name"];
    myProfile.avatarURL = item[@"profile_image"];
    myProfile.ownerLink = item[@"link"];
    myProfile.reputation = item[@"reputation"];
    [profile addObject:myProfile];
  }
  return profile;
}

@end


//@property (strong, nonatomic) NSString *avatarURL;
//@property (strong, nonatomic) UIImage *avatarPhoto;
//@property (strong, nonatomic) NSString *ownerName;
//@property (strong, nonatomic) NSString *ownerLink;