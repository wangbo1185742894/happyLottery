//
//  GroupViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "GroupViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface GroupViewController ()<JSObjcDelegate,UIWebViewDelegate>{
    JSContext *context;
}
@property (weak, nonatomic) IBOutlet UIWebView *groupWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webDisBottom;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groupWebView.scrollView.bounces = NO;
      self.groupWebView.delegate = self;
    [self.groupWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.88.193:18086/app/circle/index"]]];
    [self setWebView];
}

-(void)setWebView{
    if ([Utility isIOS11After]) {
        self.webDisBottom.constant = 0;
    }else{
        self.webDisBottom.constant = 44;
    }
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
-(void)telPhone{
    //    [self showPromptText:code hideAfterDelay:1.8];
     [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://4006005558"]];
//    dispatch_async(dispatch_get_main_queue(), ^{
//       
//       
//    });
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
