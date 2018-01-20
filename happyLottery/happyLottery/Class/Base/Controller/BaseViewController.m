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
#import "AppDelegate.h"
#import "LoginViewController.h"



@interface BaseViewController ()
{
    MBProgressHUD *loadingView;
    UIView *loadingParentView;
}
@property(nonatomic,strong)NSDate *openDate;
@property(nonatomic,strong)NSDate *closeDate;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *delegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.curNavVC = self.navigationController;
    self.view.mj_w = KscreenWidth;
    self.view.mj_h = KscreenHeight;
    self.memberMan = [[MemberManager alloc]init];
    self.lotteryMan = [[LotteryManager alloc]init];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self setNavigationBack];
    NSString *doc=[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"userInfo.sqlite"];
    self.fmdb =[FMDatabase databaseWithPath:fileName];

}

-(User *)curUser{
    return [GlobalInstance instance ].curUser;
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
    [super viewWillAppear:animated];
    self.openDate = [NSDate date];
    [self afnReachabilityTest];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([self socketReachabilityTest]) {
//            [self showPromptText:@"连接服务器成功" hideAfterDelay:1.8];
        }else{

            dispatch_async(dispatch_get_main_queue(), ^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

//                        [self showPromptText:@"连接服务器失败，请检查网络设置" hideAfterDelay:1.8];
                    });
            });
        }
    });
    

}
//判断服务器是否可达
- (BOOL)socketReachabilityTest {
    
    int socketNumber = socket(AF_INET, SOCK_STREAM, 0);
    
    struct sockaddr_in serverAddress;
    
    serverAddress.sin_family = AF_INET;
    
    serverAddress.sin_addr.s_addr = inet_addr("124.89.85.110");
    
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
//                [self showPromptText:@"WWAN" hideAfterDelay:1.8];
//                NSLog(@"AFNetworkReachability Reachable via WWAN");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
//                [self showPromptText:@"WiFi" hideAfterDelay:1.8];
//                NSLog(@"AFNetworkReachability Reachable via WiFi");
                break;
            case AFNetworkReachabilityStatusUnknown:
            default:
//                [self showPromptText:@"Unknown" hideAfterDelay:1.8];
//                NSLog(@"AFNetworkReachability Unknown");
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
    if ([text isEqualToString:@""] ||text == nil ) {
        return;
    }
    if ([text isEqualToString:@"执行成功"] ) {
        text = @"数据请求成功";
    }
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

-(void)needLogin{
        //登录成功后跳回
        LoginViewController * loginVC = [[LoginViewController alloc]init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController: loginVC];
        navVC.navigationBar.barTintColor = SystemGreen;
        
        navVC.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:18]};
        navVC.navigationBar.tintColor = [UIColor whiteColor];
        [self presentViewController:navVC animated:NO completion:nil];
    
}

-(id)transFomatJson:(NSString *)strJson{
    if (strJson.length == 0 || strJson == nil) {
        return nil;
    }
    
    if ([Utility objFromJson:strJson] != nil) {
        return [Utility objFromJson:strJson];
    }
   
    strJson = [strJson stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    strJson = [strJson substringWithRange:NSMakeRange(1, strJson.length - 2)];
    return  [Utility objFromJson:strJson];
}

-(void)saveInfo{
    //@"create table if not exists vcUserActiveInfo(id integer primary key, vcNo text,updateDate text, visitCount integer , visitTime integer)"
    NSInteger visitTime = [self.closeDate timeIntervalSinceDate:self.openDate];
    if (self.viewControllerNo == nil || self.viewControllerNo.length == 0) {
        return;
    }
    if ([self.fmdb open]) {
        
        FMResultSet*  result = [self.fmdb executeQuery:@"select * from vcUserActiveInfo where vcNo = ?",self.viewControllerNo];
        NSLog(@"%@",result);
        BOOL issuccess = NO;
        if ([result next]) {
            NSInteger visitCount = 0;
            NSInteger oldVisitTime = 0;
            
            visitCount = [result intForColumn:@"visitCount"];
            oldVisitTime = [result intForColumn:@"visitTime"];
            
            issuccess= [self.fmdb executeUpdate:@"update vcUserActiveInfo set visitCount = ?,visitTime = ? where vcNo = ?",@(visitCount + 1) ,@(visitTime + oldVisitTime),self.viewControllerNo];
        }else{
            issuccess= [self.fmdb executeUpdate:@"insert into vcUserActiveInfo (vcNo,updateDate,visitCount,visitTime) values (?,?,?,?)",self.viewControllerNo,@"",@1,@(visitTime)];
        }
        [result close];
        [self.fmdb close];
    }
}

//{"code":"xxxxx", "visitCount":xxxxxx, "visitTime":xx, "source":"ios"}]
-(void)uploadVisit{
    if ([self.fmdb open]) {
        FMResultSet*  result = [self.fmdb executeQuery:@"select * from vcUserActiveInfo"];
        NSMutableArray *mVisitArray = [[NSMutableArray alloc]init];
        while ([result next]) {
            [mVisitArray addObject:@{@"code":[result stringForColumn:@"vcNo"] == nil?@"":[result stringForColumn:@"vcNo"],@"visitCount":@([result intForColumn:@"visitCount"]),@"visitTime":@([result intForColumn:@"visitTime"]),@"source":@"iOS"}];
        }
        //[self.memMan saveVisit:mVisitArray];
        [result close];
        [self.fmdb close];
    }
}

-(void)saveVisited:(BOOL)issuccess{
    
    if (issuccess == YES) {
        if ([self.fmdb open]) {
            FMResultSet*  result = [self.fmdb executeQuery:@"select * from vcUserActiveInfo"];
            while ([result next]) {
                [self.fmdb executeUpdate:@"delete from vcUserActiveInfo where vcNo = ?",[result stringForColumn:@"vcNo"]];
            }
            [result close];
            [self.fmdb close];
        }
    }
}

-(void)showAllInfo{
    FMResultSet*  result = [self.fmdb executeQuery:@"select * from vcUserActiveInfo"];
    while ([result next]) {
        NSLog(@"%@",[NSString stringWithFormat:@"*************%@页面---点击%d次---总共%d秒\n",[result stringForColumn:@"vcNo"],[result intForColumn:@"visitCount"],[result intForColumn:@"visitTime"]]);
    }
    [result close];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.closeDate = [NSDate date];
    [self saveInfo];
}

@end
