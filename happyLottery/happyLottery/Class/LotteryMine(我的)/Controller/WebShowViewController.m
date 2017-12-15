

//
//  WebShowViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/15.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "WebShowViewController.h"


@interface WebShowViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webViewShowInfo;

@end

@implementation WebShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webViewShowInfo.delegate = self;
    [self.webViewShowInfo loadRequest:[NSURLRequest requestWithURL:self.pageUrl]];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self showLoadingText:@"正在加载"];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideLoadingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
