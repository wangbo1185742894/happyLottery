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
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <sys/utsname.h>
#import "LoginViewController.h"
#import "SetPayPWDViewController.h"
#import <WebKit/WebKit.h>





@interface BaseViewController ()<LisentNetStateDelegate>
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
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]]; //去掉导航栏 下面黑线线

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadVisit) name:@"NSNotificationUserLoginSuccess" object:nil];
        
    });
   
    
    self.view.mj_w = KscreenWidth;
    self.view.mj_h = KscreenHeight;
    self.memberMan = [[MemberManager alloc]init];
    self.lotteryMan = [[LotteryManager alloc]init];
    self.memberMan.netDelegate = self;
    self.lotteryMan.netDelegate = self;
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
     AppDelegate *delegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    delegate.curNavVC = self.navigationController;
    self.openDate = [NSDate date];
    [self afnReachabilityTest];

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
//                [self showPromptText:@"网络不可用" hideAfterDelay:1.8];
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.view endEditing:YES];
    });
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
        [self presentViewController:navVC animated:YES completion:nil];
}

-(void)needLoginCompletion:(void (^ __nullable)(void))completion{
    //登录成功后跳回
    LoginViewController * loginVC = [[LoginViewController alloc]init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController: loginVC];
    navVC.navigationBar.barTintColor = SystemGreen;
    
    navVC.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:18]};
    navVC.navigationBar.tintColor = [UIColor whiteColor];
    [self presentViewController:navVC animated:YES completion:completion];
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
            [self.fmdb open];
            [self.fmdb executeUpdate:@"update vcUserActiveInfo set visitCount = ?,visitTime = ? where vcNo = ?",@(visitCount + 1) ,@(visitTime + oldVisitTime),self.viewControllerNo];

        }else{
      
            [self.fmdb executeUpdate:@"insert into vcUserActiveInfo (vcNo,updateDate,visitCount,visitTime) values (?,?,?,?)",self.viewControllerNo,@"",@1,@(visitTime)];
            
        }
          [self.fmdb close];
    }
       
       
}

//{"code":"xxxxx", "visitCount":xxxxxx, "visitTime":xx, "source":"ios"}]
-(void)uploadVisit{
    if ([self.fmdb open]) {
        FMResultSet*  result = [self.fmdb executeQuery:@"select * from vcUserActiveInfo"];
        NSMutableArray *mVisitArray = [[NSMutableArray alloc]init];
        while ([result next]) {
            [mVisitArray addObject:@{@"code":[result stringForColumn:@"vcNo"] == nil?@"":[result stringForColumn:@"vcNo"],@"visitCount":@([result intForColumn:@"visitCount"]),@"visitTime":@([result intForColumn:@"visitTime"]),@"source":@"iOS",@"channelCode":CHANNEL_CODE}];
        }
        [self.memberMan saveVisit:mVisitArray];
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
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [self saveInfo];
    });
    
}

-(UIBarButtonItem *)creatBarItem:(NSString *)title icon:(NSString *)imgName andFrame:(CGRect)frame andAction:(SEL)action{
    UIButton *btnItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnItem addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btnItem.frame = frame;
    if (title != nil) {
        [btnItem setTitle:title forState:0];
    }
    
    if (imgName != nil) {
        [btnItem setImage:[UIImage imageNamed:imgName] forState:0];
    }
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:btnItem];
    return barItem;
}

-(void)actionTelMe{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://4006005558"]];
    });
}

- (BOOL)stringContainsEmoji:(NSString *)string {
    
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    return returnValue;
}

- (BOOL)isValidateName:(NSString *)name
{
    
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",REG_NICKNAME1_STR];
    
    return [namePredicate evaluateWithObject:name];
}

- (BOOL)isValidateRealName:(NSString *)name
{
    
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",REG_NICKNAME_STR];
    
    return [namePredicate evaluateWithObject:name];
}


/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
- (BOOL)hasEmoji:(NSString*)string
{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}
/**
 判断是不是九宫格
 @param string  输入的字符
 @return YES(是九宫格拼音键盘)
 */
-(BOOL)isNineKeyBoard:(NSString *)string
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}

-(void)upLoadClientInfo{
    //应用版本号
    NSString *versionStringPGY = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString * bindTime = [Utility timeStringFromFormat:@"yyyy-MM-dd" withDate:[NSDate date]];
    
    NSDictionary *clientInfo;
    @try {
        clientInfo = @{@"cardCode":@([self.curUser.cardCode integerValue]),
                       @"imeiId":@"0000000",
                       @"brand":@"apple",
                       @"model":deviceString,
                       @"phoneno":self.curUser.mobile==nil?@"":self.curUser.mobile,
                       @"appVersion":versionStringPGY,
                       @"subversion":[UIDevice currentDevice].systemVersion,
                       @"bindTime":bindTime,
                       @"mac":[self getMacAddress]
                       };
    } @catch (NSException *exception) {
        clientInfo = nil;
    } @finally {
        [self.memberMan upLoadClientInfo:clientInfo];
    }
}

- (NSString *)getMacAddress {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString
                           stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 5)];
    
    free(buf);
    
    return [outstring uppercaseString];
}


-(void)cleanWebviewCache{
    NSHTTPCookie *cookie;
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (cookie in [storage cookies])
        
    {
        
        [storage deleteCookie:cookie];
        
    }
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

-(void)forgetPayPwd{
    SetPayPWDViewController *spvc = [[SetPayPWDViewController alloc]init];
    spvc.titleStr = @"忘记支付密码";
    spvc.isForeget = YES;
    [self.navigationController pushViewController:spvc animated:YES];
}
-(void)netIsNotEnable{
    
}
-(void)serverIsNotConnect{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([self socketReachabilityTest]) {
            //            [self showPromptText:@"连接服务器成功" hideAfterDelay:1.8];
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showPromptText:@"连接服务器失败，请检查网络设置" hideAfterDelay:2];
                });
            });
        }
    });
    
}


@end
