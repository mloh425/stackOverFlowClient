//
//  BurgerMenuViewController.m
//  StackOverFlowClient
//
//  Created by Sau Chung Loh on 9/14/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import "BurgerMenuViewController.h"
#import "QuestionSearchViewController.h"
#import "MyQuestionsViewController.h"
#import "WebViewController.h"
#import "MyProfileViewController.h"
#import "MenuTableTableViewController.h"

CGFloat const kburgerOpenScreenDivider = 3.0;
CGFloat const kburgerOpenScreenMultiplier = 2.0;
NSTimeInterval const ktimeToSlideMenuOpen = 0.3;
CGFloat const kburgerButtonWidth = 50.0;
CGFloat const kburgerButtonHeight = 50.0;
static void *isDownloadingContext = &isDownloadingContext;

@interface BurgerMenuViewController () <UITableViewDelegate>
@property (strong, nonatomic) UIViewController *topViewController; //points to any VC currently on top, will change
@property (strong, nonatomic) UIButton *burgerButton;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@property (strong, nonatomic) NSArray *viewControllers;
@property (nonatomic) CGRect offScreenVCFrame;
@property (strong, nonatomic) MenuTableTableViewController *menuVC;
@property (strong, nonatomic) QuestionSearchViewController *questionSearchViewController;
@end

@implementation BurgerMenuViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.offScreenVCFrame = CGRectMake(self.view.frame.origin.x + self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
  
  //Main Menu TableView Controller
  MenuTableTableViewController *mainMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
  mainMenuVC.tableView.delegate = self;
  [self addChildViewController:mainMenuVC];
  mainMenuVC.view.frame = self.view.frame;
  [self.view addSubview:mainMenuVC.view];
  [mainMenuVC didMoveToParentViewController:self];
  mainMenuVC.tableView.delegate = self;
  
  //Setting up Question Search VC
  UINavigationController *questionNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionNavController"];
  [self addChildViewController:questionNavController];
  questionNavController.view.frame = self.view.frame;
  [self.view addSubview:questionNavController.view];
  [questionNavController didMoveToParentViewController:self];
  
  QuestionSearchViewController *questionSearchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionSearch"];
  self.questionSearchViewController = questionSearchVC;
  [questionSearchVC addObserver:self forKeyPath:NSStringFromSelector(@selector(questionSearchViewController)) options:NSKeyValueObservingOptionNew context:isDownloadingContext];
  
  NSArray *questionNavigationControllerVCs = [questionNavController viewControllers];
  //self.questionSearchViewController = questionNavigationControllerVCs[0];
  
  MyQuestionsViewController *myQuestionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyQuestions"];
  
  //My Profile VC
  UINavigationController *myProfileNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileNavVC"];
  //questionSearchVC
  self.viewControllers = @[questionNavController, myQuestionsVC, myProfileNavController];
  self.topViewController = questionNavController;
  
  //Burger Button Code
  UIButton *burgerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, kburgerButtonWidth, kburgerButtonHeight)];
  [burgerButton setImage:[UIImage imageNamed:@"burgerMenuPicture"] forState:UIControlStateNormal];
  [self.topViewController.view addSubview:burgerButton];
  [burgerButton addTarget:self action:@selector(burgerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  self.burgerButton = burgerButton;
  
  //Pan Gesture
  UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(topViewControllerPanned:)];
  [self.topViewController.view addGestureRecognizer:pan];//////////////
  self.pan = pan;
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  //check if you already have the token
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults objectForKey:@"token"] == nil) {
    WebViewController *webVC = [[WebViewController alloc] init];
    [self presentViewController:webVC animated:true completion:nil];
  }
}

- (void)burgerButtonPressed:(UIButton *)sender {
  [UIView animateWithDuration:ktimeToSlideMenuOpen animations:^{
    self.topViewController.view.center = CGPointMake(self.view.center.x * kburgerOpenScreenMultiplier, self.topViewController.view.center.y);
  } completion:^(BOOL finished) {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseMenu:)];
    [self.topViewController.view addGestureRecognizer:tap];
    sender.userInteractionEnabled = false;
  }];
}

//Pan Gesture for second VC
- (void)topViewControllerPanned:(UIPanGestureRecognizer *)sender {
  CGPoint velocity = [sender velocityInView:self.topViewController.view]; //Speed of gesture.
  CGPoint translation = [sender translationInView:self.topViewController.view]; //Total distance moved w/ gesture.
  
  if (sender.state ==UIGestureRecognizerStateChanged) {
    if (velocity.x > 0) {
      self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translation.x, self.topViewController.view.center.y);
      [sender setTranslation:CGPointZero inView:self.topViewController.view]; //Be sure to reset to zero otherwise will accumulate and fly off
    }
  }
  
  if (sender.state == UIGestureRecognizerStateEnded) {
    //Did they at least move it a third of the screen? if so, open it
    if (self.topViewController.view.frame.origin.x > self.topViewController.view.frame.size.width / kburgerOpenScreenDivider) {
      //User is opening menu
      [UIView animateWithDuration:ktimeToSlideMenuOpen animations:^{
        self.topViewController.view.center = CGPointMake(self.view.center.x * kburgerOpenScreenMultiplier, self.topViewController.view.center.y);
      } completion:^(BOOL finished) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseMenu:)];
        [self.topViewController.view addGestureRecognizer:tap];
        self.burgerButton.userInteractionEnabled = false;
        
      }];
    } else {
      //User did not open the window at least a third of the screen, animate it to close
      [UIView animateWithDuration:ktimeToSlideMenuOpen animations:^{
        self.topViewController.view.center = CGPointMake(self.view.center.x, self.topViewController.view.center.y);
      } completion:nil];
    }
  }
}

//If user taps an open VC, just close it.
- (void)tapToCloseMenu:(UITapGestureRecognizer *) tap {
  [self.topViewController.view removeGestureRecognizer:tap];
  [UIView animateWithDuration:0.3 animations:^{
    self.topViewController.view.center = self.view.center;
  } completion:^(BOOL finished) {
    self.burgerButton.userInteractionEnabled = true;
  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)switchToViewController:(UIViewController *)selectedViewController {
  [UIView animateWithDuration:ktimeToSlideMenuOpen animations:^{
    self.topViewController.view.frame = self.offScreenVCFrame;
  } completion:^(BOOL finished) {
    [self.topViewController willMoveToParentViewController:nil];
    [self.topViewController.view removeFromSuperview];
    [self.topViewController removeFromParentViewController];
    
    [self addChildViewController:selectedViewController];
    selectedViewController.view.frame = self.offScreenVCFrame;
    [self.view addSubview:selectedViewController.view];
    [selectedViewController didMoveToParentViewController:self];
    self.topViewController = selectedViewController;
    
    [self.burgerButton removeFromSuperview];
    [self.topViewController.view addSubview:self.burgerButton];
    
    [UIView animateWithDuration:ktimeToSlideMenuOpen animations:^{
      self.topViewController.view.center = self.view.center;
    } completion:^(BOOL finished) {
      [self.topViewController.view addGestureRecognizer:self.pan];
      self.burgerButton.userInteractionEnabled = true;
    }];
  }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
  if (context == isDownloadingContext) {
    BOOL newValue = [(NSNumber *)change[NSKeyValueChangeNewKey] boolValue];
    if (newValue) {
      [self.menuVC.downloadActivityIndicator startAnimating];
    } else {
      [self.menuVC.downloadActivityIndicator stopAnimating];
    }
    
  }
}

#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UIViewController *selectedViewController = self.viewControllers[indexPath.row];
  if(![selectedViewController isEqual:self.topViewController]) {
    [self switchToViewController:selectedViewController];
  }
}

@end
