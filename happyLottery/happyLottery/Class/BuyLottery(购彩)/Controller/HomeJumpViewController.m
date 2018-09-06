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
#import "JCZQPlayViewController.h"
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/NSMutableDictionary+SSDKShare.h>
#import <MOBFoundation/MOBFoundation.h>

@interface HomeJumpViewController ()<JSJumpDelegate,UIWebViewDelegate,MemberManagerDelegate,LotteryManagerDelegate>
{
    JSContext *context;
    NSString *shareTitle;
    NSString *shareText;
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
    self.memberMan.delegate = self;
    self.title = self.infoModel.title;
    [self showWeb];
    self.lotteryMan.delegate = self;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isNeedBack) {
        
        self .navigationController.navigationBar.hidden = YES;
        if (self.curUser.isLogin == YES) {
            self.infoModel.linkUrl = [NSString stringWithFormat:@"%@/app/find/turntable?activityId=5&cardCode=%@",H5BaseAddress,[GlobalInstance instance].curUser.cardCode];
            [self showWeb];
        }
    }else{
        [self showWeb];
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
        if ([slinkUrl rangeOfString:@"app/activity/index"].length > 0) {
            if (self.curUser.cardCode != nil && self.isNeedBack == NO) {
                linkUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?cardCode=%@&isLogin=%@",slinkUrl,self.curUser.cardCode,self.curUser.isLogin == YES?@YES:@NO]];
            }else{
                linkUrl = [NSURL URLWithString:_infoModel.linkUrl];
            }
        }else{
            if (self.curUser.cardCode != nil && self.isNeedBack == NO) {
                linkUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?cardCode=%@&isLogin=%@",slinkUrl,self.curUser.cardCode,self.curUser.isLogin == YES?@YES:@NO]];
            }else{
                linkUrl = [NSURL URLWithString:_infoModel.linkUrl];
            }
        }

        
    }else{
        linkUrl = [NSURL URLWithString: [NSString stringWithFormat:@"%@?cardCode=%@&isLogin=%@",_infoModel.linkUrl,@"1",@NO]];
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

-(void)goCathectic:(NSString *)lotteryCode{ //跳转竟足  充值  优惠券
    if (lotteryCode == nil) {
        return;
    }
    if ([lotteryCode isEqualToString:@"JCZQ"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            JCZQPlayViewController * playViewVC = [[JCZQPlayViewController alloc]init];
            playViewVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:playViewVC animated:YES];
        });
    }
}

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

-(void)giveShareScore:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
        // [self showPromptText: @"积分赠送成功" hideAfterDelay: 1.7];
        
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
    
}
- (void)telPhone{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://4006005558"]];
    });
}

@end
