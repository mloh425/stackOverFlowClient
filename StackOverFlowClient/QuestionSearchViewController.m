//
//  QuestionSearchViewController.m
//  StackOverFlowClient
//
//  Created by Sau Chung Loh on 9/14/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import "QuestionSearchViewController.h"
#import "StackOverFlowService.h"
#import "Question.h"
#import "QuestionCell.h"
#import "LinkWebViewController.h"

@interface QuestionSearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *questions;

@end

@implementation QuestionSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.searchBar.delegate = self;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imageDownloader {
  dispatch_group_t group = dispatch_group_create();
  dispatch_queue_t imageQueue = dispatch_queue_create("com.codefellows.stackoverflow",DISPATCH_QUEUE_CONCURRENT );
  
  for (Question *question in self.questions) {
    dispatch_group_async(group, imageQueue, ^{
      NSString *avatarURL = question.avatarURL;
      NSURL *imageURL = [NSURL URLWithString:avatarURL];
      NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
      UIImage *image = [UIImage imageWithData:imageData];
      question.avatarPhoto = image;
    });
  }
  
  dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Images Downloaded" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      [alertController dismissViewControllerAnimated:true completion:nil];
    }];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:true completion:nil];
    self.isDownloading = false;
    [self.tableView reloadData];
  });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"ShowLinkSegue"]) {


  }
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.questions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  QuestionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"QuestionCell" forIndexPath:indexPath];
  Question *question = self.questions[indexPath.row];
  cell.tag++;
  NSInteger tag = cell.tag;
  if (cell.tag == tag) {
    cell.avatarImage.image = question.avatarPhoto;
  }
  cell.ownerLabel.text = question.ownerName;
  cell.titleLabel.text = question.title;
  return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  LinkWebViewController *linkWebVC = [[LinkWebViewController alloc] init];
  Question *object = self.questions[indexPath.row];
  linkWebVC.url = object.questionLink;
  [self.navigationController pushViewController:linkWebVC animated:true];
 // [self performSegueWithIdentifier:@"ShowLinkSegue" sender:nil];
}


#pragma mark - UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  self.isDownloading = true;
  [StackOverFlowService questionsForSearchTerm:searchBar.text completionHandler:^(NSArray *results, NSError *error) {
    if (error) {
      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:true completion:nil];
      }];
      [alertController addAction:action];
      
      [self presentViewController:alertController animated:true completion:nil];
    } else {
      self.questions = results;
      [self imageDownloader];
    }
  }];
   [self.searchBar resignFirstResponder];
}


@end
