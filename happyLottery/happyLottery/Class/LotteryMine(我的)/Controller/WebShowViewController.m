

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
    NSString *strUrl = [NSString stringWithFormat:@"%@",self.pageUrl];
    if ([strUrl rangeOfString:@"dltOpenAward"].length > 0) {
        self.viewControllerNo = @"A414";
    }else if ([strUrl rangeOfString:@"jzOpenAward"].length > 0){
        self.viewControllerNo = @"A412";
    }else if ([strUrl rangeOfString:@"sfcOpenAward"].length > 0){
        self.viewControllerNo = @"A415";
    }
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
