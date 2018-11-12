//
//  MineViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//  我的

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "RedPacketGainModel.h"
#import "MyAgentInfoModel.h"
#import "UIImage+RandomSize.h"
#import "CashInfoViewController.h"
#import "LoginViewController.h"
#import "MyCircleViewController.h"
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
#import "MineCollectionViewCell.h"
#import "FirstBankCardSetViewController.h"
#import "LoadData.h"
#import "Utility.h"
#import "MyPostSchemeViewController.h"
#import "MineRecommendViewCell.h"
#import "LegRechargeViewController.h"
#import "LegSelectViewController.h"


#define KMineRecommendViewCell @"MineRecommendViewCell"

@interface MineViewController () <UITableViewDelegate, UITableViewDataSource,MemberManagerDelegate,RecommendViewCellDelegate,AgentManagerDelegate,LotteryManagerDelegate,PostboyManagerDelegate>{
    NSMutableArray <NSDictionary *>*listArray;
    NSMutableArray <NSDictionary *>*groupArray;
    long num;
    long rednum;
    NSMutableArray *listUseRedPacketArray;
    __weak IBOutlet UIButton *tiXianBtn;
}
@property (weak, nonatomic) IBOutlet UIView *viewJIfen;
@property (weak, nonatomic) IBOutlet UIView *viewChongZhi;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jifenHeight;
@property (weak, nonatomic) IBOutlet UIButton *personSetBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chongzhiViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *balanceLab;//余额
@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;
@property (weak, nonatomic) IBOutlet UILabel *integralLab;//积分
@property (weak, nonatomic) IBOutlet UIButton *integralBtn;
@property (weak, nonatomic) IBOutlet UIButton *redPacketBtn;
@property (weak, nonatomic) IBOutlet UILabel *redPacketLab;
@property (weak, nonatomic) IBOutlet UILabel *lotMoneyLab;
@property (weak, nonatomic) IBOutlet UIButton *lotMoneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;//充值
@property (weak, nonatomic) IBOutlet UIButton *withdrawalsBtn;//提现
@property (weak, nonatomic) IBOutlet UILabel *noticeRedPointLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDIs;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeadCons;

@property(strong, nonatomic) NSString * memberSubFunctionClass;
@property (weak, nonatomic) IBOutlet UIImageView *topHead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCon;
@property (weak, nonatomic) IBOutlet UIButton *siginBtn;
@property(nonatomic,strong)  LoadData  *loadDataTool;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yueLeftCons;
@property (weak, nonatomic) IBOutlet UIButton *legYueBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalBalanceLeg;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    num=0;
    self.memberMan.delegate = self;
    self.postboyMan.delegate = self;
    listUseRedPacketArray = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionUserLoginSuccess:) name:NotificationNameUserLogin object:nil];
    
    self.loadDataTool = [LoadData singleLoadData];
    [self setTableView];
    self.viewControllerNo = @"A201";
    if ([self isIphoneX]) {
        self.topDIs.constant = -44;
        self.topHeadCons.constant = 235;
    }else{
        self.topDIs.constant = -20;
        self.topHeadCons.constant = 211;
    }
    tiXianBtn.layer.masksToBounds = YES;
    tiXianBtn.layer.cornerRadius = 6;
    tiXianBtn.layer.borderWidth = 1;
    tiXianBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.withdrawalsBtn.layer.masksToBounds = YES;
    self.withdrawalsBtn.layer.cornerRadius = 12;
    
    self.legYueBtn.layer.masksToBounds = YES;
    self.legYueBtn.layer.cornerRadius = 12;
    
    if (KscreenHeight >667) {
        self.heightCon.constant = KscreenHeight - self.tableView.mj_y;
    } else {
        self.heightCon.constant = 448;
    }
    self.noticeRedPointLab.layer.cornerRadius = 3;
    self.noticeRedPointLab.layer.masksToBounds = YES;
}


-(void)setTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:KMineRecommendViewCell bundle:nil] forCellReuseIdentifier:KMineRecommendViewCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
}

- (void)reloadDateArray {
    //数组拆分
    NSMutableArray *itemArray = [[NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"Mine" ofType: @"plist"]] mutableCopy];
    NSArray *smallArray = [itemArray subarrayWithRange:NSMakeRange(0, 4)];
    groupArray = [NSMutableArray arrayWithArray:smallArray];
    [itemArray removeObjectsInArray:smallArray];
    listArray = itemArray;
    //未登录状态     不显示我的圈子
    //登陆状态       只有圈主显示我的圈子 只有自由人显示推荐码
    if (self.curUser.isLogin == NO) {
        for (NSDictionary *itemDic in groupArray) {
            if ([itemDic[@"title"] isEqualToString:@"我的圈子"]) {
                [groupArray removeObject:itemDic];
                break;
            }
        }
    } else {
        if (![self.curUser.memberType isEqualToString:@"CIRCLE_MASTER"]){
            for (NSDictionary *itemDic in groupArray) {
                if ([itemDic[@"title"] isEqualToString:@"我的圈子"]) {
                    [groupArray removeObject:itemDic];
                    break;
                }
            }
        }
        if (![self.curUser.memberType isEqualToString:@"FREEDOM_PERSON"]) {
            for (NSDictionary *itemDic in listArray) {
                if ([itemDic[@"title"] isEqualToString:@"推荐码"]) {
                    [listArray removeObject:itemDic];
                    break;
                }
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    AppDelegate  *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    #ifdef APPSTORE
    if ([self.curUser.whitelist boolValue] == NO && self.tabBarController.viewControllers.count == 5) {
        
        [app setAppstoreRootVC];
    }else if([self.curUser.whitelist boolValue] == YES && self.tabBarController.viewControllers.count == 2){
        [app setNomalRootVC];
    }
    [self reloadDateArray];
    if ([self.curUser.whitelist boolValue] == NO) {
        self.tableView.hidden = YES;
    }else{
        self.tableView.hidden = NO;
    }
    
    [self.tableView reloadData];
    if ([self.curUser.whitelist boolValue] == NO) {
        self.viewJIfen.hidden = YES;
        self.jifenHeight.constant = 0;
        self.chongzhiViewHeight.constant = 0;
        self.viewChongZhi.hidden = YES;
    }else{
        self.viewJIfen.hidden = NO;
        self.jifenHeight.constant = 70;
        self.chongzhiViewHeight.constant = 66;
        self.viewChongZhi.hidden = NO;
    }
    #endif
    [self reloadDateArray];
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    self.viewJIfen.hidden = NO;
    self.jifenHeight.constant = 70;
    self.chongzhiViewHeight.constant = 66;
    self.viewChongZhi.hidden = NO;
   
    if (self.curUser.isLogin==YES) {
        [self updateMemberClinet];
        NSInteger num = [self getNotReadMes];
        if ( num == 0) {
            self.noticeRedPointLab.hidden = YES;
        }else{
            self.noticeRedPointLab.hidden = NO;
            if (num >99) {
                self.noticeRedPointLab.text = @"99+";
            } else {
                self.noticeRedPointLab.text = [NSString stringWithFormat:@"%ld",num];
            }
        }
        [self getRedPacketByStateClient:@"true"];
        [self CheckFeedBackRedNumClient];

    } else {
        //显示未登录时的状态
        [self notLogin];
        [self.tableView reloadData];
    }
    
    self.memberMan.delegate = self;
    self.navigationController.navigationBar.hidden = YES;
}


-(void)notLogin{
    [self.loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    [self.userImage setImage:[UIImage imageNamed:@"user_mine.png"]];
    self.loginBtn.enabled = YES;
    self.yueLeftCons.constant = - KscreenWidth/3;
    tiXianBtn.hidden = YES;
    self.balanceLab.text = @"0";
    self.integralLab.text = @"0";
    self.redPacketLab.text =  @"0";
    self.lotMoneyLab.text = @"0";
    self.totalBalanceLeg.text = @"0";
    self.noticeRedPointLab.hidden = YES;
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
            self.siginBtn.userInteractionEnabled = YES;
            [self.siginBtn setTitle:@"签到" forState:UIControlStateNormal];
        }else{
            self.siginBtn.userInteractionEnabled = NO;
            [self.siginBtn setTitle:@"已签到" forState:UIControlStateNormal];
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
    [self reloadDateArray];
    [self.tableView reloadData];
    NSString *userName;
    if (self.curUser.cardCode.length >0) {
        [self getMyAgentInfo];
    }
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
    double total = balance+notCash;
    NSString *totalstr = [NSString stringWithFormat:@"%.2f",total];
    self.balanceLab.text = totalstr;
    self.lotMoneyLab.text = [NSString stringWithFormat:@"%.2f",sendBalance];
    int score =  [self.curUser.score intValue];
    NSString *scorestr = [NSString stringWithFormat:@"%d",score];
    self.integralLab.text = scorestr;
    int couponCount = [self.curUser.couponCount intValue];
    NSString *couponCountstr = [NSString stringWithFormat:@"%d",couponCount];
    self.redPacketLab.text = couponCountstr;
    self.userImage.layer.cornerRadius = self.userImage.mj_h / 2;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderWidth = 1;
    self.userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    if ([self.curUser.headUrl isEqualToString:@""] || self.curUser.headUrl == nil) {
        self.userImage.image = [UIImage imageNamed:@"user_mine.png"];
    }else{
        [self.userImage sd_setImageWithURL:[NSURL URLWithString:self.curUser.headUrl] placeholderImage:[UIImage imageNamed:@"user_mine.png"]];
        
    }
    if (total == 0) {
        self.yueLeftCons.constant = - KscreenWidth/3;
        tiXianBtn.hidden = YES;
    } else {
        self.yueLeftCons.constant = 0;
        tiXianBtn.hidden = NO;
    }
    //小哥总余额
    self.totalBalanceLeg.text = [NSString stringWithFormat:@"%.2f元",[self.curUser.postboyBalance doubleValue] + [self.curUser.postboyNotCash doubleValue]];
}

-(void)noticeBtnClick{
    
     if (!self.curUser.isLogin){
        [self needLogin];
    } else {
        NoticeCenterViewController * nVC = [[NoticeCenterViewController alloc]init];
        nVC.hidesBottomBarWhenPushed = YES;
        [self showLoadingViewWithText:@"正在加载数据.." ];
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
        self.siginBtn.userInteractionEnabled = NO;
        [self.siginBtn setTitle:@"已签到" forState:UIControlStateNormal];
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}



- (IBAction)blanceBtnClick:(id)sender {
     if (!self.curUser.isLogin) {
        [self needLogin];
    } else {
        CashInfoViewController * pcVC = [[CashInfoViewController alloc]init];
        
        pcVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pcVC animated:YES];
    }
}

-(void)getMyAgentInfo{
    self.agentMan.delegate = self;
    [self.agentMan getMyAgentInfo:@{@"cardCode":self.curUser.cardCode}];
}


-(void)getMyAgentInfodelegate:(NSDictionary *)param isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (success == NO) {
        return;
    }
    MyAgentInfoModel * curMode = [[MyAgentInfoModel alloc]initWith:param];
    self.curUser.agentInfo= curMode;
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
        if ([self.curUser.whitelist boolValue]) {
            LegRechargeViewController *t = [[LegRechargeViewController alloc]init];
            t.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:t animated:YES];
        }
        else {
            [self showPromptText:@"本功能暂未开放" hideAfterDelay:1.0f];
        }
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
                    
                    FMResultSet*  rs = [self.fmdb executeQuery:@"select * from SystemNotice where noticeid=? and cardcode=?",notice._id == nil?@"":notice._id,cardcode == nil?@"":cardcode];
                    BOOL isExit = NO;
                    do {
                        NSString *itemId = [rs stringForColumn:@"noticeid"];
                        if ([itemId isEqualToString:notice._id]) {
                            isExit = YES;
                            break;
                        }
                    } while (rs.next);
                    
                    
                    if (!isExit) {
                        
                        BOOL result =  [self.fmdb executeUpdate:[NSString stringWithFormat:@"insert into SystemNotice (title,content, msgTime , cardcode ,isread,noticeid,type,pagecode,url) values ('%@', '%@', '%@', '%@', '%@', '%@','%@', '%@', '%@');",notice.title,notice.content,notice.releaseTime,cardcode,isread,notice._id,notice.type,notice.thumbnailCode==nil?@"":notice.thumbnailCode,notice.linkUrl==nil?@"":notice.linkUrl]];
                        if (result) {
                            [self.fmdb close];
                        }
                    }
                }
                
                NSLog(@"redPacket%@",notice.content);
            }
            //[self.fmdb close];
         [self searchSystemDB];
        }else{
             [self searchSystemDB];
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
        
        FMResultSet*  rs = [self.fmdb executeQuery:@"select * from SystemNotice where isread=? and cardcode=?",@"0",self.curUser.cardCode == nil?@"":self.curUser.cardCode];
   
        
        while (rs.next) {
            num++;
        }
        [rs close];
        [self.fmdb close];
     
        //    }];
    }
//    if (num==0) {
//        label.hidden=YES;
//    }else{
//        label.hidden=NO;
//        label.text = [NSString stringWithFormat:@"%ld",num];
//    }
}

#pragma 获取红包是否显示小红点

-(void)getRedPacketByStateClient:(NSString*)isValid{
    self.lotteryMan.delegate = self;
    [self.lotteryMan getRedPacketHis:@{@"cardCode":self.curUser.cardCode,@"page":@(1),@"pageSize":@(20)} andUrl:APIgainRedPacket];

}

-(void)gotRedPacketHis:(NSArray *)redPacketInfo errorInfo:(NSString *)errMsg{
    NSLog(@"redPacketInfo%@",redPacketInfo);
    if ([errMsg isEqualToString:@"执行成功"]) {
        // [self showPromptText: @"memberInfo成功" hideAfterDelay: 1.7];
        [listUseRedPacketArray removeAllObjects];
        NSEnumerator *enumerator = [redPacketInfo objectEnumerator];
        id object;
        if ((object = [enumerator nextObject]) != nil) {
            NSArray *array = redPacketInfo;
        
            for (int i=0; i<array.count; i++) {
                
                RedPacketGainModel *redPacket = [[RedPacketGainModel alloc]initWith:array[i]];
                NSString *redPacketStatus = redPacket.trRedPacketStatus;
                if ([redPacketStatus isEqualToString:@"解锁"]) {
                    [listUseRedPacketArray addObject:redPacket];
                }
            }
            [self.tableView reloadData];
        }
        
    }else{
        [self showPromptText: errMsg hideAfterDelay: 1.7];
    }
}

#pragma 获取意见反馈是否显示小红点
-(void)FeedBackUnReadNum:(NSDictionary *)Info IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
        // [self showPromptText:@"获取意见反馈小红点成功！" hideAfterDelay:1.7];
        rednum = [[Info valueForKey:@"unReadNum"] longValue];
        [self.tableView reloadData];
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
    [self hideLoadingView];
}

-(NSInteger)getNotReadMes{
    NSInteger notReadNum = 0 ;
        // 1.查询数据
        if ([self.fmdb open]) {
    
            FMResultSet*  rs = [self.fmdb executeQuery:@"select * from vcUserPushMsg where cardcode=?",self.curUser.cardCode];
            while (rs.next) {
                if ([[rs stringForColumn:@"isread"] boolValue] == NO) {
                    notReadNum ++;
                }
            }
             [self.fmdb close];
        }
    
        if ([self.fmdb open]) {
      
            FMResultSet*  rs = [self.fmdb executeQuery:@"select * from SystemNotice where cardcode=?",self.curUser.cardCode];
            
            while (rs.next) {
                if ([[rs stringForColumn:@"isread"] boolValue] == NO) {
                    notReadNum ++;
                }
            }
            [self.fmdb close];
        }
    return notReadNum;
}


- (IBAction)actionSetController:(id)sender {
    if (self.curUser.isLogin == NO) {
        [self needLogin];
        return;
    }
    SystemSetViewController *SystemSetVC = [[SystemSetViewController alloc]init];
    SystemSetVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:SystemSetVC animated:YES];
}

- (IBAction)actionToNotice:(id)sender {
    if (self.curUser.isLogin == NO) {
        [self needLogin];
        return;
    }
    NoticeCenterViewController *noticeVc = [[NoticeCenterViewController alloc]init];
    noticeVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:noticeVc animated:YES];
}

#pragma mark =====UITableView=========

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 140;
    }
    return 250;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineRecommendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KMineRecommendViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (indexPath.row == 0) {
        [cell reloadDate:groupArray];
        cell.labTitle.text = @"订单收益";
        return cell;
    }
    [cell reloadDate:listArray];
    cell.labTitle.text = @"常用服务";
    cell.login = self.curUser.isLogin;
    cell.listUseRedPacketArray = [listUseRedPacketArray copy];
    cell.rednum = rednum;
    return cell;
}

-(void)recommendViewCellClick:(NSDictionary *)selectDic{
    if ([selectDic[@"needLogin"] boolValue] == YES && self.curUser.isLogin == NO) {
            [self needLogin];
    } else {
        self.memberSubFunctionClass = selectDic[@"actionClassName"];
        
        if ([self.memberSubFunctionClass isEqualToString:@"MyPostSchemeViewController"]) {
          MyPostSchemeViewController *vc = [[MyPostSchemeViewController alloc]init];
          vc.isFaDan = YES;
          vc.hidesBottomBarWhenPushed = YES;
          [self.navigationController pushViewController: vc animated: YES];
        } else {
           BaseViewController *vc = [[NSClassFromString(_memberSubFunctionClass) alloc] initWithNibName: _memberSubFunctionClass bundle: nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: vc animated: YES];
        }
    }
}
- (IBAction)labCaijin:(id)sender {
    if (!self.curUser.isLogin) {
        [self needLogin];
    } else {
        CashInfoViewController * pcVC = [[CashInfoViewController alloc]init];
        pcVC.hidesBottomBarWhenPushed = YES;
        [pcVC setMenuOffset:CashInfoCaijin];
        [self.navigationController pushViewController:pcVC animated:YES];
    }
}

- (IBAction)actionToCunKuan:(id)sender {
    if (!self.curUser.isLogin) {
        [self needLogin];
    } else {
        if ([self.curUser.whitelist boolValue]) {
            LegSelectViewController * pcVC = [[LegSelectViewController alloc]init];
            pcVC.hidesBottomBarWhenPushed = YES;
            pcVC.titleName = @"存款";
            [self.navigationController pushViewController:pcVC animated:YES];
        }
        else {
            [self showPromptText:@"本功能暂未开放" hideAfterDelay:1.0f];
        }
    }
}

@end  
