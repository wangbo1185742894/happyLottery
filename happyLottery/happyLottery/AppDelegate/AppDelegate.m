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

#import <AudioToolbox/AudioToolbox.h>//添加推送声音lala
#import "DiscoverViewController.h"
#import "Notice.h"
#import "JumpWebViewController.h"
#import "LoginViewController.h"


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
}

@property(nonatomic,strong)FMDatabase* fmdb;
@end
static SystemSoundID shake_sound_male_id = 0;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self loadTabVC];
    NSString *doc=[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"userInfo.sqlite"];
    self.fmdb =[FMDatabase databaseWithPath:fileName];
  
    
    memberMan = [[MemberManager alloc]init];
    memberMan.delegate = self;
     _messageContents = [[NSMutableArray alloc] initWithCapacity:6];
    [self setKeyWindow];
    [self initJpush];
    [self setNewFeature];
    [self dataSave];
    [self autoLogin];
  
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
  //  NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"5dd3abce8e0e840e6158b8e1"
                          channel:@"App Store"
                 apsForProduction:0
            advertisingIdentifier:nil];
    //获取自定义消息推送内容
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];

    if (launchOptions) {
        NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
//        if (remoteNotification) {
//            NSLog(@"推送消息==== %@",remoteNotification);
//            //NSLog(@"尼玛的推送消息呢===%@",userInfo);
//            // 取得 APNs 标准信息内容，如果没需要可以不取
//            NSDictionary *aps = [remoteNotification valueForKey:@"aps"];
//            NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
//            NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
//            NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
//            // 取得自定义字段内容，userInfo就是后台返回的JSON数据，是一个字典
//            NSString *appCode =  [remoteNotification valueForKey:@"pageCode"];
//            //    [APService handleRemoteNotification:userInfo];
//            
//            
//       
//                [self goToYunshiWithInfo:appCode];
//          
//        }
        
    }

      [self initShareSDK];
    return YES;
}
-(void)initShareSDK{

     [ShareSDK registerActivePlatforms:@[
//                            @(SSDKPlatformTypeSinaWeibo),
                  @(SSDKPlatformSubTypeWechatSession),
                    @(SSDKPlatformSubTypeWechatTimeline)
                           // @(SSDKPlatformTypeWechat)
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
                    [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                                                                         appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
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
    BOOL isLogin = NO;
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
    //
    //
//    if ([self.fmdb open]) {
//        NSString *cardcode=[GlobalInstance instance ].curUser.cardCode;
//        if ([cardcode isEqualToString:@""]) {
//            cardcode = @"cardcode";
//        }
//
//        BOOL result =  [self.fmdb executeUpdate:[NSString stringWithFormat:@"insert into vcUserPushMsg (title,content, msgTime , cardcode  ,isread) values ('%@', '%@', '%@', '%@', '%@');",@"title",@"content",time,@"123",@"123"]];
//        if (result) {
//            [self.fmdb close];
//        }
//    }
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
        ;
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


- (void)applicationWillEnterForeground:(UIApplication *)application {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationapplicationWillEnterForeground" object:nil];
    [application setApplicationIconBadgeNumber:0];
   //清除角标
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
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
            [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
            [JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
            if (pageCodeNotice!=nil) {
                
                [self goToYunshiWithInfo:pageCodeNotice];
                
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
    } else {
        // Fallback on earlier versions
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
   
//    DRAW_MESSAGE("中奖消息"),
//    FORECAST_LOTTERY_MESSAGE("预测开奖消息"),
//    ACTIVITY_MESSAGE("活动消息"),
//    SYSTEM_MESSAGE("系统消息"),
//    COUPON_EXPIRATION_MESSAGE("优惠卷到期提醒");messageType
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

-(void)goToYunshiWithInfo:(NSString *)pageCode{
    NSString *keyStr = pageCode;
    
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
    if ([loginName isEqualToString:@"1"]) {
        vcName =@"LoginViewController";
         //return;
    }
 
    Class class = NSClassFromString(vcName);
    
    baseVC =[[class alloc] init];
    
//    if([keyStr isEqualToString:@"A401"]){
//      baseVC.hidesBottomBarWhenPushed = NO;
//
//    }else if([keyStr isEqualToString:@"A402"]){
//          baseVC.hidesBottomBarWhenPushed = NO;
//
//    }else if ([keyStr isEqualToString:@"A201"]){
//          baseVC.hidesBottomBarWhenPushed = NO;
//    }else if([keyStr isEqualToString:@"A000"]){
//        baseVC.hidesBottomBarWhenPushed = NO;
//
//    }else
       AppDelegate *delegate  = (AppDelegate*)[UIApplication sharedApplication].delegate;
      UITabBarController *tabBarController = (UITabBarController *)_window.rootViewController;
      delegate.curNavVC = (UINavigationController *)tabBarController.childViewControllers[tabBarController.selectedIndex];
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
    }{
          baseVC.hidesBottomBarWhenPushed = YES;
    }
    
 
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      
      
        [delegate.curNavVC pushViewController:baseVC animated:YES];
    });
//    return;
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
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
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    //    NSLog(@"%@",userInfo);
    if (userInfo) {
        NSLog(@"推送消息==== %@",userInfo);
        //NSLog(@"尼玛的推送消息呢===%@",userInfo);
        // 取得 APNs 标准信息内容，如果没需要可以不取
        NSDictionary *aps = [userInfo valueForKey:@"aps"];
        titleNotice = [aps valueForKey:@"content-available"];
        NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
        NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
        NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
        // 取得自定义字段内容，userInfo就是后台返回的JSON数据，是一个字典
       pageCodeNotice =  [userInfo valueForKey:@"pageCode"];
      linkUrlNotice=[userInfo valueForKey:@"linkUrl"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //
        NSString *time = [Utility timeStringFromFormat:@"yyyy-MM-dd HH:mm:ss" withDate:[NSDate date]];
     
 application.applicationIconBadgeNumber = 0;
    //判断应用是在前台还是后台
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        
//        //第一种情况前台运行
//        alert = [[UIAlertView alloc]initWithTitle:titleNotice message:content delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
//        alert.delegate = self;
//        [alert show];
//
    }else{
        
        //第二种情况后台挂起时
        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
        [JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
        if (pageCodeNotice!=nil) {
            
            [self goToYunshiWithInfo:pageCodeNotice];
            
        }
        if (linkUrlNotice!=nil) {
           
                    UITabBarController *tab = (UITabBarController *)_window.rootViewController;
            UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
            JumpWebViewController *jumpVC = [[JumpWebViewController alloc] initWithNibName:@"JumpWebViewController" bundle:nil];
            jumpVC.title = @"消息详情";
            jumpVC.URL = linkUrlNotice;
            jumpVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:jumpVC animated:YES];
//            AppDelegate *delegate  = (AppDelegate*)[UIApplication sharedApplication].delegate;

//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                UITabBarController *homebar = (UITabBarController *)_window.rootViewController;
//                delegate.curNavVC = (UINavigationController *)homebar.childViewControllers[homebar.selectedIndex];
//                [delegate.curNavVC pushViewController:jumpVC animated:YES];
//           });
            
        }
       
    }
    }
}

#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
        if ([btnTitle isEqualToString:@"取消"]) {
            [alert removeFromSuperview];
         }else if ([btnTitle isEqualToString:@"确定"] ) {
             if (![pageCodeNotice isEqualToString:@"(null)"]) {
                 
                 [self goToYunshiWithInfo:pageCodeNotice];
                 
             }
             if (![linkUrlNotice isEqualToString:@"(null)"]) {
                 JumpWebViewController *jumpVC = [[JumpWebViewController alloc] initWithNibName:@"JumpWebViewController" bundle:nil];
                 jumpVC.title = titleNotice;
                 jumpVC.URL = linkUrlNotice;
                 AppDelegate *delegate  = (AppDelegate*)[UIApplication sharedApplication].delegate;
                 
//                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     UITabBarController *homebar = (UITabBarController *)_window.rootViewController;
                     delegate.curNavVC = (UINavigationController *)homebar.childViewControllers[homebar.selectedIndex];
                     [delegate.curNavVC pushViewController:jumpVC animated:YES];
//                 });
             }
           
               }
}



//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//
//    // Required,For systems with less than or equal to iOS6
//    [JPUSHService handleRemoteNotification:userInfo];
//
//     application.applicationIconBadgeNumber = 0;
//    if (pageCodeNotice!=nil) {
//
//        [self goToYunshiWithInfo:pageCodeNotice];
//
//    }
//    if (linkUrlNotice!=nil) {
//
//        UITabBarController *tab = (UITabBarController *)_window.rootViewController;
//        UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
//        JumpWebViewController *jumpVC = [[JumpWebViewController alloc] initWithNibName:@"JumpWebViewController" bundle:nil];
//        jumpVC.title = @"消息详情";
//        jumpVC.URL = linkUrlNotice;
//        jumpVC.hidesBottomBarWhenPushed = YES;
//        [nav pushViewController:jumpVC animated:YES];
//
//
//    }
//
//}


- (void)showZhuihaoDetail:(NSString*) ordernumber{
    MyOrderListViewController * myOrderListVC = [[MyOrderListViewController alloc]init];
    myOrderListVC.hidesBottomBarWhenPushed = YES;
    AppDelegate *delegate  = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.curNavVC pushViewController:myOrderListVC animated:YES];
}



@end
