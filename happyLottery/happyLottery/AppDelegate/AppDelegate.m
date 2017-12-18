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
#define KEYAPPVERSION @"appVersion"
#define KEYCURAPPVERSION @"CFBundleShortVersionString"

@interface AppDelegate ()<NewFeatureViewDelegate,MemberManagerDelegate>
{
    UITabBarController *tabBarControllerMain;
    NSUserDefaults *defaults;
    NSString * lastVersion;//应用内保存的版本号
    NSString * curVersion; //当前版本号
    MemberManager *memberMan;
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
    [self setKeyWindow];
    
    [self setNewFeature];
    [self dataSave];
    [self autoLogin];
    return YES;
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
    NSLog(@"%@",userInfo);
    User *user = [[User alloc]initWith:userInfo];
    
    user.isLogin = YES;
    [GlobalInstance instance].curUser = user;
}

-(void)dataSave{
    

    if ([self .fmdb open]) {
        BOOL iscreate = [self.fmdb executeUpdate:@"create table if not exists t_user_info(id integer primary key, cardCode text, mobile text ,loginPwd text, isLogin text)"];
        if (iscreate) {
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


@end
