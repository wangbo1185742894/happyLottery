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
#import "Notice.h"
#import "RedPacket.h"
#import "FirstBankCardSetViewController.h"
#import "LoadData.h"
#import "Utility.h"

@interface MineViewController () <UITableViewDelegate, UITableViewDataSource,MemberManagerDelegate>{
    NSArray <NSArray *>*listArray;
    UIButton *noticeBtn;
    UILabel *label;
    long num;
    long rednum;
       NSMutableArray *listUseRedPacketArray;
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
@property(nonatomic,strong)  LoadData  *loadDataTool;
@end

@implementation MineViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      listArray = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"Mine" ofType: @"plist"]];
    if (self.curUser.isLogin==YES) {
        [self updateMemberClinet];
        [self getSystemNoticeClient];
        [self searchSystemDB];
         [self getRedPacketByStateClient:@"true"];
        [self CheckFeedBackRedNumClient];
    } else {
        //显示未登录时的状态
        [self notLogin];
        [self.tableview reloadData];
    }
    self.memberMan.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllerNo = @"A201";
      num=0;
    self.memberMan.delegate = self;
    listUseRedPacketArray = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionUserLoginSuccess:) name:NotificationNameUserLogin object:nil];
   
    
 
    [_tableview registerClass:[MineTableViewCell class] forCellReuseIdentifier:@"MineTableViewCell"];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.delegate = self;
    _tableview.dataSource = self;
     self.loadDataTool = [LoadData singleLoadData];
    [self noticeCenterSet];
    
    [_tableview reloadData];
}

-(void)notLogin{
    [self.loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    [self.userImage setImage:[UIImage imageNamed:@"usermine"]];
    self.loginBtn.enabled = YES;
    self.balanceLab.text = @"0";
    self.integralLab.text = @"0";
    self.redPacketLab.text =  @"0";
    self.signInBtn.enabled = YES;
    label.hidden=YES;
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


-(void)getMemberByCardCodeSms:(NSDictionary *)memberInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    NSLog(@"memberInfo%@",memberInfo);
    if ([msg isEqualToString:@"执行成功"]) {
      // [self showPromptText: @"memberInfo成功" hideAfterDelay: 1.7];
        User *user = [[User alloc]initWith:memberInfo];
        [GlobalInstance instance].curUser = user;
        [GlobalInstance instance].curUser.isLogin = YES;
        [self loadUserInfo];
        
        [self.memberMan isSignInToday:@{@"cardCode":self.curUser.cardCode}];
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

-(void)loadUserInfo{
    
    if (![self.curUser.memberType isEqualToString:@"FREEDOM_PERSON"] && self.curUser.isLogin == YES) {
        listArray = @[listArray[0],@[listArray[1][0]],listArray[2]];
        [self.tableview reloadData];
    }
    
    NSString *userName;
    if (self.curUser.nickname.length == 0) {
        userName = self.curUser.mobile;
    }else{
        userName = self.curUser.nickname;
    }
    [self.loginBtn setTitle:userName forState:UIControlStateNormal];
    self.loginBtn.enabled = NO;
    
    //[_userImage sd_setImageWithURL:[NSURL URLWithString:self.curUser.headUrl]];
    //浮点数值使用CGFloat,NSDecimalNumber对象进行处理:
    NSDecimalNumber *myDecimalObj1 = [[NSDecimalNumber alloc] initWithString:self.curUser.balance];
    NSLog(@"myDecimalObj doubleValue=%6.2f",[myDecimalObj1 doubleValue]);
    double balance = [myDecimalObj1 doubleValue];
    NSDecimalNumber *myDecimalObj2 = [[NSDecimalNumber alloc] initWithString:self.curUser.notCash];
    NSLog(@"myDecimalObj doubleValue=%6.2f",[myDecimalObj1 doubleValue]);
    double notCash = [myDecimalObj2 doubleValue];
    NSDecimalNumber *myDecimalObj3 = [[NSDecimalNumber alloc] initWithString:self.curUser.sendBalance];
    NSLog(@"myDecimalObj doubleValue=%6.2f",[myDecimalObj3 doubleValue]);
    double sendBalance = [myDecimalObj3 doubleValue];
    double total = balance+notCash+sendBalance;
    NSString *totalstr = [NSString stringWithFormat:@"%.2f",total];
    self.balanceLab.text = totalstr;
    int score =  [self.curUser.score intValue];
    NSString *scorestr = [NSString stringWithFormat:@"%d",score];
    self.integralLab.text = scorestr;
    int couponCount = [self.curUser.couponCount intValue];
    NSString *couponCountstr = [NSString stringWithFormat:@"%d",couponCount];
    self.redPacketLab.text = couponCountstr;
    self.userImage.layer.cornerRadius = 29;
    self.userImage.layer.masksToBounds = YES;
    if ([self.curUser.headUrl isEqualToString:@""] || self.curUser.headUrl == nil) {
        self.userImage.image = [UIImage imageNamed:@"usermine.png"];
    }else{
        self.userImage.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.curUser.headUrl]]];
    }
}


-(void)noticeCenterSet{
    noticeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    noticeBtn.frame = CGRectMake(0, 0, 35, 30);
    label = [[UILabel alloc]init];
    label.frame =CGRectMake(25, 0,10, 10);
    label.layer.cornerRadius = label.bounds.size.width/2;
    label.layer.masksToBounds = YES;
    label.hidden=YES;
 
    label.font = [UIFont systemFontOfSize:7];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor whiteColor];
    [noticeBtn addSubview:label];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: noticeBtn];
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

- (IBAction)signInBtnClick:(id)sender {
    if (!self.curUser.isLogin) {
        [self needLogin];
    } else {
        [self.memberMan signIn:@{@"cardCode":self.curUser.cardCode,@"activityId":@"1"}];
    }
}
-(void)signInIsSuccess:(NSDictionary *)info isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (success) {
        [self showPromptText:[NSString stringWithFormat:@"您已连续签到%@天,恭喜您获得%@积分!",info[@"severalDays"],info[@"gainScore"]] hideAfterDelay:1.7];
        self.signInBtn.enabled = NO;
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
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
     if (self.curUser.isLogin == NO) {
        [self needLogin];
    } else {
        if (self.curUser.name == nil || self.curUser.name.length == 0) {
            FirstBankCardSetViewController *fvc = [[FirstBankCardSetViewController alloc]init];
            fvc.titleStr=@"绑定银行卡";
            fvc.popTitle = @"尚未实名认证，请先实名认证再绑定银行卡";
            fvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fvc animated:YES];
            
        }else{
            WithdrawalsViewController *w = [[WithdrawalsViewController alloc]init];
            w.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:w animated:YES];
        }
      
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
    //    cell.imageView.image = [UIImage imageNamed: optionDic[@"icon"]];
    

    cell.lable.text = optionDic[@"title"];
    
    if (listUseRedPacketArray.count>0 && [optionDic[@"title"] isEqualToString:@"我的红包"]) {
        
        cell.redPoint.hidden=  !self.curUser.isLogin;
    }else  if (rednum>0 && [optionDic[@"title"] isEqualToString:@"意见反馈"]) {
        cell.redPoint.hidden= !self.curUser.isLogin;
    }else{
         cell.redPoint.hidden= YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
  
    NSDictionary *optionDic = listArray[indexPath.section][indexPath.row];
    if ([optionDic[@"needLogin"] boolValue] == YES && self.curUser.isLogin == NO) {
        [self needLogin];
    } else {
            self.memberSubFunctionClass = optionDic[@"actionClassName"];
            BaseViewController *vc = [[NSClassFromString(_memberSubFunctionClass) alloc] initWithNibName: _memberSubFunctionClass bundle: nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: vc animated: YES];
    }
}

#pragma 查询系统消息

-(void)getSystemNoticeClient{
    NSString *theRequest;
      theRequest= [GlobalInstance instance].homeUrl;
    //    theRequest = [[theRequest componentsSeparatedByString:@"/h5"] firstObject];
    //
    //    theRequest = [[theRequest componentsSeparatedByString:@"/ms"] firstObject];
    [self.loadDataTool RequestWithString:[NSString stringWithFormat:@"%@/app/inform/byChannel?usageChannel=3",theRequest] isPost:YES andPara:nil andComplete:^(id data, BOOL isSuccess) {
        // [self hideLoadingView];
        if (isSuccess) {
            NSString *resultStr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSData *jsonData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary  *resultDic1 = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            if ([resultDic1[@"code"] integerValue] != 0) {
                return ;
            }
            NSArray  *array =  resultDic1[@"result"];
            for (int i=0; i<array.count; i++) {
                
                Notice *notice = [[Notice alloc]initWith:array[i]];
                
               
                if ([self.fmdb open]) {
                    NSString *cardcode=[GlobalInstance instance ].curUser.cardCode;
                    if ([cardcode isEqualToString:@""]) {
                        cardcode = @"cardcode";
                    }
                    NSString *isread = @"0";
                    NSString *nid =[NSString stringWithFormat:@"A%d",i];
                    
                    FMResultSet*  rs = [self.fmdb executeQuery:@"select * from SystemNotice where id=?",notice._id];
                    BOOL isExit = NO;
                    do {
                        NSString *itemId = [rs stringForColumn:@"id"];
                        if ([itemId isEqualToString:notice._id]) {
                            isExit = YES;
                            break;
                        }
                    } while (rs.next);
                    
                    
                    if (!isExit) {
                        
                        BOOL result =  [self.fmdb executeUpdate:[NSString stringWithFormat:@"insert into SystemNotice (title,content, msgTime , cardcode ,isread,id,type,pagecode,url) values ('%@', '%@', '%@', '%@', '%@', '%@','%@', '%@', '%@');",notice.title,notice.content,notice.releaseTime,cardcode,isread,notice._id,notice.type,notice.thumbnailCode,notice.linkUrl]];
                        if (result) {
                            [self.fmdb close];
                        }
                    }
                }
                
                NSLog(@"redPacket%@",notice.content);
            }
            //[self.fmdb close];
        
        }else{
            [self showPromptText: @"服务器连接失败" hideAfterDelay: 1.7];
        }
    }];
    
}

-(void)searchSystemDB{
    num=0;
    // 1.查询数据
    if ([self.fmdb open]) {
        //        FMResultSet *rs = [db executeQuery:@"select * from vcUserPushMsg ;"];
        //    FMResultSet *rs = [self.fmdb executeQuery:@"select * from vcUserPushMsg"];
        // 2.遍历结果集
        
        FMResultSet*  rs = [self.fmdb executeQuery:@"select * from SystemNotice where isread=? ",@"0"];
   
        
        while (rs.next) {
            num++;
        }
        [rs close];
        [self.fmdb close];
     
        //    }];
    }
    if (num==0) {
        label.hidden=YES;
    }else{
        label.hidden=NO;
        label.text = [NSString stringWithFormat:@"%ld",num];
    }
}

#pragma 获取红包是否显示小红点

-(void)getRedPacketByStateClient:(NSString*)isValid{
    NSDictionary *Info;
    @try {
        NSString *cardCode = self.curUser.cardCode;
        Info = @{@"cardCode":cardCode,
                 @"isValid":isValid,
                 @"page":@"1",
                 @"pageSize":@"10"
                 };
        
    } @catch (NSException *exception) {
        return;
    }
        [self.memberMan getRedPacketByStateSms:Info];
  
    
}

-(void)getRedPacketByStateSms:(NSArray *)redPacketInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    
    NSLog(@"redPacketInfo%@",redPacketInfo);
    if ([msg isEqualToString:@"执行成功"]) {
        // [self showPromptText: @"memberInfo成功" hideAfterDelay: 1.7];
        [listUseRedPacketArray removeAllObjects];
        NSEnumerator *enumerator = [redPacketInfo objectEnumerator];
        id object;
        if ((object = [enumerator nextObject]) != nil) {
            NSArray *array = redPacketInfo;
            
            
            
            for (int i=0; i<array.count; i++) {
                
                RedPacket *redPacket = [[RedPacket alloc]initWith:array[i]];
                NSString *redPacketStatus = redPacket.redPacketStatus;
                if ([redPacketStatus isEqualToString:@"解锁"]) {
                    [listUseRedPacketArray addObject:redPacket];
                }
            }
            [self.tableview reloadData];
        }
        
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

#pragma 获取意见反馈是否显示小红点
-(void)FeedBackUnReadNum:(NSDictionary *)Info IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
        // [self showPromptText:@"获取意见反馈小红点成功！" hideAfterDelay:1.7];
        rednum = [[Info valueForKey:@"unReadNum"] longValue];
        [self.tableview reloadData];
    }else{
        
        [self showPromptText:msg hideAfterDelay:1.7];
        
    }
    
}

-(void)CheckFeedBackRedNumClient{
    NSDictionary *Info;
    @try {
        
        Info = @{@"cardCode":self.curUser.cardCode
                 };
        
    } @catch (NSException *exception) {
        return;
    }
        [self.memberMan FeedBackUnReadNum:Info];
}

-(void)needLogin{
    [super needLogin];
}

@end
