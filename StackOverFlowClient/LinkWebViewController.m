//
//  LinkWebViewController.m
//  StackOverFlowClient
//
//  Created by Sau Chung Loh on 9/17/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import "LinkWebViewController.h"
#import <WebKit/Webkit.h>

@interface LinkWebViewController () <WKNavigationDelegate>



@end

@implementation LinkWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
  [self.view addSubview:webView];
  webView.navigationDelegate = self;
  //self.navigationController.navigationBarHidden = true;
  [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    // Do any additional setup after loading the view.
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

@end
//ShowLinkSegue