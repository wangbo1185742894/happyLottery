//
//  WebViewController.m
//  Lottery
//
//  Created by 王博 on 2017/6/28.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "WebViewController.h"
#import "MyCouponViewController.h"
#import "TopUpsViewController.h"
#import "JCZQPlayViewController.h"

@interface WebViewController ()<UIWebViewDelegate,WebViewObjcDelegate>{
    JSContext *context;
}
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       self.webView.delegate = self;
    if (self.pageUrl == nil) {
        if ([self isIphoneX]) {
            self.topDis.constant = 88;
        }else{
            self.topDis.constant = 64;
            if ([Utility isIOS11After]) {
                self.automaticallyAdjustsScrollViewInsets = NO; // tableView 莫名其妙  contentOffset.y 成-64了  MMP
            }
        }
        if (_htmlName==nil) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_htmlName ofType:self.type]];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }else{
        
        if ([self isIphoneX]) {
            self.topDis.constant = 44;
        }else{
            self.topDis.constant = 20;
            if ([Utility isIOS11After]) {
                self.automaticallyAdjustsScrollViewInsets = NO; // tableView 莫名其妙  contentOffset.y 成-64了  MMP
            }
        }
       NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?isLogin=%@&cardCode=%@",self.pageUrl,self.curUser.isLogin == YES?@"true":@"false",self.curUser.isLogin == YES?self.curUser.cardCode:@""]];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.pageUrl != nil) {
        self.navigationController.navigationBar.hidden = YES;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?isLogin=%@&cardCode=%@",self.pageUrl,self.curUser.isLogin == YES?@"true":@"false",self.curUser.isLogin == YES?self.curUser.cardCode:@""]];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr =[NSString stringWithFormat:@"%@", request.URL];
    if ([urlStr rangeOfString:@"/app/activity/index"].length > 0) {
        _btnBack.userInteractionEnabled = YES;
    }else{
        _btnBack.userInteractionEnabled = NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

-(void)goToLogin{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self needLogin];
    });
    
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

-(void)exchangeToast:(NSString *)msg{
    [self showPromptText:msg hideAfterDelay:1.7];
}

-(NSString *)getCardCode{
    if (self.curUser.isLogin == YES) {
        return self.curUser.cardCode;
    }else{
       [self needLogin];
        return @"";
    }
}

-(void)goCathectic:(NSString *)lotteryCode{ //跳转竟足  充值  优惠券
    if (lotteryCode == nil) {
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
        return;
    }


    if ([lotteryCode isEqualToString:@"YHQ"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MyCouponViewController *couponVC = [[MyCouponViewController alloc]init];
            couponVC.hidesBottomBarWhenPushed = YES;
            [self .navigationController pushViewController:couponVC animated:YES];
        });
        return;
    }
    
    if ([lotteryCode isEqualToString:@"CZ"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            TopUpsViewController *topUpsVC = [[TopUpsViewController alloc]init];
            topUpsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:topUpsVC animated:YES];
        });
        return;
    }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NSNotificationJumpToPlayVC" object:lotteryCode];
            [self.navigationController popToRootViewControllerAnimated:NO];
        });
    
}


-(void)SharingLinks:(NSString *)code{
    //    [self showPromptText:code hideAfterDelay:1.8];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self initshare:code];
    });
}

-(void)initshare:(NSString *)code{
    
    if (![code isEqualToString:@""]) {
        NSString *url = [NSString stringWithFormat:@"tfi.11max.com/Tbz/Share?shareCode=%@",code];
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        NSArray* imageArray = @[[[NSBundle mainBundle] pathForResource:@"logo120@2x" ofType:@"png"]];
        [shareParams SSDKSetupShareParamsByText:@"千万大奖集聚地，新用户即享188元豪礼。积分商城优惠享不停！"
                                         images:imageArray
                                            url:[NSURL URLWithString:url]
                                          title:@"送您188元新人大礼包！点击领取"
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
    }else{
        return;
    }
    
    
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

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


@end
