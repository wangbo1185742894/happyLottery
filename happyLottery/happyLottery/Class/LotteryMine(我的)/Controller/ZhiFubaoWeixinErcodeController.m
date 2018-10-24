//
//  ZhiFubaoWeixinErcodeController.m
//  Lottery
//
//  Created by 王博 on 2017/10/20.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "ZhiFubaoWeixinErcodeController.h"
#import "QRCodeGenerator.h"
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/NSMutableDictionary+SSDKShare.h>
#import <MOBFoundation/MOBFoundation.h>

@interface ZhiFubaoWeixinErcodeController ()<UIWebViewDelegate>{
    JSContext *context;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ZhiFubaoWeixinErcodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topDis.constant = NaviHeight;
    self.title  = @"扫码支付";
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/recharge/indexWX?orderNo=%@",H5BaseAddress,self.orderNo]]]];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self showLoadingViewWithText:@"正在加载"];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideLoadingView];
    context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"appObj"] = [self getJumpHandler];
    context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
    };
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}


@end
