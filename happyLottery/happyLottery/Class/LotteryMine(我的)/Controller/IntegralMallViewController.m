//
//  IntegralMallViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/12.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//  积分商城

#import "IntegralMallViewController.h"
#import "MyCouponViewController.h"

@interface IntegralMallViewController ()<UIWebViewDelegate>
{
    
    __weak IBOutlet NSLayoutConstraint *webDisBottom;
    __weak IBOutlet NSLayoutConstraint *webDisTop;
}
@property (weak, nonatomic) IBOutlet UIWebView *webContentView;

@end

@implementation IntegralMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightBarItems];
    self.viewControllerNo = @"A313";
    self.title = @"积分商城";
    self.webContentView.scrollView.bounces = NO;
    self.webContentView.delegate = self;
//    [NSString stringWithFormat:@"%@/app/find/index",H5BaseAddress]
    [self.webContentView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.88.193:18086/app/mall/index"]]];
    [self setWebView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    [self showLoadingViewWithText:@"正在加载"];
    NSString *requsetIngUrlStr =[NSString stringWithFormat:@"%@",request.URL];
    if ([requsetIngUrlStr containsString:@"/index"]) {
        self.navigationController.navigationBar.hidden = NO;
    }else{
        self.navigationController.navigationBar.hidden = YES;
    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideLoadingView];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)setRightBarItems{
    
    UIBarButtonItem *itemQuery = [self creatBarItem:@"" icon:@"coupon" andFrame:CGRectMake(0, 10, 25, 25) andAction:@selector(actionPlayTypeRecom)];

    self.navigationItem.rightBarButtonItem = itemQuery;
}


-(void)actionPlayTypeRecom{
    MyCouponViewController * mpVC = [[MyCouponViewController alloc]init];
    [self.navigationController pushViewController:mpVC animated:YES];
}

-(void)setWebView{
    if ([Utility isIOS11After]) {
        webDisTop.constant = 0;
        webDisBottom.constant = 0;
    }else{
        webDisTop.constant = 20;
        webDisBottom.constant = 0;
    }
}

@end
