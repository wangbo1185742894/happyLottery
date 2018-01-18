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
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

#define KEYAPPVERSION @"appVersion"
#define KEYCURAPPVERSION @"CFBundleShortVersionString"

@interface AppDelegate ()<NewFeatureViewDelegate,MemberManagerDelegate,JPUSHRegisterDelegate>
{
    UITabBarController *tabBarControllerMain;
    NSUserDefaults *defaults;
    NSString * lastVersion;//应用内保存的版本号
    NSString * curVersion; //当前版本号
    MemberManager *memberMan;
    NSMutableArray *_messageContents;
}

@property(nonatomic,strong)FMDatabase* fmdb;
@end

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
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
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
    
    return YES;
}
-(void)initShareSDK{
    /**初始化ShareSDK应用
     
     @param activePlatforms
     
     使用的分享平台集合
     
     @param importHandler (onImport)
     
     导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作
     
     @param configurationHandler (onConfiguration)
     
     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
     
     */
    
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeWechat)
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
          
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
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
                loginInfo = nil;
            } @finally {
                [memberMan loginCurUser:loginInfo];
            }
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
        BOOL iscreateMatch = [self.fmdb executeUpdate:@"create table if not exists t_collect_match(id integer primary key, cardCode text,matchKey text)"];
        if (iscreate && iscreateMatch) {
            [self.fmdb close];
        }
    }
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

- (void) loadTabVC {
    
    NSMutableDictionary *tabAttrs = [NSMutableDictionary dictionaryWithCapacity: 3];
    tabAttrs[@"tabTitle"] = @"购彩";
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
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
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
    } // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
      NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extra = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extra valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *currentContent = [NSString
                                stringWithFormat:
                                @"收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\n",
                                [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                               dateStyle:NSDateFormatterNoStyle
                                                               timeStyle:NSDateFormatterMediumStyle],
                                title, content, [self logDic:extra]];
    NSLog(@"%@", currentContent);
    
    [_messageContents insertObject:currentContent atIndex:0];
    
    NSString *allContent = [NSString
                            stringWithFormat:@"%@收到消息:\n%@\nextra:%@",
                            [NSDateFormatter
                             localizedStringFromDate:[NSDate date]
                             dateStyle:NSDateFormatterNoStyle
                             timeStyle:NSDateFormatterMediumStyle],
                            [_messageContents componentsJoinedByString:nil],
                            [self logDic:extra]];
    
//    _messageContentView.text = allContent;
//    _messageCount++;
//    [self reloadMessageCountLabel];
//    
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
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

@end
