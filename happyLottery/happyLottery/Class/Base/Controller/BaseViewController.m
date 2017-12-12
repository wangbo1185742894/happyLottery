//
//  BaseViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/1.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"
#import <arpa/inet.h>
#import <netdb.h>



@interface BaseViewController ()
{
    MBProgressHUD *loadingView;
    UIView *loadingParentView;
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self setNavigationBack];
    
}

-(void)setNavigationBack{
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed: @"newBack"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(navigationBackToLastPage)];
    if (self.navigationController.viewControllers.count == 1) {
    }else{
        self.navigationItem.leftBarButtonItem = backBarButton;
    }
    
}
-(void)navigationBackToLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(BOOL)isIphoneX{
    return [Utility isIphoneX];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self afnReachabilityTest];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([self socketReachabilityTest]) {
            [self showPromptText:@"连接服务器成功" hideAfterDelay:1.8];
        }else{
            [self showPromptText:@"服务器连接失败" hideAfterDelay:1.8];
            
        }
    });
    
}
//判断服务器是否可达
- (BOOL)socketReachabilityTest {
    
    int socketNumber = socket(AF_INET, SOCK_STREAM, 0);
    
    struct sockaddr_in serverAddress;
    
    serverAddress.sin_family = AF_INET;
    
    serverAddress.sin_addr.s_addr = inet_addr("202.108.22.5");
    
    serverAddress.sin_port = htons(80);
    if (connect(socketNumber, (const struct sockaddr *)&serverAddress, sizeof(serverAddress)) == 0) {
        close(socketNumber);
        return true;
    }
    close(socketNumber);;
    return false;
}

//判断网络状态
- (void)afnReachabilityTest {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                [self showPromptText:@"网络不可用" hideAfterDelay:1.8];
                NSLog(@"AFNetworkReachability Not Reachable");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [self showPromptText:@"WWAN" hideAfterDelay:1.8];
                NSLog(@"AFNetworkReachability Reachable via WWAN");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [self showPromptText:@"WiFi" hideAfterDelay:1.8];
                NSLog(@"AFNetworkReachability Reachable via WiFi");
                break;
            case AFNetworkReachabilityStatusUnknown:
            default:
                [self showPromptText:@"Unknown" hideAfterDelay:1.8];
                NSLog(@"AFNetworkReachability Unknown");
                break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showLoadingViewWithText: (NSString *) text
                  withDetailText: (NSString *) sText {
    [self showLoadingViewWithText: text
                   withDetailText: sText
                         autoHide: 0];
}

- (void) showLoadingText: (NSString *) text {
    if (text != nil) {
        [self showLoadingViewWithText: text];
    } else {
        [self hideLoadingView];
    }
}

- (void) showLoadingViewWithText: (NSString *) text
                  withDetailText: (NSString *) sText
                        autoHide: (NSTimeInterval) interval {
    if (nil != loadingView) {
        [loadingView hide: YES];
    }
    
    if (loadingParentView == nil) {
        loadingParentView = self.navigationController.view;
        if (loadingParentView == nil) {
            loadingParentView = self.view;
        }
    }
    loadingView = [[MBProgressHUD alloc] initWithView: loadingParentView];
    //    loadingView.delegate = self;
    //loadingParentView.userInteractionEnabled = YES;
    
    // Add HUD to screen
    [loadingParentView addSubview: loadingView];
    
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    //loadingView.delegate = self;
    
    loadingView.labelText = text;
    if (sText != nil) {
        loadingView.detailsLabelText = sText;
    }
    [loadingView show: YES];
    if(interval > 0) {
        [loadingView hide: YES afterDelay: interval];
    }
    self.view.userInteractionEnabled = YES;
}

- (void) showLoadingViewWithText: (NSString *) text {
    [self showLoadingViewWithText: text
                   withDetailText: nil];
}

- (void) showPromptText: (NSString *) text {
    [self showPromptText: text hideAfterDelay: 0];
}

- (void) showPromptText: (NSString *) text hideAfterDelay: (NSTimeInterval) interval {
    
    //当提示出现时，屏幕键盘收起，不会挡住提示。
    
    [self.view endEditing:YES];
    if (nil != loadingView) {
        [loadingView hide: YES];
    }
    
    if (loadingParentView == nil) {
        loadingParentView = self.navigationController.view;
        if (loadingParentView == nil) {
            loadingParentView = self.view;
        }
    }
    loadingView = [[MBProgressHUD alloc] initWithView: loadingParentView];
    [self.view addSubview: loadingView];
    loadingView.labelText = text;
    //zwl 修改字体大小
    loadingView.labelFont = [UIFont systemFontOfSize:13];
    
    //当提示字符显示的时候可以点击 屏幕 其他元素。
    loadingView.userInteractionEnabled = NO;
    loadingView.mode = MBProgressHUDModeText;
    //make it on the bottom of screen, 49px from bottom
    
    loadingView.yOffset = loadingParentView.frame.size.height/2 - 160;
    //    loadingView.xOffset = 100.0f;
    
    if (interval > 0) {
        [loadingView showAnimated:YES whileExecutingBlock:^{
            sleep(interval);
        } completionBlock:^{
            [loadingView removeFromSuperview];
            loadingView = nil;
        }];
    } else {
        [loadingView show: YES];
    }
}

- (void) hidePromptText {
    [self hideLoadingView];
    
}
- (void) hideLoadingView {
    if (loadingView != nil) {
        [loadingView hide: YES];
    }
}


@end
