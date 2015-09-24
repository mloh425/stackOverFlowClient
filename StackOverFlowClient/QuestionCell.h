//
//  QuestionCell.h
//  
//
//  Created by Sau Chung Loh on 9/16/15.
//
//

#import <UIKit/UIKit.h>

@interface QuestionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
