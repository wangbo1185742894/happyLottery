//
//  SystemSetViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/29.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "SystemSetViewController.h"
#import "AboutViewController.h"
#import "JPUSHService.h"
#import "netWorkHelper.h"
#import "VersionUpdatingPopView.h"
#import "AppDelegate.h"

@interface SystemSetViewController ()<NetWorkingHelperDelegate,VersionUpdatingPopViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UISwitch *switch2;
@property (weak, nonatomic) IBOutlet UIButton *aboutBtn;
@property (weak, nonatomic) IBOutlet UIButton *versionBtn;

@end

@implementation SystemSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#ifdef APPSTORE
    self.versionBtn.hidden = YES;
#else
    self.versionBtn.hidden = NO;
#endif
    self.viewControllerNo = @"A208";
    self.title = @"系统设置";
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
}

- (IBAction)switch2Click:(id)sender {
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (_switch2.on) {
        [myDelegate.Dic setObject:@"MsgMusicOpen" forKey:@"MsgMusicSwitch"];
         [myDelegate playSound];
    }else{
        [myDelegate.Dic setObject:@"MsgMusicOff" forKey:@"MsgMusicSwitch"];
    }
    
    [self saveNSUserDefaults:myDelegate.Dic];
   
}
- (IBAction)aboutBtnClick:(id)sender {
    AboutViewController *ab = [[AboutViewController alloc]init];
    [self.navigationController pushViewController:ab animated:YES];
}
- (IBAction)versionBtnClick:(id)sender {
    [self checkUpdateNetWork];
}

#pragma mark 将设置存储在本地
-(void)saveNSUserDefaults:(NSMutableDictionary *)Dictionary
{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(Dictionary.count)
    {
        [myDelegate.userDefaultes setObject:Dictionary forKey:@"MutableDict"];
        [myDelegate.userDefaultes synchronize];
    }
}


#pragma  mark - checkUpdateNetWork
- (void)checkUpdateNetWork {
    NSString *subversion = @"release";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    NSString *curVerSion = version;
    NSString * string = [NSString stringWithFormat:@"http://ct.11max.com//ClientVersion/CheckUpdate?versionCode=%@&mobileos=ios&appname=com.xaonly.tbz.ios&subversion=%@",curVerSion,subversion];
    netWorkHelper *helper = [[netWorkHelper alloc] init];
    [helper getRequestMethodWithUrlstring:string parameter:nil];
    helper.delegate = self;
}


#pragma mark - netWorkHelperDelegate
-(void)passValueWithDic:(NSDictionary *)value{
    if([value isKindOfClass:[NSDictionary class]])
    {
        if ([value[@"ForceUpgrade"] isEqualToString:@"true"]) {
            
            
            //            ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"更新提示" message:value[@"VersionDesc"]];
            //            [alert addBtnTitle:@"立即更新" action:^{
            //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPUPDATAURL]];
            //            }];
            //
            //            [alert showAlertWithSender:self];
            VersionUpdatingPopView *vuView = [[VersionUpdatingPopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            vuView.delegate = self;
            vuView.guanbibtn.userInteractionEnabled = NO;
            vuView.xiaochachaBtn.hidden = YES;
            vuView.content.text = value[@"VersionDesc"];
            [[UIApplication sharedApplication].keyWindow addSubview:vuView];
        }else
        {
            
            //            ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"更新提示" message:value[@"VersionDesc"]];
            //            [alert addBtnTitle:@"立即更新" action:^{
            //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPUPDATAURL]];
            //            }];
            //            [alert addBtnTitle:@"以后再说" action:^{
            //
            //            }];
            //
            //            [alert showAlertWithSender:self];
            VersionUpdatingPopView *vuView = [[VersionUpdatingPopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            vuView.delegate = self;
            vuView.content.text = value[@"VersionDesc"];
            [[UIApplication sharedApplication].keyWindow addSubview:vuView];
        }
    }
    else
    {
        [self showPromptText:@"当前版本为最新版本!" hideAfterDelay:1.7];
    }
}

- (void)lijigenxin{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPUPDATAURL]];
}
//退出登录
- (IBAction)quitBtnClick:(id)sender {
    self.curUser.isLogin = NO;
    [self updateLoginStatus];
     [JPUSHService setTags:nil alias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

-(void)updateLoginStatus{
    
    if ([self.fmdb open]) {
        NSString *mobile =self.curUser.mobile;
        NSString * isLogin =@"0";
        //update t_student set score = age where name = ‘jack’ ;
        [self.fmdb executeUpdate:@"update  t_user_info set isLogin = ? where mobile = ?",isLogin, mobile];
        [self.fmdb close];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
