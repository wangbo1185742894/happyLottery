//
//  DiscoverViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "DiscoverViewController.h"
#import <ShareSDK/ShareSDK+Base.h>
#import "PersonCenterViewController.h"
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/NSMutableDictionary+SSDKShare.h>
#import <MOBFoundation/MOBFoundation.h>
#import "JWCacheURLProtocol.h"
#import "JCZQPlayViewController.h"
#import "MyCouponViewController.h"
#import "TopUpsViewController.h"
#import <WebKit/WebKit.h>

@interface DiscoverViewController ()<JSObjcDelegate,UIWebViewDelegate,LotteryManagerDelegate>
{
    __weak IBOutlet NSLayoutConstraint *webDisTop;
    JSContext *context;
    BOOL isBack;
    BOOL isIndex;
    BOOL lastLoginState;
    __weak IBOutlet NSLayoutConstraint *bottomDis;
    NSString *_cardCode;
    __weak IBOutlet NSLayoutConstraint *webDisBottom;
    BOOL _pageCacheDisable;
    NSString *shareTitle;
    NSString *shareText;
}

@property (weak, nonatomic) IBOutlet UIWebView *faxianWebView;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isBack = NO;
    isIndex = YES;
    self.lotteryMan.delegate = self;
    lastLoginState = self.curUser.isLogin;
    
     _pageCacheDisable = YES;
    self.viewControllerNo = @"A401";
    self.faxianWebView.scrollView.bounces = NO;
    self.faxianWebView.delegate = self;
    NSString *cardCode = @"";
    if (self.curUser.isLogin == YES) {
        cardCode = self.curUser.cardCode;
        _cardCode = self.curUser.cardCode;
    }else{
        _cardCode = @"";
    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/find/index?cardCode=%@",H5BaseAddress,cardCode]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:100];
    
    
    [self.faxianWebView loadRequest:request];
    [self setWebView];
}

-(void)setWebView{
    if ([self isIphoneX]) {
        webDisTop.constant = 44;
    }else if ([Utility isIOS11After]) {
        webDisTop.constant = 20;
        webDisBottom.constant =44;
     }else{
        webDisTop.constant = 20;
        webDisBottom.constant = 44;
     }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSString *cardCode = @"";
    if (self.curUser.isLogin == YES) {
        cardCode = self.curUser.cardCode;
    }
    if (lastLoginState != self.curUser.isLogin || ![_cardCode isEqualToString:self.curUser.cardCode]) {
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/find/index?cardCode=%@",H5BaseAddress,cardCode]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:100];
        
        
        [self.faxianWebView loadRequest:request];
    }
    
    self.navigationController.navigationBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [JWCacheURLProtocol cancelListeningNetWorking];
    if (self.curUser.isLogin == YES) {
        
        _cardCode = self.curUser.cardCode;
    }else{
        _cardCode = @"";
    }
    
    lastLoginState = self.curUser.isLogin;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoadingView];
    if (self.tabBarController.selectedIndex != 3) {
        self.tabBarController.tabBar.hidden = NO;
        return;
    }
    if (isBack == YES && self.tabBarController.tabBar.hidden == YES) {
        [self.faxianWebView reload];
    }
    context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"appObj"] = self;
    context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
    };
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    if (self.tabBarController.selectedIndex != 3) {
        return;
    }
    [self showLoadingText:@"正在加载"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (self.tabBarController.selectedIndex != 3) {
        return NO;
    }
    [self removeWebCache];
    [self cleanWebviewCache];
    if (navigationType == UIWebViewNavigationTypeBackForward) {
        isBack = YES;
    }else{
        isBack =NO;          
    }
    
    request = [NSURLRequest requestWithURL:request.URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:100];
    
    
    NSURL *URL = request.URL;
    NSString *scheme = [NSString stringWithFormat:@"%@",URL];
    if ([scheme containsString:@"index"]&&![scheme containsString:@"isLogin"]) {
        self.tabBarController.tabBar.hidden = NO;
        
        if ([Utility isIOS11After]) {
            webDisBottom.constant = 44;

        }else{
            
            webDisBottom.constant = 44;
        }
    }else{
        self.tabBarController.tabBar.hidden = YES;
        if ([Utility isIOS11After]) {
            webDisBottom.constant = 0;
        }else{
            webDisBottom.constant = 0;
        }
    }
    [self removeWebCache];
    return YES;
}

#pragma JSObjcDelegate

-(void)SharingLinks{
    //    [self showPromptText:code hideAfterDelay:1.8];
    [self.lotteryMan getCommonSetValue:@{@"typeCode":@"share",@"commonCode":@"share_activity"}];
}

-(void)gotCommonSetValue:(NSString *)strUrl{
    if (strUrl == nil || strUrl.length == 0) {
        return;
    }
    NSArray *arrayText = [strUrl componentsSeparatedByString:@"|"];
    shareTitle = arrayText[0];
    shareText = arrayText[1];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initshare:@""];
    });
}

-(void)initshare:code{
    
    if (self.curUser.isLogin == NO) {
        [self needLogin];
        return;
    }
  
        NSString *url = [self.curUser getShareUrl];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        NSArray* imageArray = @[[[NSBundle mainBundle] pathForResource:@"logo120@2x" ofType:@"png"]];
        [shareParams SSDKSetupShareParamsByText:shareText
                                         images:imageArray
                                            url:[NSURL URLWithString:url]
                                          title:shareTitle
                                           type:SSDKContentTypeWebPage];
        [ShareSDK showShareActionSheet:nil
                                 items:@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)]
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                               
                           case SSDKResponseStateBegin:
                           {
                               //设置UI等操作
                               //Instagram、Line等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                               if (platformType == SSDKPlatformSubTypeWechatSession)
                               {
                                   [self giveShareScoreClient];
                                   break;
                               }
                               break;
                           }
                           case SSDKResponseStateSuccess:
                           {
                               
                               
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               if (platformType == SSDKPlatformSubTypeWechatTimeline)
                               {
                                   [self giveShareScoreClient];
                                   
                               }
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
                               if (userData != nil) {
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                               }
                               break;
                           }
                           default:
                               break;
                       }
                   }];

}

-(void)giveShareScoreClient{
    NSDictionary *Info;
    @try {
        
        Info = @{@"cardCode":self.curUser.cardCode
                 };
        
    } @catch (NSException *exception) {
        return;
    }
    [self.memberMan giveShareScore:Info];
    
}

-(NSString *)getCardCode{
    if (self.curUser.isLogin ==YES) {
        return self.curUser.cardCode;
    }else{
        return @"";
    }
}

-(void)giveShareScore:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
//        [self showPromptText: @"积分赠送成功" hideAfterDelay: 1.7];
        
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

-(void)goToJczq{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.tabBarController.selectedIndex = 0;
    
    });
    dispatch_async(dispatch_get_main_queue(), ^{
          [self.faxianWebView goBack];
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

-(void)goCathectic:(NSString *)lotteryCode :(NSString *)cardCode{ //跳转竟足  充值  优惠券
    if ([lotteryCode isEqualToString: @"GRZX"]) {
        if (cardCode.length == 0) {
            return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            PersonCenterViewController *personVC = [[PersonCenterViewController alloc]init];
            personVC.cardCode = cardCode;
            personVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:personVC animated:YES];
        });
        return;
    }
    if (self.curUser.isLogin == NO) {
        [self needLogin];
        return;
    }
    if ([lotteryCode isEqualToString:@"JCZQ"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            JCZQPlayViewController * playViewVC = [[JCZQPlayViewController alloc]init];
            playViewVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:playViewVC animated:YES];
            
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.faxianWebView goBack];
        });
        return;
    }
    
    
    if ([lotteryCode isEqualToString:@"YHQ"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MyCouponViewController *couponVC = [[MyCouponViewController alloc]init];
            couponVC.hidesBottomBarWhenPushed = YES;
            [self .navigationController pushViewController:couponVC animated:YES];
            
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [self.faxianWebView goBack];
        });
     
        return;
    }
    
    if ([lotteryCode isEqualToString:@"CZ"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            TopUpsViewController *topUpsVC = [[TopUpsViewController alloc]init];
            topUpsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:topUpsVC animated:YES];
            
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.faxianWebView goBack];
        });
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NSNotificationJumpToPlayVC" object:lotteryCode];
        [self.navigationController popToRootViewControllerAnimated:NO];
    });
}

-(void)goToLogin{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self needLogin];
    });
}


- (void)telPhone{
    [self actionTelMe];
}


-(void)exchangeToast:(NSString *)msg{
    [self showPromptText:msg hideAfterDelay:1.7];
}

- (void)removeWebCache{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        NSSet *websiteDataTypes= [NSSet setWithArray:@[
                                                       WKWebsiteDataTypeDiskCache,
                                                       //WKWebsiteDataTypeOfflineWebApplication
                                                       WKWebsiteDataTypeMemoryCache,
                                                       //WKWebsiteDataTypeLocal
                                                       WKWebsiteDataTypeCookies,
                                                       //WKWebsiteDataTypeSessionStorage,
                                                       //WKWebsiteDataTypeIndexedDBDatabases,
                                                       //WKWebsiteDataTypeWebSQLDatabases
                                                       ]];
        
        // All kinds of data
        //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
    } else {
        //先删除cookie
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            [storage deleteCookie:cookie];
        }
        
        NSString *libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *bundleId = [[[NSBundle mainBundle] infoDictionary]
                              objectForKey:@"CFBundleIdentifier"];
        NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
        NSString *webKitFolderInCaches = [NSString
                                          stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
        NSString *webKitFolderInCachesfs = [NSString
                                            stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
        NSError *error;
        /* iOS8.0 WebView Cache的存放路径 */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
        /* iOS7.0 WebView Cache的存放路径 */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
        NSString *cookiesFolderPath = [libraryDir stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&error];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
}



@end
