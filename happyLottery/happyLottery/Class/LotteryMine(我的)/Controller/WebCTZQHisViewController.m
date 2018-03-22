

//
//  WebShowViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/15.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "WebCTZQHisViewController.h"


@interface WebCTZQHisViewController ()<UIWebViewDelegate>
{
    JSContext *context;
}
@property (weak, nonatomic) IBOutlet UIButton *btnPop;

@property (weak, nonatomic) IBOutlet UIWebView *webViewShowInfo;

@end

@implementation WebCTZQHisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.webViewShowInfo.scrollView.bounces = NO;
    self.webViewShowInfo.delegate = self;
    [self.webViewShowInfo loadRequest:[NSURLRequest requestWithURL:self.pageUrl]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self showLoadingText:@"正在加载"];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([request.URL isEqual:self.pageUrl]) {
        self.btnPop.userInteractionEnabled = YES;
    }else{
        self.btnPop.userInteractionEnabled = NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)actionPopView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoadingView];
    context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"appObj"] = self;
    context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
    };
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}
-(void)exchangeToast:(NSString *)msg{
    [self showPromptText:msg hideAfterDelay:1.7];
}

@end
