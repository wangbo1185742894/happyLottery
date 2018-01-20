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
    __weak IBOutlet NSLayoutConstraint *webDisTop;
    JSContext *context;
    __weak IBOutlet NSLayoutConstraint *webDisBottom;
}

@property (weak, nonatomic) IBOutlet UIWebView *faxianWebView;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.faxianWebView.scrollView.bounces = NO;
    self.faxianWebView.delegate = self;
    [self.faxianWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.88.193:18086/app/find/index"]]];
    [self setWebView];
}

-(void)setWebView{
    if ([Utility isIOS11After]) {
        webDisTop.constant = 0;
        webDisBottom.constant = 0;
    }else{
        webDisTop.constant = 20;
        webDisBottom.constant = 44;
    }
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


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"appObj"] = self;
    
    context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
    };
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
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
    [self showPromptText:@"getCardCode来啦" hideAfterDelay:1.9];
    
    return self.curUser.cardCode;
    
}

-(void)goToLogin{
    [self showPromptText:@"goToLogin来啦" hideAfterDelay:1.9];
}

@end
