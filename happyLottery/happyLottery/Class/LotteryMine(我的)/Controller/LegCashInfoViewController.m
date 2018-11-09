//
//  LegCashInfoViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/7/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "LegCashInfoViewController.h"
#import "LegClassListCellViewController.h"
#import "FirstBankCardSetViewController.h"
#import "WithdrawalsViewController.h"
#import "WBMenu.h"
@interface LegCashInfoViewController (){
    LegCashInfoType _index;
    __weak IBOutlet NSLayoutConstraint *topCons;
    __weak IBOutlet UIView *yueView;
    __weak IBOutlet UILabel *yueLab;
    __weak IBOutlet UILabel *canTiXianLab;
    __weak IBOutlet UIButton *tiXianBtn;
}

@property(nonatomic,strong)WBMenu *topMenu;

@end

@implementation LegCashInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@余额明细",self.postboyModel.postboyName];
    yueLab.text = [NSString stringWithFormat:@"%.2f元",[self.postboyModel.totalBalance doubleValue]];
    canTiXianLab.text = [NSString stringWithFormat:@"%.2f元",[self.postboyModel.cashBalance doubleValue]];
    if ([self.postboyModel.cashBalance doubleValue] == 0) {
        tiXianBtn.userInteractionEnabled = NO;
        tiXianBtn.alpha = 0.4;
    } else {
        tiXianBtn.userInteractionEnabled = YES;
        tiXianBtn.alpha = 1.0;
    }
    topCons.constant = NaviHeight + 5;
    yueView.layer.masksToBounds = YES;
    yueView.layer.cornerRadius = 14;
    tiXianBtn.layer.masksToBounds = YES;
    tiXianBtn.layer.cornerRadius = 4;
    
    _topMenu = [[WBMenu alloc]initWithFrame:CGRectMake(0, NaviHeight - 20+ yueView.mj_h +10, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - NaviHeight +20- yueView.mj_h-10)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *titleArray;
    NSArray *apiArray;
    titleArray = @[@"购彩",@"追号",@"充值",@"派奖",@"提现",@"佣金",@"余额转入"];
    apiArray = @[APIListSubscribeDetailByPostboy,APIGetChasePrepayOrderListByPostboy,APIListRechargeDetailByPostboy,APIListBonusDetailByPostboy,APIListWithdrawDetailByPostboy,APIListCommissionDetailByPostboy,APIListTransferByPostboy];

    [_topMenu createMenuView:titleArray size:CGSizeMake(70, 40)];
    
    for (int i = 0; i < titleArray.count ; i ++) {
        LegClassListCellViewController * classListVC = [[LegClassListCellViewController alloc]init];
        classListVC.navVCLeg = self;
        classListVC.strApiLeg  = apiArray[i];
        classListVC.firstParaLeg = [NSMutableDictionary dictionaryWithDictionary:@{@"cardCode":self.curUser.cardCode,@"postboyId":self.postboyModel._id, @"pageSize":@(KpageSize)}];
        [_topMenu addViewController:classListVC atIndex:i];
    }
    if (_index != 0) {
        [_topMenu setMenuViewOffset:_index];
    }
    
    [self.view addSubview:_topMenu];
}

-(void)setMenuOffset:(LegCashInfoType)index{
    _index = index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionToTiXian:(id)sender {
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
            WithdrawalsViewController *withVC = [[WithdrawalsViewController alloc]init];
            withVC.postboyModel = self.postboyModel;
            withVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:withVC animated:YES];
        }
        
    }
}

@end
