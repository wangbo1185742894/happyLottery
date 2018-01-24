//
//  GroupViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "GroupViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface GroupViewController ()<JSObjcGourpDelegate,UIWebViewDelegate>{
    JSContext *context;
}
@property (weak, nonatomic) IBOutlet UIWebView *groupWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webDisBottom;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groupWebView.scrollView.bounces = NO;
    self.viewControllerNo = @"A402";
   self.groupWebView.delegate = self;
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
-(void)telPhone{
    //    [self showPromptText:code hideAfterDelay:1.8];
    [self actionTelMe];
  
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
