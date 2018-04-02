//
//  WebViewController.m
//  Lottery
//
//  Created by 王博 on 2017/6/28.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_htmlName ofType:self.type]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self useBackButton:NO];
//    [self setNavigationBarStyle];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}


@end
