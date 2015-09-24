//
//  MyProfileViewController.m
//  StackOverFlowClient
//
//  Created by Sau Chung Loh on 9/15/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import "MyProfileViewController.h"
#import "StackOverFlowService.h"
#import "MyProfile.h"
#import "LinkWebViewController.h"

@interface MyProfileViewController ()
@property (assign, nonatomic) IBOutlet UIImageView *profilePicture;
@property (assign, nonatomic) IBOutlet UILabel *nameLabel;
@property (assign, nonatomic) IBOutlet UILabel *reputationLabel;
@property (assign, nonatomic) IBOutlet UIButton *linkButton;
@property (retain, nonatomic) NSArray *profile;
@property (retain, nonatomic) MyProfile *me;

//@property (retain, nonatomic) NSString *myName; //use retain (for strong) assign(for weak)
//@property (assign, nonatomic) NSNumber *myNumber; //You do not own this.

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self fetchProfile];
//  NSString *myString = [[NSString stringWithFormat:@"Hi"] retain]; //Not owned normally, but with retain it is now owned, retain count + 1
//  self.myName = myString; //Retain count should be at 3 here?
//  [myString release]; //Retain count down to 2;
  // if arc is on, you cannot use this.
  //[self retain];
    // Do any additional setup after loading the view.
}

- (void)fetchProfile {
  [StackOverFlowService fetchMyProfile:^(NSArray *results, NSError *error) {
    if (error) {
      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:true completion:nil];
      }];
      [alertController addAction:action];
      
      [self presentViewController:alertController animated:true completion:nil];
    } else {
      self.profile = results;
      self.me = self.profile.firstObject;
      self.nameLabel.text = self.me.ownerName;
      NSString *rep = [NSString stringWithFormat:@"%@", self.me.reputation];
      self.reputationLabel.text = rep;
      [self.linkButton setTitle:self.me.ownerLink forState:normal];
    //  self.linkButton.titleLabel.sizeToFit;
      
      NSString *avatarURL = self.me.avatarURL;
      NSLog(@"%@",self.me.ownerLink);
      NSURL *imageURL = [NSURL URLWithString:avatarURL];
      NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
      UIImage *image = [UIImage imageWithData:imageData];
      self.me.avatarPhoto = image;
      self.profilePicture.image = self.me.avatarPhoto;
    }
  }];
}
- (IBAction)linkButtonPressed:(UIButton *)sender {
  LinkWebViewController *linkWebVC = [[LinkWebViewController alloc] init];
  linkWebVC.url = self.me.ownerLink;
  [self.navigationController pushViewController:linkWebVC animated:true];
  
}

- (void)dealloc {
//  [_myName release]; //release retains b4 superdealloc
  [_profile release];
  [_me release];
  [super dealloc];
}

@end
