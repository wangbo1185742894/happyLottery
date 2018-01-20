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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webDisBottom;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groupWebView.scrollView.bounces = NO;
    
    [self.groupWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/circle/index",H5BaseAddress]]]];
    [self setWebView];
}

-(void)setWebView{
    if ([Utility isIOS11After]) {
        self.webDisBottom.constant = 0;
    }else{
        self.webDisBottom.constant = 44;
    }
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
