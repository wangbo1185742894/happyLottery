 //
//  AppDelegate.m
//  happyLottery
//
//  Created by 王博 on 2017/12/1.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "AppDelegate.h"
#import "MyRedPacketViewController.h"
#import "CashAndIntegrationWaterViewController.h"
#import "FollowDetailViewController.h"
#import "FASSchemeDetailViewController.h"
#import "CashInfoViewController.h"
#import "NewFeatureViewController.h"
#import "GroupNewViewController.h"
#import "UPPaymentControl.h"
#import <Bugly/Bugly.h>
#import "GroupViewController.h"
#import "WebCTZQHisViewController.h"
#import "RecommendPerViewController.h"
#import "MyPostSchemeViewController.h"
#import "DLTPlayViewController.h"
#import "CTZQPlayViewController.h"
#import "JCZQPlayViewController.h"
#import "WelComeViewController.h"
#import "AESUtility.h"
#import "MyNoticeViewController.h"
#import "MyAttendViewController.h"
#import "netWorkHelper.h"
#import "MyCircleViewController.h"
#import "ZhuiHaoInfoViewController.h"
#import "LotteryPlayViewController.h"
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
#define KEYCURAPPVERSION @"CFBundleVersion"

#define KTimeJumpAfter 0.3

#import <AudioToolbox/AudioToolbox.h>//添加推送声音lala
#import "DiscoverViewController.h"
#import "Notice.h"
#import "JumpWebViewController.h"
#import "LoginViewController.h"
#import "BaseViewController.h"
#import "HomeJumpViewController.h"
#import "AgentManager.h"
#import "FollowSendViewController.h"
#import "QYSDK.h"

@interface AppDelegate ()<NewFeatureViewDelegate,MemberManagerDelegate,JPUSHRegisterDelegate,VersionUpdatingPopViewDelegate,NetWorkingHelperDelegate,UITabBarControllerDelegate,AgentManagerDelegate,LotteryManagerDelegate>

{
    UITabBarController *tabBarControllerMain;
    NSUserDefaults *defaults;
    NSString * lastVersion;//应用内保存的版本号
    NSString * curVersion; //当前版本号
    MemberManager *memberMan;
    LotteryManager *lotteryMan;
    NSMutableArray *_messageContents;
    ZhuiHaoStopPushVIew *winPushView;
    NSString *strnim;
    UIAlertView *alert;
    NSString *pageCodeNotice;
    NSString *linkUrlNotice;
    NSString *titleNotice;
    BOOL isLogin ;
    UINavigationController *homeNavVC;
    UINavigationController *genTouNavVC;
    UINavigationController *gouCaiNavVC;
    UINavigationController *faXianNavVC;
    UINavigationController *memberNavVC;
    NSUInteger _lastSelectedIndex;
    
}

@property(nonatomic,strong)FMDatabase* fmdb;
@property (nonatomic,strong)AgentManager * agentMan;
@property (nonatomic,strong)WelComeViewController * welCom;
@end
static SystemSoundID shake_sound_male_id = 0;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

//    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
//    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"launchVC"];
//    UIImageView *imgv = (UIImageView *)[vc.view viewWithTag:909090];
//    if (IPHONE_X) {
//        imgv.backgroundColor = [UIColor redColor];
////        imgv.image = [UIImage imageNamed:@"launch_x"];
//    }else{
//        imgv.image = [UIImage imageNamed:@"launchImage"];
//    }
    
    [[QYSDK sharedSDK] registerAppId:@"1750ba8866ce4ff7252e04b31823a672" appName:@"投必中"];
    lotteryMan = [[LotteryManager alloc]init];
    lotteryMan.delegate = self;
    
    [self loadTabVC];
    self.welCom = [[WelComeViewController alloc]init];
    [GlobalInstance instance].lotteryUrl = WSServerURL;
#ifdef bate
 
#else
    [Bugly startWithAppId:@"c36c93659f"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *item = [[NSString alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:BaseUrl]] encoding:NSUTF8StringEncoding];

        if (item != nil && item.length > 0) {
            [GlobalInstance instance].lotteryUrl = [NSString stringWithFormat:@"%@%@",item,@"%@"];
        }else{
            [GlobalInstance instance].lotteryUrl = WSServerURL;
        }
    });
#endif


 
    tabBarControllerMain.delegate = self;
    _lastSelectedIndex = 0;
    _showGroup = NO;
     [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
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
    [[[QYSDK sharedSDK] conversationManager ] setDelegate:self];
    if ([[UIApplication sharedApplication]
         respondsToSelector:@selector(registerForRemoteNotifications)])
    {
        UIUserNotificationType types = UIRemoteNotificationTypeBadge
        | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert
        | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
    
    [self initJpush];
    [self setNewFeature];
    [self dataSave];
    [self autoLogin];


    NSString  *pushKey;
#ifdef APPSTORE
    pushKey = @"0b8f85bf5208bb5da4651334";
#else
    pushKey = @"5dd3abce8e0e840e6158b8e1";
#endif

    [JPUSHService setupWithOption:launchOptions appKey:pushKey
                          channel:@"App Store"
                 apsForProduction:0
            advertisingIdentifier:nil];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    
    [JPUSHService resetBadge];
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
            strnim =[userInfo valueForKey:@"nim"];
            linkUrlNotice=[userInfo valueForKey:@"linkUrl"];
            NSDictionary *aps = [userInfo valueForKey:@"aps"];
            NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
            [[UIApplication sharedApplication]setApplicationIconBadgeNumber:badge/2];
            [JPUSHService setBadge:badge/2];//清空JPush服务器中存储的badge值
            [self jpushStart];
        }
        
    }  
    
      [self initShareSDK];
    sleep(1.0);
    
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
#ifdef APPSTORE
                [appInfo SSDKSetupWeChatByAppId:@"wxa0ff0f5a5d94e563" appSecret:@"bad37187c37042cfa2134ce2e1872d40"];
#else
                 
                [appInfo SSDKSetupWeChatByAppId:@"wxe640eb18da420c3b" appSecret:@"6ad481ed34390f25f4c930befb0e4abb"];
#endif
                        
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
        BOOL resultSystemNoticeInfo = [self.fmdb executeUpdate:@"create table if not exists SystemNotice(id integer primary key autoincrement, title text,content text, msgTime text,cardcode text,isread text,type text, pagecode text,url text,noticeid text)"];
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
        if(IPHONE_X ){
            [lotteryMan getCommonSetValue:@{@"typeCode":@"boot_page",@"commonCode":@"second_url_x"}];
        }else{
            [lotteryMan getBootPageUrl];
        }
        
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.welCom.view];

    }else{
        [defaults setObject:curVersion forKey:KEYAPPVERSION];
        [defaults synchronize];
        [self showNewFeature];
    }
}

-(void)gotCommonSetValue:(NSString *)strUrl{
    [self gotBootPageUrl:strUrl];
}
-(void)gotBootPageUrl:(NSString *)strUrl{
    _window.rootViewController = tabBarControllerMain;
   
    if(strUrl == nil){
        self.welCom.view.alpha = 0;
        self.welCom.view.hidden = YES;
        return;
    }
    [self.welCom setImg:strUrl];
    MJWeakSelf;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.welCom.view.alpha = 0;
        weakSelf.welCom.view.hidden = YES;
    });
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
    homeNavVC = [self tabNavVCWithAttr: tabAttrs];
    
    tabAttrs[@"tabTitle"] = @"跟投";
    tabAttrs[@"title"] = @"";
    tabAttrs[@"itemNormal"] = @"quanzi_defealt";
    tabAttrs[@"itemSelected"] = @"quanzi_select";
    tabAttrs[@"rootVC"] = @"FollowSendViewController";
    genTouNavVC = [self tabNavVCWithAttr: tabAttrs];
    
    tabAttrs[@"tabTitle"] = @"圈子";
    tabAttrs[@"title"] = @"圈子";
    tabAttrs[@"itemNormal"] = @"quanzi_normal";
    tabAttrs[@"itemSelected"] = @"quanzi_secelcted";
    tabAttrs[@"rootVC"] = @"";
    gouCaiNavVC = [self tabNavVCWithAttr: tabAttrs];
    
    
    tabAttrs[@"tabTitle"] = @"发现";
    tabAttrs[@"title"] = @"发现";
    tabAttrs[@"itemNormal"] = @"faxian_defealt";
    tabAttrs[@"itemSelected"] = @"faxian_select";
    tabAttrs[@"rootVC"] = @"DiscoverViewController";
    faXianNavVC = [self tabNavVCWithAttr: tabAttrs];
    
    
    tabAttrs[@"tabTitle"] = @"我的";
    tabAttrs[@"title"] = @"";
    tabAttrs[@"itemNormal"] = @"wode_defealt";
    tabAttrs[@"itemSelected"] = @"wode_select";
    tabAttrs[@"rootVC"] = @"MineViewController";
    memberNavVC = [self tabNavVCWithAttr: tabAttrs];
    tabBarControllerMain = [[UITabBarController alloc] init];
  
    tabBarControllerMain.viewControllers = @[homeNavVC,genTouNavVC,gouCaiNavVC,faXianNavVC, memberNavVC];
    tabBarControllerMain.view.frame = CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height);
    
    tabBarControllerMain.tabBar.backgroundColor = RGBCOLOR(37, 38, 38);
    tabBarControllerMain.tabBar.barTintColor =  RGBCOLOR(37, 38, 38);
}

-(void)setNomalRootVC{
    [self loadTabVC];
    _window.rootViewController = tabBarControllerMain;
}

-(void)setAppstoreRootVC {
    NSMutableDictionary *tabAttrs = [NSMutableDictionary dictionaryWithCapacity: 3];
    tabAttrs[@"tabTitle"] = @"首页";
    tabAttrs[@"title"] = @"彩票";
    tabAttrs[@"itemNormal"] = @"home_defealt";
    tabAttrs[@"itemSelected"] = @"home_select";
    tabAttrs[@"rootVC"] = @"NewsViewController";
    homeNavVC = [self tabNavVCWithAttr: tabAttrs];
    tabAttrs[@"tabTitle"] = @"我的";
    tabAttrs[@"title"] = @"我的";
    tabAttrs[@"itemNormal"] = @"wode_defealt";
    tabAttrs[@"itemSelected"] = @"wode_select";
    tabAttrs[@"rootVC"] = @"MineViewController";
    memberNavVC = [self tabNavVCWithAttr: tabAttrs];
    tabBarControllerMain = [[UITabBarController alloc] init];
    
    tabBarControllerMain.viewControllers = @[homeNavVC,memberNavVC];
    _window.rootViewController = tabBarControllerMain;
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
//    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
//    [JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
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
    
    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
}

//实现注册APNs失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
//添加处理APNs通知回调方法
#pragma mark- JPUSHRegisterDelegate



- (void)RegisterPushMessageNotification:(QYPushMessageBlock)block{
    
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    strnim = userInfo[@"nim"];
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

- (void)onReceiveMessage:(QYMessageInfo *)message{
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        // 2.设置通知的必选参数
        // 设置通知显示的内容
        
        localNotification.alertBody =  message.text;
        localNotification.userInfo = @{@"nim":@"1"};
        // 设置通知的发送时间,单位秒
        //解锁滑动时的事件
        localNotification.alertAction = @"投必中";
        //收到通知时App icon的角标
        localNotification.applicationIconBadgeNumber = 1;
        //推送是带的声音提醒，设置默认的字段为UILocalNotificationDefaultSoundName
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        // 3.发送通知(🐽 : 根据项目需要使用)
        // 方式一: 根据通知的发送时间(fireDate)发送通知
        if (pageCodeNotice != nil) {
            return;
        }
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }

}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^__strong)(void))completionHandler {
    // Required
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
       if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
           pageCodeNotice =  [userInfo valueForKey:@"pageCode"];
           strnim =[userInfo valueForKey:@"nim"];
           linkUrlNotice=[userInfo valueForKey:@"linkUrl"];
           [self jpushStart];
        }
    } else {
    }

    completionHandler();  // 系统要求执行这个方法
}

-(void)jpushStart{
    if (strnim != nil) {
        
        [self goToYunshiWithInfo:pageCodeNotice];
       
    }
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

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    NSDictionary * userInfo = [notification userInfo];
    NSLog(@"推送消息==== %@",userInfo);
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extra = [userInfo valueForKey:@"extras"];
    
    NSString *pageCode =extra[@"pageCode"] ;
    NSString *linkUrl=extra[@"linkUrl"] ;

    NSString *time = [Utility timeStringFromFormat:@"yyyy-MM-dd HH:mm:ss" withDate:[NSDate date]];
    //    [APService handleRemoteNotification:userInfo];
    if ([self.fmdb open]) {
        NSString *cardcode=[GlobalInstance instance ].curUser.cardCode;
        if ([cardcode isEqualToString:@""]) {
            cardcode = @"cardcode";
        }
        if (title == nil || title.length == 0) {
            title = @"投必中";
        }
        BOOL result =  [self.fmdb executeUpdate:[NSString stringWithFormat:@"insert into vcUserPushMsg (title,content, msgTime , cardcode  ,isread, pagecode ,url ) values ('%@', '%@', '%@', '%@', '%@', '%@', '%@');",title,content,time,cardcode,@"0",pageCode,linkUrl]];
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
        if ([extra[@"messageType"] isEqualToString:@"DRAW_MESSAGE"]) { //中奖推送
            
                if (winPushView !=nil) {
                    [winPushView removeFromSuperview];
                    winPushView = nil;
                }
                [self playSound];
                
                winPushView = [[ZhuiHaoStopPushVIew alloc]initWithFrame:[UIScreen  mainScreen].bounds];
                winPushView.pageCode = extra[@"pageCode"];
                [winPushView refreshInfo:title andContent:content];
                [[UIApplication sharedApplication].keyWindow addSubview:winPushView];
                return;
        }
        if ([extra[@"messageType"] isEqualToString:@"JOIN_AGENT"]) {
//            UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//            tabBarVC.selectedIndex = 2;
            return;
        }
    }
}
- (void)actionToRecommed:(NSString *)categoryCode {
     AppDelegate *delegate  = (AppDelegate*)[UIApplication sharedApplication].delegate;
    RecommendPerViewController *perVC = [[RecommendPerViewController alloc]init];
    perVC.hidesBottomBarWhenPushed = YES;
    perVC.navigationController.navigationBar.hidden = YES;
    perVC.categoryCode = categoryCode;
    [delegate.curNavVC pushViewController:perVC animated:YES];
}


-(void)jumpGenTouPage:(NSInteger)index{
    if (index == 0) {  // 牛人
        [self actionToRecommed:@"Cowman"];
    }else if (index == 1){  // 红人
        [self actionToRecommed:@"Redman"];
    }else if (index == 2){ // 红单
        [self actionToRecommed:@"RedScheme"];
    }else if (index == 3){  // 我的关注
        if ([GlobalInstance instance].curUser.isLogin == NO) {
            return;
        }
    
    }
}
-(void)goToYunshiWithInfo:(NSString *)pageCode{
    
    
    if (strnim != nil) {
         strnim = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            {
                
//                QYUserInfo *userInfo = [[QYUserInfo alloc] init];
//                userInfo.userId = [GlobalInstance instance].curUser.cardCode;
//
//
//                NSMutableArray *array = [NSMutableArray new];
//                NSMutableDictionary *dictRealName = [NSMutableDictionary new];
//                [dictRealName setObject:@"real_name" forKey:@"key"];
//                [dictRealName setObject:[GlobalInstance instance].curUser.cardCode forKey:@"value"];
//                [array addObject:dictRealName];
//
//
//                NSMutableDictionary *dictMobilePhone = [NSMutableDictionary new];
//                [dictMobilePhone setObject:@"mobile_phone" forKey:@"key"];
//                [dictMobilePhone setObject:[GlobalInstance instance].curUser.mobile forKey:@"value"];
//                [array addObject:dictMobilePhone];
//
//
//                NSMutableDictionary *dictEmail = [NSMutableDictionary new];
//                [dictEmail setObject:@"avatar" forKey:@"key"];
//                NSString *headurl;
//                if ([GlobalInstance instance].curUser.headUrl == nil) {
//                    headurl = @"";
//                }else{
//                    headurl = [GlobalInstance instance].curUser.headUrl;
//                }
//                [dictEmail setObject:headurl forKey:@"value"];
//                [array addObject:dictEmail];
//
//
//                NSData *data = [NSJSONSerialization dataWithJSONObject:array
//                                                               options:0
//                                                                 error:nil];
//                if (data)
//                {
//                    userInfo.data = [[NSString alloc] initWithData:data
//                                                          encoding:NSUTF8StringEncoding];
//                }
//
//                [[QYSDK sharedSDK] setUserInfo:userInfo];
                
                QYSource *source = [[QYSource alloc] init];
                source.title = @"投必中";
                QYSessionViewController *sessionViewController = [[QYSDK sharedSDK]
                                                                  sessionViewController];
                sessionViewController.sessionTitle = @"投必中"; sessionViewController.source = source; sessionViewController.hidesBottomBarWhenPushed = YES;
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage
                                                                             imageWithColor:[UIColor whiteColor]]];
                imageView.contentMode = UIViewContentModeScaleToFill;
                [[QYSDK sharedSDK] customUIConfig].sessionBackground = imageView;
                UITabBarController *tabVC = (UITabBarController*)[self.window rootViewController];
                
                UINavigationController *navVC = tabVC.viewControllers[tabVC.selectedIndex];
                for (UIViewController *vc in navVC.viewControllers) {
                    if ([vc isKindOfClass:[QYSessionViewController class]]) {
                        return ;
                    }
                }
                [navVC pushViewController:sessionViewController
                                 animated:YES];
                //
            }
        });
        return;
    }
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
        
        tabBarController.selectedIndex = 3;
        [ delegate.curNavVC  popToRootViewControllerAnimated:YES];
        return;
    }else if([keyStr isEqualToString:@"A402"]){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app setGroupView];
        });
      
//        [delegate.curNavVC popToRootViewControllerAnimated:YES];
        return;
    }else if ([keyStr isEqualToString:@"A201"]){
        
        tabBarController.selectedIndex = 4;
        [ delegate.curNavVC  popToRootViewControllerAnimated:YES];
        return;
    }else if([keyStr isEqualToString:@"A000"]){
        
        tabBarController.selectedIndex = 0;
        [ delegate.curNavVC  popToRootViewControllerAnimated:YES];
        return;
    }else if ([keyStr isEqualToString:@"A403"]){
        HomeJumpViewController *disVC = [[HomeJumpViewController alloc]init];
        ADSModel *model = [[ADSModel alloc]init];
        if ([GlobalInstance instance].curUser.isLogin== YES && [GlobalInstance instance].curUser.cardCode != nil) {
            model.linkUrl = [NSString stringWithFormat:@"%@/app/find/turntable?activityId=5&cardCode=%@",H5BaseAddress,[GlobalInstance instance].curUser.cardCode];
        }else{
            model.linkUrl = [NSString stringWithFormat:@"%@/app/find/turntable?activityId=5&cardCode=%@",H5BaseAddress,@""];
        }
        disVC.infoModel = model;
        disVC.hidesBottomBarWhenPushed = YES;
        disVC.isNeedBack = YES;
        baseVC = disVC;
        
    }else if ([keyStr isEqualToString:@"A414"]){
        WebCTZQHisViewController * playViewVC = [[WebCTZQHisViewController alloc]init];
        NSString *strUrl = [NSString stringWithFormat:@"%@/app/award/dltOpenAward",H5BaseAddress];
        playViewVC.pageUrl = [NSURL URLWithString:strUrl];
        playViewVC.hidesBottomBarWhenPushed = YES;
        [delegate.curNavVC pushViewController:playViewVC animated:YES];
        return;
    }else if ([keyStr isEqualToString:@"A415"]){
        WebCTZQHisViewController * playViewVC = [[WebCTZQHisViewController alloc]init];
        NSString *strUrl = [NSString stringWithFormat:@"%@/app/award/sfcOpenAward",H5BaseAddress];
        playViewVC.pageUrl = [NSURL URLWithString:strUrl];
        playViewVC.hidesBottomBarWhenPushed = YES;
        [delegate.curNavVC pushViewController:playViewVC animated:YES];
        return;
    }else if ([keyStr isEqualToString:@"A412"]){
        WebCTZQHisViewController * playViewVC = [[WebCTZQHisViewController alloc]init];
        NSString *strUrl = [NSString stringWithFormat:@"%@/app/award/jzOpenAward",H5BaseAddress];
        playViewVC.pageUrl = [NSURL URLWithString:strUrl];
        playViewVC.hidesBottomBarWhenPushed = YES;
        [delegate.curNavVC pushViewController:playViewVC animated:YES];
        return;
    }else if ([keyStr isEqualToString:@"A427"]){
        WebCTZQHisViewController * playViewVC = [[WebCTZQHisViewController alloc]init];
        NSString *strUrl = [NSString stringWithFormat:@"%@/app/award/toHis?lotteryCode=SD115",H5BaseAddress];
        playViewVC.pageUrl = [NSURL URLWithString:strUrl];
        playViewVC.hidesBottomBarWhenPushed = YES;
        [delegate.curNavVC pushViewController:playViewVC animated:YES];
        return;
        
    }else if ([keyStr isEqualToString:@"A311"]){
        WebCTZQHisViewController * playViewVC = [[WebCTZQHisViewController alloc]init];
        NSString *strUrl = [NSString stringWithFormat:@"%@/app/award/toHis?lotteryCode=SX115",H5BaseAddress];
        playViewVC.pageUrl = [NSURL URLWithString:strUrl];
        playViewVC.hidesBottomBarWhenPushed = YES;
        [delegate.curNavVC pushViewController:playViewVC animated:YES];
        return;
        
    } else if([keyStr isEqualToString:@"A416"]){
  
            tabBarController.selectedIndex = 1;
        return;
    }else if ([keyStr isEqualToString:@"A417"]){
        [self jumpGenTouPage:0];
        
        return;
    }else if ([keyStr isEqualToString:@"A418"]){
        [self jumpGenTouPage:1];
        
        return;
    }else if ([keyStr isEqualToString:@"A419"]){
        [self jumpGenTouPage:2];
        
        return;
    }else if ([keyStr isEqualToString:@"A420"]){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MyNoticeViewController *noticeVc = [[MyNoticeViewController alloc]init];
            noticeVc.hidesBottomBarWhenPushed = YES;
            noticeVc.curUser = [GlobalInstance instance].curUser;
            [delegate.curNavVC pushViewController:noticeVc animated:YES];
        });

        return;
    }else if ([keyStr isEqualToString:@"A422"]){
        
        MyPostSchemeViewController *revise = [[MyPostSchemeViewController alloc]init];
        revise.hidesBottomBarWhenPushed = YES;
        revise.isFaDan = NO;
        [delegate.curNavVC pushViewController:revise animated:YES];
        return;
    }else if ([keyStr isEqualToString:@"A424"]){
        
        MyPostSchemeViewController *revise = [[MyPostSchemeViewController alloc]init];
        revise.isFaDan = YES;
        revise.hidesBottomBarWhenPushed = YES;
        [delegate.curNavVC pushViewController:revise animated:YES];
        return;
    }else if ([keyStr isEqualToString:@"A423"]){
     
        MyAttendViewController *revise = [[MyAttendViewController alloc]init];
        [delegate.curNavVC pushViewController:revise animated:YES];
        return;
    }else if ([keyStr isEqualToString:@"A425"]){
//        MyCircleViewController * myCircleVC = [[MyCircleViewController alloc]init];
//        myCircleVC.hidesBottomBarWhenPushed = YES;
//        [delegate.curNavVC pushViewController:myCircleVC animated:YES];
//        UITabBarController *rootTab = (UITabBarController *)[UIApplication sharedApplication].keyWindow .rootViewController;
//        rootTab.selectedIndex  =2;
        return;
    }else if ([keyStr isEqualToString:@"A003"]){
        NSArray * lotteryDS = [lotteryMan getAllLottery];
        LotteryPlayViewController *playVC = [[LotteryPlayViewController alloc] init];
        playVC.hidesBottomBarWhenPushed = YES;
        playVC.lottery = lotteryDS[0];
        playVC.hidesBottomBarWhenPushed = YES;
        [delegate.curNavVC pushViewController:playVC animated:YES];
        return;
    }else if ([keyStr isEqualToString:@"A426"]){
        NSArray * lotteryDS = [lotteryMan getAllLottery];
        LotteryPlayViewController *playVC = [[LotteryPlayViewController alloc] init];
        playVC.hidesBottomBarWhenPushed = YES;
        playVC.lottery = lotteryDS[11];
        playVC.hidesBottomBarWhenPushed = YES;
        [delegate.curNavVC pushViewController:playVC animated:YES];
        return;
    }else if ([keyStr isEqualToString:@"A428"]){
        [self  jumpCashInfo:CashInfoGoucai ];
        return;
    }else if ([keyStr isEqualToString:@"A429"]){
        [self  jumpCashInfo:CashInfoChongzhi ];

        return;
    }else if ([keyStr isEqualToString:@"A430"]){
        [self  jumpCashInfo:CashInfoPaijiang ];

        return;
    }else if ([keyStr isEqualToString:@"A431"]){
        [self  jumpCashInfo:CashInfoTixian ];
    
        return;
    }else if ([keyStr isEqualToString:@"A432"]){
        [self  jumpCashInfo:CashInfoCaijin ];

        return;
    }else if ([keyStr isEqualToString:@"A433"]){
        [self  jumpCashInfo:CashInfoYongjin ];
   
        return;
    }else if ([keyStr isEqualToString:@"A434"]){
        [self  jumpCashInfo:CashInfoFanyong ];
        return;
    }else if ([keyStr isEqualToString:@"A436"]){
        [self  jumpCashInfo:CashInfoZhuihao ];
        return;
    }else if ([keyStr isEqualToString:@"A435"]){
        
        BaseViewController *base = delegate.curNavVC.viewControllers[0];
        if ([GlobalInstance instance].curUser.isLogin == NO) {
            [base needLogin];
            return;
        }
        CashAndIntegrationWaterViewController *cashInfoVC = [[CashAndIntegrationWaterViewController alloc]init];
        cashInfoVC.select = 1;
        cashInfoVC.hidesBottomBarWhenPushed = YES;
        [delegate.curNavVC pushViewController:cashInfoVC animated:YES];
        return;
    }else if ([keyStr isEqualToString:@"A437"]){
        BaseViewController *base = delegate.curNavVC.viewControllers[0];
        if ([GlobalInstance instance].curUser.isLogin == NO) {
            [base needLogin];
            return;
        }
        MyRedPacketViewController *redPacketVC  = [[MyRedPacketViewController alloc]init];
        [redPacketVC selectRedType:1];
        redPacketVC.hidesBottomBarWhenPushed = YES;
        [delegate.curNavVC pushViewController:redPacketVC animated:YES];
        return;
    }else{
          baseVC.hidesBottomBarWhenPushed = YES;
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KTimeJumpAfter * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [delegate.curNavVC pushViewController:baseVC animated:YES];
    });
}

-(void)jumpCashInfo:(CashInfoType)infoType{
    AppDelegate *delegate  = (AppDelegate*)[UIApplication sharedApplication].delegate;
    BaseViewController *base = delegate.curNavVC.viewControllers[0];
    if ([GlobalInstance instance].curUser.isLogin == NO) {
        [base needLogin];
        return;
    }
    CashInfoViewController *cashInfoVC = [[CashInfoViewController alloc]init];
    [cashInfoVC setMenuOffset:infoType];
    [delegate.curNavVC pushViewController:cashInfoVC animated:YES];
    return;
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
        strnim =[userInfo valueForKey:@"nim"];
      linkUrlNotice=[userInfo valueForKey:@"linkUrl"];
        [self  jpushStart];
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:badge/2];
    [JPUSHService setBadge:badge/2 ];//清空JPush服务器中存储的badge值
//         if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
//
//             if (pageCodeNotice!=nil) {
//

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
    
//    if (pageCodeNotice!=nil) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KTimeJumpAfter * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            [self goToYunshiWithInfo:pageCodeNotice];
//        });
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
//    }

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

- (void)showZhuihaoDetailWin:(NSString*) ordernumber{
    if ([GlobalInstance instance].curUser.isLogin == NO) {
        return;
    }
    
    ZhuiHaoInfoViewController * myOrderListVC = [[ZhuiHaoInfoViewController alloc]init];
    myOrderListVC.hidesBottomBarWhenPushed = YES;
    AppDelegate *delegate  = (AppDelegate*)[UIApplication sharedApplication].delegate;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KTimeJumpAfter * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [delegate.curNavVC pushViewController:myOrderListVC animated:YES];
    });
    
}

-(void)gotVueHttpUrl:(NSString *)baseUrl errorMsg:(NSString *)msg{
    if (baseUrl == nil || baseUrl.length == 0) {
        [GlobalInstance instance].homeUrl = ServerAddress;
    }else{
#ifdef bate
        [GlobalInstance instance].homeUrl = ServerAddress;
#else
        [GlobalInstance instance].homeUrl = baseUrl;
#endif
    }
}


- (void)setGroupView {
    if (self.agentMan == nil) {
        self.agentMan = [[AgentManager alloc]init];
    }
    self.agentMan.delegate = self;
    if ([GlobalInstance instance].curUser.cardCode == nil) {
        UITabBarController *tabBarController = (UITabBarController *)_window.rootViewController;
        tabBarController.selectedIndex = 2;
        return;
    }
    NSDictionary *dic = @{@"cardCode":[GlobalInstance instance].curUser.cardCode};
    [self.agentMan getAgentInfo:dic];
}

-(void )getAgentInfodelegate:(NSDictionary *)param isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (!success) {
        return;
    }
    NSString *agentStatus = [param objectForKey:@"agentStatus"];
    if (agentStatus == nil) { //申请成功
        //圈主or圈民
        UINavigationController  *baseNAVVC = tabBarControllerMain.viewControllers[2];
        BaseViewController *baseVC = (BaseViewController *)[baseNAVVC.childViewControllers firstObject];
        if ([baseVC isKindOfClass:[GroupNewViewController class]]) {
            gouCaiNavVC = [self groupDisplayNav:baseVC];
        }else{
            gouCaiNavVC = [self groupDisplayNav:nil];
        }
        gouCaiNavVC.hidesBottomBarWhenPushed = NO;
    }
    else {
       gouCaiNavVC = [self groupApplyNav];
        gouCaiNavVC.hidesBottomBarWhenPushed = YES;
    }
    tabBarControllerMain.viewControllers = @[homeNavVC,genTouNavVC,gouCaiNavVC,faXianNavVC, memberNavVC];
    tabBarControllerMain.selectedIndex = 2;
}

//切换到圈子页面，当前无登陆用户，跳转到登陆页面，否则调到圈子
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //切换至跟投页面刷新数据
    if (tabBarController.selectedIndex == 1) {
        UINavigationController  *baseNAVVC = tabBarControllerMain.viewControllers[1];
        FollowSendViewController *baseVC = (FollowSendViewController *)[baseNAVVC.childViewControllers firstObject];
        [baseVC refreshView];
    }
    if (tabBarController.selectedIndex == 2){
        //未登录
        User * curUser = [GlobalInstance instance].curUser;
        if (curUser.isLogin == NO) {
            
            AppDelegate *delegate  = (AppDelegate*)[UIApplication sharedApplication].delegate;
            tabBarController.selectedIndex = _lastSelectedIndex;
            BaseViewController *base = delegate.curNavVC.viewControllers[0];
            _showGroup = YES;
            [base needLogin];
            return;
        }
        [self setGroupView];
        
    }

    _showGroup = NO;
    _lastSelectedIndex = tabBarController.selectedIndex;
}

- (UINavigationController *)groupApplyNav{
    NSMutableDictionary *tabAttrs = [NSMutableDictionary dictionaryWithCapacity: 3];
    tabAttrs[@"tabTitle"] = @"圈子";
    tabAttrs[@"title"] = @"圈子";
    tabAttrs[@"itemNormal"] = @"quanzi_normal";
    tabAttrs[@"itemSelected"] = @"quanzi_secelcted";
    tabAttrs[@"rootVC"] = @"GroupViewController";
    return [self tabNavVCWithAttr: tabAttrs];
}

- (UINavigationController *)groupDisplayNav:(BaseViewController *)baseVC{
    NSMutableDictionary *tabAttrs = [NSMutableDictionary dictionaryWithCapacity: 3];
    tabAttrs[@"tabTitle"] = @"圈子";
    tabAttrs[@"itemNormal"] = @"quanzi_normal";
    tabAttrs[@"itemSelected"] = @"quanzi_secelcted";
    tabAttrs[@"rootVC"] = @"GroupNewViewController";
    UINavigationController *itemNav =[self tabNavVCWithAttr: tabAttrs];
    if (baseVC != nil) {
        itemNav.viewControllers = @[baseVC];
    }
    return itemNav;
}



- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *,id> *)options{
    NSString *strUrl = [NSString stringWithFormat:@"%@",url];
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:url.absoluteString];
    NSString *schemeNo;
    NSString *schemeType;
    NSString *onSell ;
    for (NSURLQueryItem *item in components.queryItems) {
        if ([item.name isEqualToString:@"schemeNo"]) {
            schemeNo = item.value;
        }
        if ([item.name isEqualToString:@"schemeType"]) {
            schemeType = item.value;
        }
        if ([item.name isEqualToString:@"onSell"]) {
            onSell = item.value;
        }
    }
    if (schemeNo.length == 0) {
        return YES;
    }
    MJWeakSelf;
    if ([strUrl rangeOfString:@"tbz"].length >0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                BaseViewController *baseVC;
                if ([onSell boolValue] == YES) {
                    FollowDetailViewController *followDetailVC = [[FollowDetailViewController alloc]init];
                    followDetailVC.hidesBottomBarWhenPushed = YES;
                    followDetailVC.schemeNo = schemeNo;
                    baseVC = followDetailVC;
                }else{
                    FASSchemeDetailViewController *schemeDetailVC = [[FASSchemeDetailViewController alloc]init];
                    schemeDetailVC.schemeNo =  schemeNo;
                    schemeDetailVC.schemeType = schemeType;
                    schemeDetailVC.hidesBottomBarWhenPushed = YES;
                    schemeDetailVC.h5Init = YES;
                    baseVC = schemeDetailVC;
                }
               
                UITabBarController *tabBarController = (UITabBarController *)weakSelf. window.rootViewController;
                UINavigationController *nav = tabBarController .viewControllers[tabBarController.selectedIndex];
                [nav pushViewController:baseVC animated:YES];
            });
        return YES;
    }
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        
        //调用- (void)yinlanPayFinish:(NSString *)result
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPPaymentControlFinishNotification" object:code];
    }];
    
    return YES;
};

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{

    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPPaymentControlFinishNotification" object:code];
    }];
    return YES;
    
}

@end
