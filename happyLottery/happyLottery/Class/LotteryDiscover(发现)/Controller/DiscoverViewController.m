//
//  DiscoverViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "DiscoverViewController.h"


@interface DiscoverViewController ()<JSObjcDelegate,UIWebViewDelegate>
{
    JSContext *context;
}

@property (weak, nonatomic) IBOutlet UIWebView *faxianWebView;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.faxianWebView.scrollView.bounces = NO;
    self.faxianWebView.delegate = self;
    [self.faxianWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.88.193:18086/app/find/index"]]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"appObj"] = self;
    context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        
    };
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *URL = request.URL;
    NSString *scheme = [NSString stringWithFormat:@"%@",URL];
    return YES;
}


#pragma JSObjcDelegate
-(void)SharingLinks:(NSString *)code{
    [self showPromptText:code hideAfterDelay:1.8];
}

-(void)goToJczq{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"NSNotificationBuyVCJump" object:@1000];
    self.tabBarController.selectedIndex = 0;
}

-(NSString *)getCardCode{
    if (self.curUser .isLogin == YES) {
        return self.curUser.cardCode;
    }else{
        return @"";
    }
}

-(void)goToLogin{
    
}

@end
