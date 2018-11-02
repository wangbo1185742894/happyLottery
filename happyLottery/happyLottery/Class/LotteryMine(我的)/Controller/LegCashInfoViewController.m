//
//  LegCashInfoViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/7/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "LegCashInfoViewController.h"
#import "LegClassListCellViewController.h"
#import "WBMenu.h"
@interface LegCashInfoViewController (){
    LegCashInfoType _index;
}

@property(nonatomic,strong)WBMenu *topMenu;

@end

@implementation LegCashInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.vcTitle;
       _topMenu = [[WBMenu alloc]initWithFrame:CGRectMake(0, NaviHeight - 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - NaviHeight +20)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *titleArray;
    NSArray *apiArray;
    titleArray = @[@"购彩",@"追号",@"充值",@"派奖",@"提现",@"佣金"];
    apiArray = @[APIListSubscribeDetailByPostboy,APIGetChasePrepayOrderListByPostboy,APIListRechargeDetailByPostboy,APIListBonusDetailByPostboy,APIListWithdrawDetailByPostboy,APIListCommissionDetailByPostboy];

    [_topMenu createMenuView:titleArray size:CGSizeMake(70, 40)];
    
    for (int i = 0; i < titleArray.count ; i ++) {
        LegClassListCellViewController * classListVC = [[LegClassListCellViewController alloc]init];
        classListVC.navVCLeg = self;
        classListVC.strApiLeg  = apiArray[i];
        classListVC.firstParaLeg = [NSMutableDictionary dictionaryWithDictionary:@{@"cardCode":self.curUser.cardCode,@"postboyId":self.postboyId, @"pageSize":@(KpageSize)}];
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


@end
