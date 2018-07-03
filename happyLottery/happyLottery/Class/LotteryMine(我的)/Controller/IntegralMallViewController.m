//
//  IntegralMallViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/12.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//  积分商城

#import "IntegralMallViewController.h"
#import "MyCouponViewController.h"

@interface IntegralMallViewController ()<UIWebViewDelegate,JSObjcIntegralDelegate>
{
    JSContext *context;
    __weak IBOutlet NSLayoutConstraint *webDisBottom;
    __weak IBOutlet NSLayoutConstraint *webDisTop;
    BOOL isBack;
}
@property (weak, nonatomic) IBOutlet UIWebView *webContentView;

@end

@implementation IntegralMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightBarItems];
    self.viewControllerNo = @"A313";
    self.title = @"积分商城";
    self.webContentView.scrollView.bounces = NO;
    self.webContentView.delegate = self;

    
    NSString *cardCode = @"";
    if (self.curUser.isLogin == YES) {
        cardCode = self.curUser.cardCode;
    }
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/mall/index?cardCode=%@",H5BaseAddress,cardCode]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [self.webContentView loadRequest:request];
    [self setWebView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if (navigationType == UIWebViewNavigationTypeBackForward) {
        isBack = YES;
        webView.hidden = YES;
    }else{
        isBack =NO;
    }
    
    [self showLoadingViewWithText:@"正在加载"];
    NSString *requsetIngUrlStr =[NSString stringWithFormat:@"%@",request.URL];
    if ([requsetIngUrlStr containsString:@"/index"]) {
        self.navigationController.navigationBar.hidden = NO;
        if ([self isIphoneX]) {
            webDisTop.constant = 44;
        }else if ([Utility isIOS11After]) {
            webDisTop.constant = 0;
        }else{
            webDisTop.constant = 64;
        }
        
    }else{
        self.navigationController.navigationBar.hidden = YES;
        if ([self isIphoneX]) {
            webDisTop.constant = 44;
        }else if ([Utility isIOS11After]) {
            webDisTop.constant = 0;
        }else{
             webDisTop.constant = 20;
        }
       
    }
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if (isBack) {
        [self.webContentView reload];
    }else{
        webView.hidden = NO;
    }
    [self hideLoadingView];
    context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"appObj"] = self;
    context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
    };
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)setRightBarItems{
    
    UIBarButtonItem *itemQuery = [self creatBarItem:@"" icon:@"coupon" andFrame:CGRectMake(0, 10, 25, 25) andAction:@selector(actionPlayTypeRecom)];

    self.navigationItem.rightBarButtonItem = itemQuery;
}


-(void)actionPlayTypeRecom{
    MyCouponViewController * mpVC = [[MyCouponViewController alloc]init];
    [self.navigationController pushViewController:mpVC animated:YES];
}

-(void)setWebView{
    if ([self isIphoneX]) {
        webDisTop.constant = 88;
         webDisBottom.constant = 0;
    }else if ([Utility isIOS11After]) {
        webDisTop.constant = 0;
        webDisBottom.constant = 0;
    }else{
        webDisTop.constant = 20;
        webDisBottom.constant = 0;
    }
}
-(void)exchangeToast:(NSString *)msg{
    [self showPromptText:msg hideAfterDelay:1.7];
}


@end
