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

#define KMenuCollectionViewCell @"MineCollectionViewCell"

@interface MineViewController () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MemberManagerDelegate>{
    NSMutableArray <NSDictionary *>*listArray;
    NSMutableArray <NSDictionary *>*groupArray;
    __weak IBOutlet UIButton *btnMyCircle;
    UIButton *noticeBtn;
    UILabel *label;
    long num;
    long rednum;
       NSMutableArray *listUseRedPacketArray;
    __weak IBOutlet NSLayoutConstraint *tableViewHeight;
}
@property (weak, nonatomic) IBOutlet UIView *viewJIfen;
@property (weak, nonatomic) IBOutlet UIView *viewChongZhi;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jifenHeight;
@property (weak, nonatomic) IBOutlet UIButton *personSetBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chongzhiViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

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
@property (weak, nonatomic) IBOutlet UICollectionView *mineInfoColloView;
@property (weak, nonatomic) IBOutlet UILabel *noticeRedPointLab;
@property (weak, nonatomic) IBOutlet UIImageView *notiRedPointImg;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDIs;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeadCons;

@property(strong, nonatomic) NSString * memberSubFunctionClass;
@property (weak, nonatomic) IBOutlet UIImageView *topHead;
@property(nonatomic,strong)  LoadData  *loadDataTool;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    num=0;
    self.memberMan.delegate = self;
    listUseRedPacketArray = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionUserLoginSuccess:) name:NotificationNameUserLogin object:nil];
    [self.mineInfoColloView registerNib:[UINib nibWithNibName:@"MineCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:KMenuCollectionViewCell];
    _mineInfoColloView.delegate = self;
    _mineInfoColloView.dataSource = self;
    self.loadDataTool = [LoadData singleLoadData];
    [self noticeCenterSet];
    
    [_mineInfoColloView reloadData];
    self.viewControllerNo = @"A201";
    if ([self isIphoneX]) {
        self.topDIs.constant = -44;
        self.topHeadCons.constant = 190;
    }else{
        self.topDIs.constant = -20;
        self.topHeadCons.constant = 166;
    }
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
    if ([self.curUser.whitelist boolValue] == NO && self.tabBarController.viewControllers.count == 5) {
        
        [app setAppstoreRootVC];
    }else if([self.curUser.whitelist boolValue] == YES && self.tabBarController.viewControllers.count == 2){
        [app setNomalRootVC];
    }
    [self reloadDateArray];
    if ([self.curUser.whitelist boolValue] == NO) {
        self.mineInfoColloView.hidden = YES;
    }else{
        self.mineInfoColloView.hidden = NO;
    }
  
    [self.mineInfoColloView reloadData];
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
    
    
    if (self.curUser.isLogin==YES) {
            [self updateMemberClinet];
            NSInteger num = [self getNotReadMes];
            if ( num == 0) {
                label.hidden = YES;
            }else{
                label.hidden = NO;
                label.text = [NSString stringWithFormat:@"%ld",num];
            }
            
            [self getRedPacketByStateClient:@"true"];
            [self CheckFeedBackRedNumClient];

    } else {
        //显示未登录时的状态
        [self notLogin];
        [self.mineInfoColloView reloadData];
    }
    
    self.memberMan.delegate = self;
    NSInteger num = [self getNotReadMes];
    if ( num == 0) {
        self.noticeRedPointLab.hidden = YES;
        self.notiRedPointImg.hidden = YES;
    }else{
        self.noticeRedPointLab.hidden = NO;
        self.notiRedPointImg.hidden = NO;
        self.noticeRedPointLab.text = [NSString stringWithFormat:@"%ld",num];
    }
    self.navigationController.navigationBar.hidden = YES;
}


-(void)notLogin{
    [self.loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    [self.userImage setImage:[UIImage imageNamed:@"user_place"]];
    self.loginBtn.enabled = YES;
    self.balanceLab.text = @"0";
    self.integralLab.text = @"0";
    self.redPacketLab.text =  @"0";
    self.lotMoneyLab.text = @"0";
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
//    if (success ) {
//        if ([redPacketInfo boolValue] == NO) { // 未签
//            self.signInBtn.enabled = YES;
//        }else{
//            self.signInBtn.enabled = NO;
//        }
//    }
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
    [self.mineInfoColloView reloadData];
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
    self.lotMoneyLab.text = [NSString stringWithFormat:@"%.2f",sendBalance];
    int score =  [self.curUser.score intValue];
    NSString *scorestr = [NSString stringWithFormat:@"%d",score];
    self.integralLab.text = scorestr;
    int couponCount = [self.curUser.couponCount intValue];
    NSString *couponCountstr = [NSString stringWithFormat:@"%d",couponCount];
    self.redPacketLab.text = couponCountstr;
    self.userImage.layer.cornerRadius = 29;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderWidth = 1;
    self.userImage.layer.borderColor = RGBCOLOR(245, 215, 90).CGColor;
    if ([self.curUser.headUrl isEqualToString:@""] || self.curUser.headUrl == nil) {
        self.userImage.image = [UIImage imageNamed:@"user_place.png"];
    }else{
        [self.userImage sd_setImageWithURL:[NSURL URLWithString:self.curUser.headUrl] placeholderImage:[UIImage imageNamed:@"usermine.png"]];
        
    }
}


-(void)noticeCenterSet{
    noticeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    noticeBtn.frame = CGRectMake(0, 0, 45, 45);
    label = [[UILabel alloc]init];
    label.frame =CGRectMake(25, 0,10, 10);
    label.layer.cornerRadius = label.bounds.size.width/2;
    label.layer.masksToBounds = YES;
    label.hidden=YES;
 
    label.font = [UIFont systemFontOfSize:7];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor whiteColor];
//    [noticeBtn addSubview:label];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: noticeBtn];
    [noticeBtn setImage:[UIImage imageNamed:@"signin"] forState:UIControlStateNormal];
    [noticeBtn addTarget: self action: @selector(signInBtnClick:) forControlEvents: UIControlEventTouchUpInside];
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
//        self.signInBtn.enabled = NO;
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


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (void)hiddenCell:(MineCollectionViewCell *)cell{
    cell.labRedPoint.hidden = YES;
    cell.imgItemIcon.hidden = YES;
    cell.labItemTitle.hidden = YES;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MineCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:KMenuCollectionViewCell forIndexPath:indexPath];
    NSDictionary *optionDic;
   
    if (indexPath.section == 0) {
        if (indexPath.row == groupArray.count) {
            [self hiddenCell:cell];
            return cell;
        }
        optionDic = groupArray[indexPath.row];
    }else {
        if (indexPath.row == listArray.count) {
           [self hiddenCell:cell];
           return cell;
        }
        optionDic = listArray[indexPath.row];
    }
    cell.labRedPoint.hidden = NO;
    cell.imgItemIcon.hidden = NO;
    cell.labItemTitle.hidden = NO;
    cell.labRedPoint.adjustsFontSizeToFitWidth = YES;
    
    cell.imgItemIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_mine",optionDic[@"icon"]]];
    if (listUseRedPacketArray.count>0 && [optionDic[@"title"] isEqualToString:@"我的红包"]) {
        
        cell.labRedPoint.hidden=  !self.curUser.isLogin;
    }else  if (rednum>0 && [optionDic[@"title"] isEqualToString:@"意见反馈"]) {
        cell.labRedPoint.hidden= !self.curUser.isLogin;
    }else{
        cell.labRedPoint.hidden= YES;
    }
    cell.labItemTitle.text = optionDic[@"title"];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(KscreenWidth / 2-0.5, 80);
    }
    return CGSizeMake(KscreenWidth / 2, 80);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return  UIEdgeInsetsMake(10, 0, 10, 0);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    //[self.tableView registerClass :[YourTableCell class] forCellReuseIdentifier:@"txTableCell"];
//    static NSString *CellIdentifier = @"TabViewCell";
//    //自定义cell类
//    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"MineTableViewCell" owner:self options:nil] lastObject];
//    }
//    NSDictionary *optionDic = listArray[indexPath.section][indexPath.row];
//    cell.image.image = [UIImage reSizeImageName:optionDic[@"icon"] andMinWidth:18];
//    //    cell.imageView.image = [UIImage imageNamed: optionDic[@"icon"]];
//
//
//    cell.lable.text = optionDic[@"title"];
//
//    if (listUseRedPacketArray.count>0 && [optionDic[@"title"] isEqualToString:@"我的红包"]) {
//
//        cell.redPoint.hidden=  !self.curUser.isLogin;
//    }else  if (rednum>0 && [optionDic[@"title"] isEqualToString:@"意见反馈"]) {
//        cell.redPoint.hidden= !self.curUser.isLogin;
//    }else{
//         cell.redPoint.hidden= YES;
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.lable.font = [UIFont systemFontOfSize:15];
//    NSString *ShowIconRight =optionDic[@"ShowIconRight"];
//    if ([ShowIconRight isEqualToString:@"1"]) {
//        cell.rightIcon.hidden=NO;
//    }else{
//         cell.rightIcon.hidden=YES;
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//
////        tableViewHeight.constant = self.tableview.mj_h;
//    });
//    return cell;
//}
//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    tableView.backgroundColor = [UIColor clearColor];
//    NSString *sectionTitle;
//    if ([self respondsToSelector:@selector(tableView)]) {
//        sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
//    }else{
//        sectionTitle = nil;
//    }
//
//    if (sectionTitle == nil) {
//        UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)] ;
//        [sectionView setBackgroundColor:[UIColor clearColor]];
//        return  sectionView;
//    }
//
//    UILabel * label = [[UILabel alloc] init] ;
//    label.frame = CGRectMake(15, 0, 320, 40);
//    label.backgroundColor = [UIColor clearColor];
//    label.font=[UIFont systemFontOfSize:15];
//    label.text = sectionTitle;
//
//    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)] ;
//    [sectionView setBackgroundColor:[UIColor clearColor]];
//    [sectionView addSubview:label];
//    return sectionView;
//}

#pragma UITableViewDelegate methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    return 8;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *optionDic;
    if (indexPath.section == 0) {
        optionDic = groupArray[indexPath.row];
    }else{
        optionDic = listArray[indexPath.row];
    }
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
            [self.mineInfoColloView reloadData];
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
        [self.mineInfoColloView reloadData];
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
//    self.navigationController.navigationBar.hidden = NO;
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

@end  
