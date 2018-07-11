

//
//  WebShowViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/15.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "WebCTZQHisViewController.h"


@interface WebCTZQHisViewController ()<UIWebViewDelegate,JSObjcCTZQHisDelegate>
{
    JSContext *context;
    UIWebViewNavigationType _navigationType;
    BOOL isBackRoot;
    NSMutableArray *listArray;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webDisTop;
@property (weak, nonatomic) IBOutlet UIButton *btnPop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webDisBottom;

@property (weak, nonatomic) IBOutlet UIWebView *webViewShowInfo;

@end

@implementation WebCTZQHisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    listArray = [NSMutableArray arrayWithCapacity:0];
    self.webViewShowInfo.scrollView.bounces = NO;
    self.webViewShowInfo.delegate = self;
    [listArray addObject:self.pageUrl];
    [self.webViewShowInfo loadRequest:[NSURLRequest requestWithURL:self.pageUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0]];

    if ([self isIphoneX]) {
        self.webDisTop.constant = 44;
        self.webDisBottom.constant = 34;
    }else{
        self.webDisTop.constant = 20;
        self.webDisBottom.constant = 0;
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

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self showLoadingText:@"正在加载"];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
        [listArray addObject:request.URL];
    }
    if ([request.URL isEqual:self.pageUrl]) {
        isBackRoot = YES;//    UIWebViewNavigationTypeLinkClicked    UIWebViewNavigationTypeBackForward    UIWebViewNavigationTypeOther
    }else{
        isBackRoot = NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)actionPopView:(id)sender {
    if (isBackRoot == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [listArray removeLastObject];
        [self.webViewShowInfo loadRequest:[NSURLRequest requestWithURL:[listArray lastObject]]];
    }
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showPromptText:msg hideAfterDelay:1.7];
    });
}

-(void)goCathectic:(NSString *)lotteryCode{
    if (lotteryCode == nil) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showPromptText:lotteryCode hideAfterDelay:1.8];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NSNotificationJumpToPlayVC" object:lotteryCode];
        [self.navigationController popToRootViewControllerAnimated:NO];
    });
}

@end
