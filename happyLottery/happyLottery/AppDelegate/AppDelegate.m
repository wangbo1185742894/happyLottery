 //
//  AppDelegate.m
//  happyLottery
//
//  Created by 王博 on 2017/12/1.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "AppDelegate.h"
#import "NewFeatureViewController.h"
#import "AESUtility.h"
#import "netWorkHelper.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
#import "VersionUpdatingPopView.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDK/ShareSDK+Base.h>
//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

#import "ZhuiHaoStopPushVIew.h"

#import "MyOrderListViewController.h"

#define KEYAPPVERSION @"appVersion"
#define KEYCURAPPVERSION @"CFBundleShortVersionString"

#define KTimeJumpAfter 0.3

#import <AudioToolbox/AudioToolbox.h>//添加推送声音lala
#import "DiscoverViewController.h"
#import "Notice.h"
#import "JumpWebViewController.h"
#import "LoginViewController.h"
#import "BaseViewController.h"
#import "HomeJumpViewController.h"


@interface AppDelegate ()<NewFeatureViewDelegate,MemberManagerDelegate,JPUSHRegisterDelegate,VersionUpdatingPopViewDelegate,NetWorkingHelperDelegate>

{
    UITabBarController *tabBarControllerMain;
    NSUserDefaults *defaults;
    NSString * lastVersion;//应用内保存的版本号
    NSString * curVersion; //当前版本号
    MemberManager *memberMan;
    NSMutableArray *_messageContents;
    ZhuiHaoStopPushVIew *winPushView;
    UIAlertView *alert;
    NSString *pageCodeNotice;
    NSString *linkUrlNotice;
    NSString *titleNotice;
    BOOL isLogin ;
}

@property(nonatomic,strong)FMDatabase* fmdb;
@end
static SystemSoundID shake_sound_male_id = 0;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self loadTabVC];
    [[UITextField appearance]setTintColor:SystemGreen];
    
    [GlobalInstance instance].homeUrl = ServerAddress;
    NSString *doc=[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"userInfo.sqlite"];
    self.fmdb =[FMDatabase databaseWithPath:fileName];
  
    
    memberMan = [[MemberManager alloc]init];
    memberMan.delegate = self;
    [memberMan getVueHttpUrl];
     _messageContents = [[NSMutableArray alloc] initWithCapacity:6];
    [self setKeyWindow];
    [self initJpush];
    [self setNewFeature];
    [self dataSave];
    [self autoLogin];
 
    [JPUSHService setupWithOption:launchOptions appKey:@"5dd3abce8e0e840e6158b8e1"
                          channel:@"App Store"
                 apsForProduction:0
            advertisingIdentifier:nil];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
    if (launchOptions) {
        NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //清除角标
        [application cancelAllLocalNotifications];
    }

    if(!launchOptions)  
    {  
        NSLog(@"用户点击app启动");  
    }  
    else  
    {  
        NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];  
        //app 通过urlscheme启动  
        if (url) {  
            NSLog(@"app 通过urlscheme启动 url = %@",url);  
        }  
        UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];  
        //通过本地通知启动  
        if(localNotification)  
        {  
            NSLog(@"app 通过本地通知启动 localNotification = %@",localNotification);  
        }  
        NSDictionary *remoteCotificationDic = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];  
        //远程通知启动  
        if(remoteCotificationDic)  
        {
           NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            pageCodeNotice =  [userInfo valueForKey:@"pageCode"];
            linkUrlNotice=[userInfo valueForKey:@"linkUrl"];
            
        }  
        
    }  
    
      [self initShareSDK];
    sleep(1.5);
    
    return YES;
}
-(void)initShareSDK{

     [ShareSDK registerActivePlatforms:@[
                  @(SSDKPlatformSubTypeWechatSession),
                    @(SSDKPlatformSubTypeWechatTimeline)
                            ]
                        onImport:^(SSDKPlatformType platformType) {                                             
                        switch (platformType)
                        {
                            case SSDKPlatformTypeWechat:
                                                     [ShareSDKConnector connectWeChat:[WXApi class]];
                       // [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                            break;
                       
//                                                                      case SSDKPlatformTypeSinaWeibo:
//                                                                          [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                                                                   break;
                        default:
                        break;
                                        }
                                    }
                        onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                             
                        switch (platformType)
                        {
//                        case SSDKPlatformTypeSinaWeibo:
//                       // 设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                       [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
//                        appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                     redirectUri:@"http://www.sharesdk.cn"
//                         authType:SSDKAuthTypeBoth];
//                                                                   break;
                                
                case SSDKPlatformTypeWechat:
                    [appInfo SSDKSetupWeChatByAppId:@"wxe640eb18da420c3b"
                    appSecret:@"6ad481ed34390f25f4c930befb0e4abb"];
                    break;
                    default:
                    break;
                                }
                            }];
}

-(void)initJpush{
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
}

-(void)autoLogin{
    isLogin = NO;
    if ([self .fmdb open]) {
         FMResultSet*  result = [self.fmdb executeQuery:@"select * from t_user_info"];
        if ([result next] && [result stringForColumn:@"mobile"] != nil) {
            isLogin = [[result stringForColumn:@"isLogin"] boolValue];
            if (isLogin == NO) {
                return;
            }
            NSDictionary *loginInfo;
            @try {
                NSString *mobile = [result stringForColumn:@"mobile"];
                NSString *pwd = [result stringForColumn: @"loginPwd"];
                
                loginInfo = @{@"mobile":mobile,
                              @"pwd": [AESUtility encryptStr: pwd],
                              @"channelCode":CHANNEL_CODE
                              };
                
            } @catch (NSException *exception) {
                return;
            }
            [memberMan loginCurUser:loginInfo];
        }
    }
    [self.fmdb close];
}

-(void)loginUser:(NSDictionary *)userInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (success == YES) {
        NSLog(@"%@",userInfo);
        User *user = [[User alloc]initWith:userInfo];
        
        user.isLogin = YES;
        
        [GlobalInstance instance].curUser = user;
    }else{
        User *user = [[User alloc]initWith:userInfo];
        [GlobalInstance instance].curUser = user;
        user.isLogin = NO;
    }
    
}

-(void)dataSave{
    

    if ([self .fmdb open]) {
        BOOL iscreate = [self.fmdb executeUpdate:@"create table if not exists t_user_info(id integer primary key, cardCode text, mobile text ,loginPwd text, isLogin text,payVerifyType text)"];
        BOOL resultVC = [self.fmdb executeUpdate:@"create table if not exists vcUserActiveInfo(id integer primary key autoincrement, vcNo text,updateDate text, visitCount integer , visitTime integer)"];
        BOOL resultMsgInfo = [self.fmdb executeUpdate:@"create table if not exists vcUserPushMsg(id integer primary key autoincrement, title text,content text, msgTime text,cardcode text,isread text, pagecode text,url text)"];
        BOOL resultSystemNoticeInfo = [self.fmdb executeUpdate:@"create table if not exists SystemNotice(id integer primary key autoincrement, title text,content text, msgTime text,cardcode text,isread text,type text, pagecode text,url text)"];
        if (iscreate && resultVC && resultMsgInfo && resultSystemNoticeInfo) {
            [self.fmdb close];
        }
    }
    
    NSString *time = [Utility timeStringFromFormat:@"yyyy-MM-dd HH:mm:ss" withDate:[NSDate date]];

}

-(void)setKeyWindow{
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [_window makeKeyAndVisible];
    _window.backgroundColor = [UIColor whiteColor];
    defaults = [NSUserDefaults standardUserDefaults];
    
}

-(void)setNewFeature{
    
    lastVersion = [defaults objectForKey:KEYAPPVERSION];
    curVersion = [NSBundle mainBundle].infoDictionary[KEYCURAPPVERSION];
    if ([curVersion isEqualToString:lastVersion]) { //
        _window.rootViewController = tabBarControllerMain;
    }else{
        [defaults setObject:curVersion forKey:KEYAPPVERSION];
        [defaults synchronize];
        [self showNewFeature];
    }
}

-(void)newFeatureSetRootVC{
    _window.rootViewController = tabBarControllerMain;

}

-(void)showNewFeature{
    NewFeatureViewController * newFeatureVC = [[NewFeatureViewController alloc]init];
    newFeatureVC.delegate = self;
    _window.rootViewController = newFeatureVC;
    
}

-(void) playSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"msg_come" ofType:@"mp3"];
    
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);
        //AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    NSString *myString =  [self.Dic objectForKey:@"MsgMusicSwitch"];
    if([myString isEqualToString:@"MsgMusicOpen"]){
        AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    }else{
    }
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}


- (void) loadTabVC {
    
    NSMutableDictionary *tabAttrs = [NSMutableDictionary dictionaryWithCapacity: 3];
    tabAttrs[@"tabTitle"] = @"首页";
    tabAttrs[@"title"] = @"彩票";
    tabAttrs[@"itemNormal"] = @"home_defealt";
    tabAttrs[@"itemSelected"] = @"home_select";
    tabAttrs[@"rootVC"] = @"BuyLotteryViewController";
    UINavigationController *homeNavVC = [self tabNavVCWithAttr: tabAttrs];
    
    tabAttrs[@"tabTitle"] = @"圈子";
    tabAttrs[@"title"] = @"圈子";
    tabAttrs[@"itemNormal"] = @"quanzi_defealt";
    tabAttrs[@"itemSelected"] = @"quanzi_select";
    tabAttrs[@"rootVC"] = @"GroupViewController";
    UINavigationController *gouCaiNavVC = [self tabNavVCWithAttr: tabAttrs];
    
    tabAttrs[@"tabTitle"] = @"发现";
    tabAttrs[@"title"] = @"发现";
    tabAttrs[@"itemNormal"] = @"faxian_defealt";
    tabAttrs[@"itemSelected"] = @"faxian_select";
    tabAttrs[@"rootVC"] = @"DiscoverViewController";
    UINavigationController *faXianNavVC = [self tabNavVCWithAttr: tabAttrs];
    
    
    tabAttrs[@"tabTitle"] = @"我的";
    tabAttrs[@"title"] = @"我的";
    tabAttrs[@"itemNormal"] = @"wode_defealt";
    tabAttrs[@"itemSelected"] = @"wode_select";
    tabAttrs[@"rootVC"] = @"MineViewController";
    UINavigationController *memberNavVC = [self tabNavVCWithAttr: tabAttrs];
    tabBarControllerMain = [[UITabBarController alloc] init];
    tabBarControllerMain.viewControllers = @[homeNavVC,gouCaiNavVC,faXianNavVC, memberNavVC];
    tabBarControllerMain.view.frame = CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height);
    
    
    tabBarControllerMain.tabBar.backgroundColor =  [UIColor blackColor];
    tabBarControllerMain.tabBar.barTintColor =  [UIColor blackColor];
    
}

- (UINavigationController *) tabNavVCWithAttr: (NSDictionary*) attrs {
    UIImage *normalImage = [[UIImage imageNamed: attrs[@"itemNormal"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed: attrs[@"itemSelected"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle: attrs[@"tabTitle"] image: normalImage selectedImage: selectedImage];
    NSDictionary *normalAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: SystemLightGray};
    [tabBarItem setTitleTextAttributes: normalAttributes forState:UIControlStateNormal];
    
    NSDictionary *selectedAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: SystemGreen};
    [tabBarItem setTitleTextAttributes: selectedAttributes forState:UIControlStateSelected];
    NSString *rootVCClassName = attrs[@"rootVC"];
    
    UIViewController *rootVC = [[NSClassFromString(rootVCClassName) alloc] initWithNibName: rootVCClassName bundle: nil];
    
    rootVC.title = attrs[@"title"];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController: rootVC];
    navVC.navigationBar.barTintColor = SystemGreen;
    navVC.tabBarItem = tabBarItem;
    
    
    navVC.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:18]};
    navVC.navigationBar.tintColor = [UIColor whiteColor];
    return navVC;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

//从后台点击icon进入时清除角标
- (void)applicationWillEnterForeground:(UIApplication *)application {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationapplicationWillEnterForeground" object:nil];
    [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}
//注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

//实现注册APNs失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
//添加处理APNs通知回调方法
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
          
        }
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionAlert);
     
    } else {
        // Fallback on earlier versions
    }   // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
   
   
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^__strong)(void))completionHandler {
    // Required
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
       if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
           pageCodeNotice =  [userInfo valueForKey:@"pageCode"];
           linkUrlNotice=[userInfo valueForKey:@"linkUrl"];
//            [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
//            [JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
           
//              if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive ||[UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
            if (pageCodeNotice!=nil) {
       
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KTimeJumpAfter * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self goToYunshiWithInfo:pageCodeNotice];
                });

            }
            if (linkUrlNotice!=nil) {

                UITabBarController *tab = (UITabBarController *)_window.rootViewController;
                UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
                JumpWebViewController *jumpVC = [[JumpWebViewController alloc] initWithNibName:@"JumpWebViewController" bundle:nil];
                jumpVC.title = @"消息详情";
                jumpVC.URL = linkUrlNotice;
                jumpVC.hidesBottomBarWhenPushed = YES;
                [nav pushViewController:jumpVC animated:YES];

            }
          //  }
        }
    } else {
    }

    completionHandler();  // 系统要求执行这个方法
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    NSDictionary * userInfo = [notification userInfo];
    NSLog(@"推送消息==== %@",userInfo);
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extra = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extra valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    NSString *pageCode =extra[@"pageCode"] ;
    NSString *linkUrl=extra[@"linkUrl"] ;
//
//
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //
    NSString *time = [Utility timeStringFromFormat:@"yyyy-MM-dd HH:mm:ss" withDate:[NSDate date]];
    //    [APService handleRemoteNotification:userInfo];
    if ([self.fmdb open]) {
        NSString *cardcode=[GlobalInstance instance ].curUser.cardCode;
        if ([cardcode isEqualToString:@""]) {
            cardcode = @"cardcode";
        }
        
        BOOL result =  [self.fmdb executeUpdate:[NSString stringWithFormat:@"insert into vcUserPushMsg (title,content, msgTime , cardcode  ,isread, pagecode ,url ) values ('%@', '%@', '%@', '%@', '%@', '%@', '%@');",title,content,time,cardcode,@"1",pageCode,linkUrl]];
        if (result) {
            [self.fmdb close];
        }
    }
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        //    DRAW_MESSAGE("中奖消息"),
        //    FORECAST_LOTTERY_MESSAGE("预测开奖消息"),
        //    ACTIVITY_MESSAGE("活动消息"),
        //    SYSTEM_MESSAGE("系统消息"),
        //    COUPON_EXPIRATION_MESSAGE("优惠卷到期提醒");messageType
//
        if ([extra[@"pageCode"] isEqualToString:@"A204"]&&[extra[@"messageType"] isEqualToString:@"DRAW_MESSAGE"]) { //中奖推送
            if (winPushView !=nil) {
                [winPushView removeFromSuperview];
                winPushView = nil;
            }
            [self playSound];
            
            winPushView = [[ZhuiHaoStopPushVIew alloc]initWithFrame:[UIScreen  mainScreen].bounds];
         
            [winPushView refreshInfo:title andContent:content];
            [[UIApplication sharedApplication].keyWindow addSubview:winPushView];
            return;
        }
    }

}

-(void)goToYunshiWithInfo:(NSString *)pageCode{
    NSString *keyStr = pageCode;
    pageCodeNotice = nil;
    if (keyStr == nil) {
        return;
    }
    BaseViewController *baseVC;
       NSDictionary * loginDic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"PageCodeIsLogin" ofType:@"plist"]];
    NSDictionary * vcDic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"pageCodeConfig" ofType:@"plist"]];
    if (keyStr == nil || [keyStr isEqualToString:@""]) {
        return;
    }
    NSString *vcName = vcDic[keyStr];
    if (vcName==nil) {
        return;
    }
        NSString *loginName = loginDic[keyStr];
    if ([GlobalInstance instance].curUser.isLogin==NO) {
        if ([loginName isEqualToString:@"1"]) {
            vcName =@"LoginViewController";
            //return;
        }
    }
  
 
    Class class = NSClassFromString(vcName);
    
    baseVC =[[class alloc] init];

       AppDelegate *delegate  = (AppDelegate*)[UIApplication sharedApplication].delegate;
      UITabBarController *tabBarController = (UITabBarController *)_window.rootViewController;
     tabBarController.selectedIndex = 0;
    if([keyStr isEqualToString:@"A401"]){
        
        tabBarController.selectedIndex = 2;
        [ delegate.curNavVC  popToRootViewControllerAnimated:YES];
        return;
    }else if([keyStr isEqualToString:@"A402"]){
        
       tabBarController.selectedIndex = 1;
        [ delegate.curNavVC  popToRootViewControllerAnimated:YES];
        return;
    }else if ([keyStr isEqualToString:@"A201"]){
        
        tabBarController.selectedIndex = 3;
        [ delegate.curNavVC  popToRootViewControllerAnimated:YES];
        return;
    }else if([keyStr isEqualToString:@"A000"]){
        
        tabBarController.selectedIndex = 0;
        [ delegate.curNavVC  popToRootViewControllerAnimated:YES];
        return;
    }else if ([keyStr isEqualToString:@"A403"]){
        
        if ([GlobalInstance instance].curUser.isLogin== YES || [GlobalInstance instance].curUser.cardCode != nil) {
            HomeJumpViewController *disVC = [[HomeJumpViewController alloc]init];
            ADSModel *model = [[ADSModel alloc]init];
            model.linkUrl = [NSString stringWithFormat:@"%@/app/find/turntable?activityId=5&cardCode=%@",H5BaseAddress,[GlobalInstance instance].curUser.cardCode];
            disVC.infoModel = model;
            disVC.hidesBottomBarWhenPushed = YES;
            disVC.isNeedBack = YES;
            baseVC = disVC;
        }
    }else{
          baseVC.hidesBottomBarWhenPushed = YES;
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KTimeJumpAfter * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [delegate.curNavVC pushViewController:baseVC animated:YES];
    });
}

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    //    NSLog(@"%@",userInfo);
    if (userInfo) {
        NSLog(@"推送消息==== %@",userInfo);
        //NSLog(@"尼玛的推送消息呢===%@",userInfo);
        // 取得 APNs 标准信息内容，如果没需要可以不取
        NSDictionary *aps = [userInfo valueForKey:@"aps"];
        titleNotice = [aps valueForKey:@"content-available"];
    
        NSInteger badge = [[aps valueForKey:@"badge"] integerValue];

        // 取得自定义字段内容，userInfo就是后台返回的JSON数据，是一个字典
       pageCodeNotice =  [userInfo valueForKey:@"pageCode"];
      linkUrlNotice=[userInfo valueForKey:@"linkUrl"];
 
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:badge/2];
        //    [JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
//         if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
//
//             if (pageCodeNotice!=nil) {
//
//                 [self goToYunshiWithInfo:pageCodeNotice];
//
//             }
//             if (linkUrlNotice!=nil) {
//
//                 UITabBarController *tab = (UITabBarController *)_window.rootViewController;
//                 UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
//                 JumpWebViewController *jumpVC = [[JumpWebViewController alloc] initWithNibName:@"JumpWebViewController" bundle:nil];
//                 jumpVC.title = @"消息详情";
//                 jumpVC.URL = linkUrlNotice;
//                 jumpVC.hidesBottomBarWhenPushed = YES;
//                 [nav pushViewController:jumpVC animated:YES];
//
//
//             }
//         }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    if (pageCodeNotice!=nil) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KTimeJumpAfter * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self goToYunshiWithInfo:pageCodeNotice];
        });
    }
    if (linkUrlNotice!=nil) {
        
        UITabBarController *tab = (UITabBarController *)_window.rootViewController;
        UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
        JumpWebViewController *jumpVC = [[JumpWebViewController alloc] initWithNibName:@"JumpWebViewController" bundle:nil];
        jumpVC.title = @"消息详情";
        jumpVC.URL = linkUrlNotice;
        jumpVC.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:jumpVC animated:YES];
    }

}



- (void)showZhuihaoDetail:(NSString*) ordernumber{
    if ([GlobalInstance instance].curUser.isLogin == NO) {
        return;
    }
    
    MyOrderListViewController * myOrderListVC = [[MyOrderListViewController alloc]init];
    myOrderListVC.hidesBottomBarWhenPushed = YES;
    AppDelegate *delegate  = (AppDelegate*)[UIApplication sharedApplication].delegate;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KTimeJumpAfter * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     [delegate.curNavVC pushViewController:myOrderListVC animated:YES];
    });
   
}

-(void)gotVueHttpUrl:(NSString *)baseUrl errorMsg:(NSString *)msg{
    if (baseUrl == nil || baseUrl.length == YES) {
        [GlobalInstance instance].homeUrl = ServerAddress;
    }else{
        [GlobalInstance instance].homeUrl = baseUrl;
    }
}


@end
