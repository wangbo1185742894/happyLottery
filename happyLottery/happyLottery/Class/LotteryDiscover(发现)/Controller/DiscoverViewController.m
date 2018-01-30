//
//  DiscoverViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "DiscoverViewController.h"
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/NSMutableDictionary+SSDKShare.h>
#import <MOBFoundation/MOBFoundation.h>
#import "JWCacheURLProtocol.h"
#import <WebKit/WebKit.h>

@interface DiscoverViewController ()<JSObjcDelegate,UIWebViewDelegate>
{
    __weak IBOutlet NSLayoutConstraint *webDisTop;
    JSContext *context;
    __weak IBOutlet NSLayoutConstraint *webDisBottom;
    BOOL _pageCacheDisable;
}

@property (weak, nonatomic) IBOutlet UIWebView *faxianWebView;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [JWCacheURLProtocol startListeningNetWorking];
     _pageCacheDisable = YES;
    self.viewControllerNo = @"A401";
    self.faxianWebView.scrollView.bounces = NO;
    self.faxianWebView.delegate = self;

    [self setWebView];
}

-(void)setWebView{
     if(KscreenWidth == 320){
        webDisBottom.constant = -100;
     }else if ([Utility isIOS11After]) {
        webDisTop.constant = 0;
        webDisBottom.constant = 0;
    }else{
        webDisTop.constant = 20;
        webDisBottom.constant = 44;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.pageUrl != nil) {
        [self.faxianWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.pageUrl]]];
    }else{
        NSString *cardCode = @"";
        if (self.curUser.isLogin == YES) {
            cardCode = self.curUser.cardCode;
        }
        
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/find/index?cardCode=%@",H5BaseAddress,cardCode]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
        
        
        [self.faxianWebView loadRequest:request];
    }
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [JWCacheURLProtocol cancelListeningNetWorking];
    self.pageUrl = nil;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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

-(void)webViewDidStartLoad:(UIWebView *)webView{
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *URL = request.URL;
    NSString *scheme = [NSString stringWithFormat:@"%@",URL];
    if ([scheme containsString:@"index"]) {
        self.tabBarController.tabBar.hidden = NO;
        webDisBottom.constant = 44;
    }else{
        self.tabBarController.tabBar.hidden = YES;
        webDisBottom.constant = 0;
    }
    [self removeWebCache];
    return YES;
}

#pragma JSObjcDelegate

-(void)SharingLinks:(NSString *)code{
//    [self showPromptText:code hideAfterDelay:1.8];
    dispatch_async(dispatch_get_main_queue(), ^{

        [self initshare:code];
    });
}

-(void)initshare:(NSString *)code{
    NSURL *url;
    if (![code isEqualToString:@""]) {
       url  =  [NSURL URLWithString:code];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        NSArray* imageArray = @[[[NSBundle mainBundle] pathForResource:@"logo120@2x" ofType:@"png"]];
        [shareParams SSDKSetupShareParamsByText:@"投必中"
                                         images:imageArray
                                            url:url
                                          title:@"分享投必中"
                                           type:SSDKContentTypeImage];
        [ShareSDK showShareActionSheet:nil
                                 items:@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)]
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                               
                           case SSDKResponseStateBegin:
                           {
                               //设置UI等操作
                               break;
                           }
                           case SSDKResponseStateSuccess:
                           {
                               //Instagram、Line等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                               if (platformType == SSDKPlatformTypeInstagram)
                               {
                                   break;
                               }
                               
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               NSLog(@"%@",error);
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           case SSDKResponseStateCancel:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           default:
                               break;
                       }
                   }];
    }else{
        return;
    }
   
    
}

-(void)goToJczq{

    dispatch_async(dispatch_get_main_queue(), ^{
        self.tabBarController.selectedIndex = 0;
        
       [[NSNotificationCenter defaultCenter]postNotificationName:@"NSNotificationBuyVCJump" object:@1000];
        
    });

}



-(void)hiddenFooter:(BOOL )isHiden{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tabBarController.tabBar .hidden =isHiden;
        if (isHiden == YES) {
            webDisBottom.constant = -100;

        }else{
            webDisBottom.constant = -100;
        }
    });
}

-(void)goToLogin{
    [self needLogin];
}

- (void)telPhone{
    [self actionTelMe];
}



@end
