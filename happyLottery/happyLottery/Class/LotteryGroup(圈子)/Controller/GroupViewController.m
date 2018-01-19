//
//  GroupViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "GroupViewController.h"

@interface GroupViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *groupWebView;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groupWebView.scrollView.bounces = NO;
    [self.groupWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.88.193:18086/app/circle/index"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

@end
