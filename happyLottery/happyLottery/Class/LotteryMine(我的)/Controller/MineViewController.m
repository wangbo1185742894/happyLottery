//
//  MineViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//  我的

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "UIImage+RandomSize.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "PersonnalCenterViewController.h"
#import "TopUpsViewController.h"
#import "WithdrawalsViewController.h"
#import "CashAndIntegrationWaterViewController.h"
#import "MyRedPacketViewController.h"
#import "MyCouponViewController.h"
#import "SystemSetViewController.h"
#import "NoticeCenterViewController.h"
#import "ShareViewController.h"
#import "FeedbackViewController.h"

@interface MineViewController () <UITableViewDelegate, UITableViewDataSource,MemberManagerDelegate>{
    NSArray *listArray;
    UIButton *noticeBtn;
    UILabel *label;
}
@property (weak, nonatomic) IBOutlet UIButton *personSetBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;//签到
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;//余额
@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;
@property (weak, nonatomic) IBOutlet UILabel *integralLab;//积分
@property (weak, nonatomic) IBOutlet UIButton *integralBtn;
@property (weak, nonatomic) IBOutlet UIButton *redPacketBtn;
@property (weak, nonatomic) IBOutlet UILabel *redPacketLab;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;//充值
@property (weak, nonatomic) IBOutlet UIButton *withdrawalsBtn;//提现

@property (weak, nonatomic) IBOutlet UITableView *tableview;


@property(strong, nonatomic) NSString * memberSubFunctionClass;
@end

@implementation MineViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (self.curUser.isLogin==YES) {
        [self updateMemberClinet];
    } else {
        //显示未登录时的状态
        [self notLogin];
    }
    self.memberMan.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllerNo = @"A201";
    self.memberMan.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionUserLoginSuccess:) name:NotificationNameUserLogin object:nil];
     listArray = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"Mine" ofType: @"plist"]];
    [_tableview registerClass:[MineTableViewCell class] forCellReuseIdentifier:@"MineTableViewCell"];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    [self noticeCenterSet];
    
    [_tableview reloadData];
}
//////
-(void)notLogin{
    [self.loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    self.loginBtn.enabled = YES;
}
-(void)updateMemberClinet{
    
    NSDictionary *MemberInfo;
    NSString *cardCode =self.curUser.cardCode;
    if (cardCode == nil) {
        return;
    }
    MemberInfo = @{@"cardCode":cardCode
                   };
    
    [self.memberMan getMemberByCardCodeSms:(NSDictionary *)MemberInfo];
}

-(void)gotisSignInToday:(NSString *)redPacketInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (success ) {
        if ([redPacketInfo boolValue] == NO) { // 未签
            self.signInBtn.enabled = YES;
        }else{
            self.signInBtn.enabled = NO;
        }
    }
}

-(void)actionUserLoginSuccess:(NSNotification *)notification{
    
    [self loadUserInfo];
}


//-(void)saveUserInfo{
//
//    if ([self.fmdb open]) {
//        User *user = [GlobalInstance instance].curUser;
//        FMResultSet*  result = [self.fmdb executeQuery:@"select * from t_user_info"];
//        NSLog(@"%@",result);
//        BOOL issuccess = NO;
//        NSInteger payVerifyType = 1;
//        do {
//            NSString *mobile = [result stringForColumn:@"mobile"];
//
//            if ([mobile isEqualToString: self.curUser.mobile]) {
//                payVerifyType = [[result stringForColumn:@"payVerifyType"] integerValue];
//                issuccess= [self.fmdb executeUpdate:@"delete from t_user_info where mobile = ? ",mobile];
//
//            }else{
//                issuccess= [self.fmdb executeUpdate:@"delete from t_user_info where mobile = ? ",mobile];
//            }
//
//        } while ([result next]);
//
//        [self.fmdb executeUpdate:@"insert into t_user_info (cardCode , loginPwd , isLogin , mobile , payVerifyType) values ( ?,?,?,?,?)  ",user.cardCode,user.loginPwd,@"1",user.mobile,[NSString stringWithFormat:@"%ld",payVerifyType]];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameUserLogin object:nil];
//        [result close];
//        [self.fmdb close];
//    }
//}

-(void)getMemberByCardCodeSms:(NSDictionary *)memberInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    NSLog(@"memberInfo%@",memberInfo);
    if ([msg isEqualToString:@"执行成功"]) {
      // [self showPromptText: @"memberInfo成功" hideAfterDelay: 1.7];
        User *user = [[User alloc]initWith:memberInfo];
        [GlobalInstance instance].curUser = user;
        [GlobalInstance instance].curUser.isLogin = YES;
//        [self saveUserInfo];
        [self loadUserInfo];
        [self.memberMan isSignInToday:@{@"cardCode":self.curUser.cardCode}];
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

-(void)loadUserInfo{
  
    NSString *userName;
    if (self.curUser.nickname.length == 0) {
        userName = self.curUser.mobile;
    }else{
        userName = self.curUser.nickname;
    }
    [self.loginBtn setTitle:userName forState:UIControlStateNormal];
    self.loginBtn.enabled = NO;
  
    self.curUser.payVerifyType = [NSNumber numberWithInt:1];
    
    //[_userImage sd_setImageWithURL:[NSURL URLWithString:self.curUser.headUrl]];
    long long balance = [self.curUser.balance longLongValue];
    long long notCash = [self.curUser.notCash longLongValue];
    long long sendBalance = [self.curUser.sendBalance longLongValue];
    long long total = balance+notCash+sendBalance;
    NSString *totalstr = [NSString stringWithFormat:@"%lld",total];
    self.balanceLab.text = totalstr;
    int score =  [self.curUser.score intValue];
    NSString *scorestr = [NSString stringWithFormat:@"%d",score];
    self.integralLab.text = scorestr;
    int couponCount = [self.curUser.couponCount intValue];
    NSString *couponCountstr = [NSString stringWithFormat:@"%d",couponCount];
    self.redPacketLab.text = couponCountstr;
    self.userImage.layer.cornerRadius = 29;
    self.userImage.layer.masksToBounds = YES;
    if ([self.curUser.headUrl isEqualToString:@""]) {
        self.userImage.image = [UIImage imageNamed:@"usermine.png"];
    }else{
        
        self.userImage.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.curUser.headUrl]]];
    }
}

//- (void) Login{
//
//    LoginViewController * loginVC = [[LoginViewController alloc]init];
//    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController: loginVC];
//    navVC.navigationBar.barTintColor = SystemGreen;
//
//    navVC.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:18]};
//    navVC.navigationBar.tintColor = [UIColor whiteColor];
//    [self presentViewController:navVC animated:NO completion:nil];
//}

-(void)noticeCenterSet{
    noticeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    noticeBtn.frame = CGRectMake(0, 0, 35, 30);
    label = [[UILabel alloc]init];
    label.frame =CGRectMake(25, 0,10, 10);
    label.layer.cornerRadius = label.bounds.size.width/2;
    label.layer.masksToBounds = YES;
    label.text = @"2";
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor whiteColor];
    [noticeBtn addSubview:label];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: noticeBtn];
    //[noticeBtn setTitle:@"发起合买" forState:UIControlStateNormal];
    [noticeBtn setImage:[UIImage imageNamed:@"news@2x.png"] forState:UIControlStateNormal];
    [noticeBtn addTarget: self action: @selector(noticeBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

-(void)noticeBtnClick{
    
     if (!self.curUser.isLogin){
        [self needLogin];
    } else {
        NoticeCenterViewController * nVC = [[NoticeCenterViewController alloc]init];
        nVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nVC animated:YES];
    }
}

- (IBAction)personSetClick:(id)sender {
   if (!self.curUser.isLogin){
        [self needLogin];
    } else {
        PersonnalCenterViewController * pcVC = [[PersonnalCenterViewController alloc]init];
        pcVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pcVC animated:YES];
    }

}

- (IBAction)loginBtnClick:(id)sender {
    [self needLogin];
}

- (IBAction)signInBtnClick:(id)sender {
    if (!self.curUser.isLogin) {
        [self needLogin];
    } else {
        [self.memberMan signIn:@{@"cardCode":self.curUser.cardCode,@"activityId":@"1"}];
    }
}

-(void)signInIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (success) {
        [self showPromptText:@"签到成功" hideAfterDelay:1.7];
        self.signInBtn.enabled = NO;
    }
}



- (IBAction)blanceBtnClick:(id)sender {
     if (!self.curUser.isLogin) {
        [self needLogin];
    } else {
        CashAndIntegrationWaterViewController * pcVC = [[CashAndIntegrationWaterViewController alloc]init];
        pcVC.select = 0;
        pcVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pcVC animated:YES];
    }
    
}
- (IBAction)integralBtnClick:(id)sender {
     if (!self.curUser.isLogin) {
        [self needLogin];
    } else {
        CashAndIntegrationWaterViewController * pcVC = [[CashAndIntegrationWaterViewController alloc]init];
        pcVC.select = 1;
        pcVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pcVC animated:YES];
    }
    
}
- (IBAction)redPacketBtnClick:(id)sender {
     if (!self.curUser.isLogin) {
        [self needLogin];
    } else {
        MyCouponViewController * mcVC = [[MyCouponViewController alloc]init];
        mcVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mcVC animated:YES];
    }
    
}
- (IBAction)rechargeBtnClick:(id)sender {
    if (!self.curUser.isLogin){
        [self needLogin];
    } else {
        TopUpsViewController *t = [[TopUpsViewController alloc]init];
        t.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:t animated:YES];
    }
 
}
- (IBAction)withdrawalsBtnClick:(id)sender {
     if (!self.curUser.isLogin) {
        [self notLogin];
    } else {
        WithdrawalsViewController *w = [[WithdrawalsViewController alloc]init];
        w.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:w animated:YES];
    }
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)registerUser:(NSDictionary *)userInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    NSLog(@"%@",userInfo);
}

#pragma UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* array = listArray[section];
    
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableiew heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self.tableView registerClass :[YourTableCell class] forCellReuseIdentifier:@"txTableCell"];
    static NSString *CellIdentifier = @"TabViewCell";
    //自定义cell类
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MineTableViewCell" owner:self options:nil] lastObject];
    }
    NSDictionary *optionDic = listArray[indexPath.section][indexPath.row];
    
    cell.image.image = [UIImage reSizeImageName:optionDic[@"icon"] andMinWidth:18];
    cell.lable.text = optionDic[@"title"];
    cell.lable.font = [UIFont systemFontOfSize:15];
    return cell;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    tableView.backgroundColor = [UIColor clearColor];
    NSString *sectionTitle;
    if ([self respondsToSelector:@selector(tableView)]) {
        sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    }else{
        sectionTitle = nil;
    }
    
    if (sectionTitle == nil) {
        UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)] ;
        [sectionView setBackgroundColor:[UIColor clearColor]];
        return  sectionView;
    }
    
    UILabel * label = [[UILabel alloc] init] ;
    label.frame = CGRectMake(15, 0, 320, 40);
    label.backgroundColor = [UIColor clearColor];
    label.font=[UIFont systemFontOfSize:15];
    label.text = sectionTitle;
    
    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)] ;
    [sectionView setBackgroundColor:[UIColor clearColor]];
    [sectionView addSubview:label];
    return sectionView;
}

#pragma UITableViewDelegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    if (!self.curUser.isLogin) {
       [self needLogin];
        return;
    }
    
    NSDictionary *optionDic = listArray[indexPath.section][indexPath.row];
    if (self.curUser.isLogin == NO) {
        [self needLogin];
    } else {
        if ([optionDic[@"title"] isEqualToString:@"我的红包"]){
            MyRedPacketViewController * mpVC = [[MyRedPacketViewController alloc]init];
            mpVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mpVC animated:YES];
        }else  if ([optionDic[@"title"] isEqualToString:@"设置"]){
            SystemSetViewController * mpVC = [[SystemSetViewController alloc]init];
            mpVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mpVC animated:YES];
        }else  if ([optionDic[@"title"] isEqualToString:@"邀请好友"]){
            ShareViewController * mpVC = [[ShareViewController alloc]init];
            mpVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mpVC animated:YES];
        }else  if ([optionDic[@"title"] isEqualToString:@"意见反馈"]){
            FeedbackViewController * mpVC = [[FeedbackViewController alloc]init];
            mpVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mpVC animated:YES];
        }else{
            self.memberSubFunctionClass = optionDic[@"actionClassName"];
            BaseViewController *vc = [[NSClassFromString(_memberSubFunctionClass) alloc] initWithNibName: _memberSubFunctionClass bundle: nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: vc animated: YES];
        }
    }
}

@end
