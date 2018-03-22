//
//  HomeJumpViewController.m
//  Lottery
//
//  Created by LC on 16/6/1.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "HomeJumpViewController.h"
#import "UIImage+RandomSize.h"
#import "UIImageView+WebCache.h"
#import <JavaScriptCore/JavaScriptCore.h>


@interface HomeJumpViewController ()<JSJumpDelegate,UIWebViewDelegate>
{
    JSContext *context;
}
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *labBack;

@end

@implementation HomeJumpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动信息";
    if (_isNeedBack) {
        
    }
    
    self.title = self.infoModel.title;
    [self showWeb];
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isNeedBack) {
        
        self .navigationController.navigationBar.hidden = YES;
        if (self.curUser.isLogin == YES) {
            self.infoModel.linkUrl = [NSString stringWithFormat:@"%@/app/find/turntable?activityId=5&cardCode=%@",H5BaseAddress,[GlobalInstance instance].curUser.cardCode];
            [self showWeb];
        }
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_isNeedBack) {
        
        self .navigationController.navigationBar.hidden = NO;
    }
}

- (void)showWeb{
    NSLog(@"网页");
    
    
    NSURL *linkUrl;
    if (self.curUser.isLogin == YES) {
       NSString * slinkUrl = _infoModel.linkUrl;
        if (self.curUser.cardCode != nil && self.isNeedBack == NO) {
            linkUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?cardCode=%@",slinkUrl,self.curUser.cardCode]];
        }else{
            linkUrl = [NSURL URLWithString:_infoModel.linkUrl];
        }
        
    }else{
        linkUrl = [NSURL URLWithString:_infoModel.linkUrl];
    }
    UIWebView *webView;
    if (_isNeedBack) {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, KscreenWidth, KscreenHeight - 20)];
    }else{
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, KscreenWidth, KscreenHeight - 64)];
    }
    webView.delegate = self;
    
    [self.view addSubview:webView];
    webView.scrollView.bounces = NO;
    
    [self.view bringSubviewToFront:_btnBack];
    [webView loadRequest:[NSURLRequest requestWithURL:linkUrl]];
}

- (IBAction)actionBack:(id)sender {
    [super navigationBackToLastPage];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if (_isNeedBack) {
        self.btnBack.hidden = NO;
        self.labBack.hidden = NO;
    }
    context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"appObj"] = self;
    context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
    };
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

-(void)goToLogin{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self needLogin];
    });
}

-(void)goToJczq{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NSNotificationBuyVCJump" object:@1000];
        
    });
    
}
-(void)exchangeToast:(NSString *)msg{
    [self showPromptText:msg hideAfterDelay:1.7];
}

@end
