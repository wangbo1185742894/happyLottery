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

@interface WebViewController ()<UIWebViewDelegate,WebViewObjcDelegate,LotteryManagerDelegate>{
    JSContext *context;
    NSString *shareTitle;
    NSString *shareText;
}
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lotteryMan.delegate = self;
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
        if (_htmlName == nil) {
            [self.navigationController popToRootViewControllerAnimated:YES];
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

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self showLoadingText:@"正在加载"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoadingView];
    context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"appObj"] = [self getJumpHandler];
    context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
    };
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}


-(void)SharingLinks{
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

-(void)initshare:(NSString *)code{
    if (self.curUser.isLogin == NO) {
        [self needLogin];
        return;
    }
        NSString *url = [self .curUser getShareUrl];
        
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

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}



@end
