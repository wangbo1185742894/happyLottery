//
//  PaySuccessViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/27.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "DLTSchemeDetailViewController.h"
#import "SchemeDetailViewController.h"
#import "MyOrderListViewController.h"
#import "CTZQSchemeDetailViewController.h"
#import "GYJSchemeDetailViewController.h"
#import "JCLQSchemeDetailViewController.h"
#import "MyPostSchemeViewController.h"
#import "FASSchemeDetailViewController.h"
#import "LotteryPlayViewController.h"

#import "DLTPlayViewController.h"
#import "SSQPlayViewController.h"
#import "JCZQPlayViewController.h"
#import "CTZQPlayViewController.h"
#import "JCLQPlayController.h"
#import "GYJPlayViewController.h"
#import "PersonCenterViewController.h"
#import "MyNoticeViewController.h"
#import "FollowSendViewController.h"
#import "SearchViewController.h"
#import "UMChongZhiViewController.h"
#import "YuCeSchemeCreateViewController.h"
#import "GroupFollowViewController.h"
#import "RedPackageView.h"
#import "WBInputPopView.h"
#import "AESUtility.h"
#import "InitiateFollowRedPModel.h"
#import "LegOrderDetailViewController.h"
#import "ZhuiHaoInfoViewController.h"

#define iOS8_0 [[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0

@interface PaySuccessViewController ()<LotteryManagerDelegate,RedPackageViewDelegete,WBInputPopViewDelegate,MemberManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnPostScheme;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeightPostScheme;
@end

@implementation PaySuccessViewController{
    UIAlertController *alert;
    WBInputPopView *passInput;
    NSString * univalent; /** 单个价格 */
    NSString * totalCount;  /** 红包个数 */
    InitiateFollowRedPModel *model;
    BOOL faqigentou;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约支付";
    if (self.schemetype == SchemeTypeGenDan ||self.schemetype == SchemeTypeFaqiGenDan) {
         self.btnHeightPostScheme.constant = 0;
    }else if(self.isShowFaDan){
        self.btnHeightPostScheme.constant = 44;
    }else{
        self.btnHeightPostScheme.constant = 0;
    }
    self.memberMan.delegate = self;
    self.lotteryMan.delegate = self;
    if (self.isMoni) {
        self.labChuPiaoimg.text = @"";
    }else{
        self.labChuPiaoimg.text = @"正在出票，祝您好运连连";
    }
    if ([Utility isIOS11After]) {
        self.automaticallyAdjustsScrollViewInsets = NO; // tableView 莫名其妙  contentOffset.y 成-64了  MMP
    }
    faqigentou = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.btnPostScheme.userInteractionEnabled = YES;
//    if (self.schemetype == SchemeTypeFaqiGenDan && self.btnHeightPostScheme.constant == 0) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.aniTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self initRedPackageView];
//        });
//    }
}

  
- (IBAction)actionLookOrder:(id)sender {
    if (self.schemetype == SchemeTypeZhuihao) {
        ZhuiHaoInfoViewController * betInfoViewCtr = [[ZhuiHaoInfoViewController alloc] initWithNibName:@"ZhuiHaoInfoViewController" bundle:nil];
        betInfoViewCtr.from = YES;
        [self.navigationController pushViewController:betInfoViewCtr animated:YES];
    } else{
        LegOrderDetailViewController *detail = [[LegOrderDetailViewController alloc]init];
        detail.schemeNo = self.schemeNO;
        detail.schemetype = self.schemetype;
        detail.lotteryName =  self.lotteryName;
        [self.navigationController pushViewController:detail animated:YES];
    }
  
//    if (self.schemetype == SchemeTypeGenDan) {
//        MyPostSchemeViewController *myOrderListVC = [[MyPostSchemeViewController alloc]init];
//        myOrderListVC.isFaDan = NO;
//        NSMutableArray * vcS = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
//        [vcS addObject:myOrderListVC];
//        self.navigationController.viewControllers = vcS;
//        FASSchemeDetailViewController *detailCV = [[FASSchemeDetailViewController alloc]init];
//        detailCV.schemeNo = self.schemeNO;
//        detailCV.schemeType = @"BUY_FOLLOW";
//        [self.navigationController pushViewController:detailCV animated:YES];
//    }else if ( self.schemetype == SchemeTypeFaqiGenDan){
//        MyPostSchemeViewController *myOrderListVC = [[MyPostSchemeViewController alloc]init];
//        myOrderListVC.isFaDan = YES;
//        NSMutableArray * vcS = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
//        [vcS addObject:myOrderListVC];
//        self.navigationController.viewControllers = vcS;
//        FASSchemeDetailViewController *detailCV = [[FASSchemeDetailViewController alloc]init];
//        detailCV.schemeNo = self.schemeNO;
//        detailCV.schemeType = @"BUY_INITIATE";
//        [self.navigationController pushViewController:detailCV animated:YES];
//    }else{
//        MyOrderListViewController *myOrderListVC = [[MyOrderListViewController alloc]init];
//        NSMutableArray * vcS = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
//        [vcS addObject:myOrderListVC];
//        self.navigationController.viewControllers = vcS;
//        if ([self.lotteryName isEqualToString:@"胜负14场"] || [self.lotteryName isEqualToString:@"任选9场"]) {
//            CTZQSchemeDetailViewController *schemeVC = [[CTZQSchemeDetailViewController alloc]init];
//            schemeVC.schemeNO = self.schemeNO;
//            [self.navigationController pushViewController:schemeVC animated:YES];
//        }else if([self.lotteryName isEqualToString:@"大乐透"]||[self.lotteryName isEqualToString:@"双色球"] || [self.lotteryName isEqualToString:@"陕西11选5"] || [self.lotteryName isEqualToString:@"山东11选5"]){
//            DLTSchemeDetailViewController *schemeVC = [[DLTSchemeDetailViewController alloc]init];
//            schemeVC.schemeNO = self.schemeNO;
//            [self.navigationController pushViewController:schemeVC animated:YES];
//        }else if ([self.lotteryName isEqualToString:@"冠军"] || [self.lotteryName isEqualToString:@"冠亚军"]){
//            GYJSchemeDetailViewController *schemeVC = [[GYJSchemeDetailViewController alloc]init];
//            schemeVC.schemeNO = self.schemeNO;
//            [self.navigationController pushViewController:schemeVC animated:YES];
//        }else if ([self.lotteryName isEqualToString:@"竞彩篮球"]){
//            JCLQSchemeDetailViewController *schemeVC = [[JCLQSchemeDetailViewController alloc]init];
//            schemeVC.schemeNO = self.schemeNO;
//            [self.navigationController pushViewController:schemeVC animated:YES];
//        }else{
//            SchemeDetailViewController *schemeVC = [[SchemeDetailViewController alloc]init];
//            schemeVC.schemeNO = self.schemeNO;
//            [self.navigationController pushViewController:schemeVC animated:YES];
//        }
//
//    }

}

- (IBAction)actionBackHome:(id)sender {
    [self navigationBackToLastPage];
}

-(void)navigationBackToLastPage{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        NSLog(@"-----%@------",controller);
        if ([controller isKindOfClass:[GYJPlayViewController class]]) {
            GYJPlayViewController *revise =(GYJPlayViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
            return;
        }
        
        if ([controller isKindOfClass:[DLTPlayViewController class]]) {
            DLTPlayViewController *revise =(DLTPlayViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
            return;
        }
        if ([controller isKindOfClass:[SSQPlayViewController class]]) {
            SSQPlayViewController *revise =(SSQPlayViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
            return;
        }
        if ([controller isKindOfClass:[JCZQPlayViewController class]]) {
            JCZQPlayViewController *revise =(JCZQPlayViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:KSELECTMATCHCLEAN object:nil];
            return;
        }
        if ([controller isKindOfClass:[CTZQPlayViewController class]]) {
            CTZQPlayViewController *revise =(CTZQPlayViewController *)controller;
            [[NSNotificationCenter defaultCenter]postNotificationName:KSELECTMATCHCLEAN object:nil];
            [self.navigationController popToViewController:revise animated:YES];
            return;
            
        }
        if ([controller isKindOfClass:[JCLQPlayController class]]) {
            JCLQPlayController *revise =(JCLQPlayController *)controller;
            [[NSNotificationCenter defaultCenter]postNotificationName:KSELECTMATCHCLEAN object:nil];
            [self.navigationController popToViewController:revise animated:YES];
            return;
        }
        if ([controller isKindOfClass:[YuCeSchemeCreateViewController class]]) {
            YuCeSchemeCreateViewController *revise =(YuCeSchemeCreateViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
            return;
        }
        
        if ([controller isKindOfClass:[LotteryPlayViewController class]]) {
            LotteryPlayViewController *revise =(LotteryPlayViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
            return;
        }
        
        if ([controller isKindOfClass:[FollowSendViewController class]]) {
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[PersonCenterViewController class]]) {
                    PersonCenterViewController *revise =(PersonCenterViewController *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                    return;
                }
                if ([controller isKindOfClass:[MyNoticeViewController class]]) {
                    MyNoticeViewController *revise =(MyNoticeViewController *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                    return;
                }
                if ([controller isKindOfClass:[JCZQPlayViewController class]]) {
                    JCZQPlayViewController *revise =(JCZQPlayViewController *)controller;
                    [[NSNotificationCenter defaultCenter]postNotificationName:KSELECTMATCHCLEAN object:nil];
                    [self.navigationController popToViewController:revise animated:YES];
                    return;
                }
                if ([controller isKindOfClass:[JCLQPlayController class]]) {
                    JCLQPlayController *revise =(JCLQPlayController *)controller;
                    [[NSNotificationCenter defaultCenter]postNotificationName:KSELECTMATCHCLEAN object:nil];
                    [self.navigationController popToViewController:revise animated:YES];
                    return;
                }
                if ([controller isKindOfClass:[SearchViewController class]]) {
                    SearchViewController *revise =(SearchViewController *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                    return;
                }
            }
            FollowSendViewController *revise =(FollowSendViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
            return;
        }
        if ([controller isKindOfClass:[MyPostSchemeViewController class]]) {
            MyPostSchemeViewController *revise =(MyPostSchemeViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
            return;
        }
        if ([controller isKindOfClass:[GroupFollowViewController class]]) {
            GroupFollowViewController *revise =(GroupFollowViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
            return;
        }
        
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark ====== 发单红包 =====

- (void)initRedPackageView {
    RedPackageView *redPackView = [[RedPackageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    redPackView.delegate = self;
    redPackView.totalBanlece = self.orderCost;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow addSubview:redPackView];
    });
}


- (IBAction)actionPostScheme:(id)sender {
    self.btnPostScheme.userInteractionEnabled = NO;
    faqigentou = YES;
    if (self.schemetype == SchemeTypeFaqiGenDan && self.btnHeightPostScheme.constant == 0) {
        return;
    }
    [self.lotteryMan initiateFollowScheme:@{@"schemeNo":self.schemeNO}];
//    [self initRedPackageView];
}

//RedPackageViewDelegete
- (void)initiateFollowScheme {
    if (self.schemetype == SchemeTypeFaqiGenDan && self.btnHeightPostScheme.constant == 0) {
        return;
    }
    [self.lotteryMan initiateFollowScheme:@{@"schemeNo":self.schemeNO}];
}

//RedPackageViewDelegete
- (void)payForRedPackage:(NSString *)count andMoney:(NSString *)money{
     univalent = money;
     totalCount = count;
     [self showPayPopView];
}

- (void)showPayPopView{
    if (nil == passInput) {
        passInput = [[WBInputPopView alloc]init];
        passInput.delegate = self;
        passInput.labTitle.text = @"请输入支付密码";
        passInput.fromSendRed = YES;
    }
    [self.view addSubview:passInput];
    passInput.delegate = self;
    [passInput.txtInput becomeFirstResponder];
    [passInput createBlock:^(NSString *text) {
        
        if (nil == text) {
            [self showPromptText:@"请输入支付密码" hideAfterDelay:2.7];
            return;
        }
        
        NSDictionary *cardInfo= @{@"cardCode":self.curUser.cardCode,
                                  @"payPwd":[AESUtility encryptStr:text]};
        [self.memberMan validatePaypwdSms:cardInfo];
    }];
    
}

//WBInputPopViewdelegate
-(void)findPayPwd{
    [self forgetPayPwd];
}

-(void)clickBackGround{
    if (faqigentou) {
       [self.lotteryMan initiateFollowScheme:@{@"schemeNo":self.schemeNO}];
    }
}

-(void)validatePaypwdSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    if (success == YES) {
        [passInput removeFromSuperview];
        //密码验证成功，扣除红包金额，发单
        model = [InitiateFollowRedPModel new];
        model.schemeNo = self.schemeNO;
        model.cardCode = self.curUser.cardCode;
        model.amount = [NSString stringWithFormat:@"%ld",[univalent integerValue]* [totalCount integerValue]];
        model.univalent = univalent;
        model.totalCount = totalCount;
        model.randomType = NORMAL;
        
        if ( self.schemetype == SchemeTypeFaqiGenDan && self.btnHeightPostScheme.constant == 0) {
            [self.lotteryMan initiateFollowRedPacketPayment:@{@"initiateFollowRedPacket":[model submitParaDicScheme]}];
         
        } else {
            [self.lotteryMan initiateFollowScheme:@{@"schemeNo":self.schemeNO,@"initiateFollowRedPacket":[model submitParaDicScheme]}];
        }
        
    }else{
        //密码验证失败，不发红包
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}


- (void)initiateFollowScheme:(NSString *)resultStr errorMsg:(NSString *)msg{
    if(resultStr != nil && resultStr.length > 0){
        [self showPromptText:@"发单成功" hideAfterDelay:1.9];
    }else{
        self.btnPostScheme.userInteractionEnabled = YES;
        [self showPromptText:msg hideAfterDelay:1.9];
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LegOrderDetailViewController *myOrderListVC = [[LegOrderDetailViewController alloc]init];
        myOrderListVC.schemeNo = self.schemeNO;
        myOrderListVC.schemetype = SchemeTypeFaqiGenDan;
        myOrderListVC.lotteryName = self.lotteryName;
        NSMutableArray * vcS = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [vcS addObject:myOrderListVC];
        self.navigationController.viewControllers = vcS;
    });
}

- (void)initiateFollowRedPacketPayment:(NSString *)resultStr  errorMsg:(NSString *)msg{
    if(resultStr != nil && resultStr.length > 0){
        [self showPromptText:@"发红包成功" hideAfterDelay:1.9];
    }else{
        [self showPromptText:msg hideAfterDelay:1.9];
        return;
    }
}

@end
