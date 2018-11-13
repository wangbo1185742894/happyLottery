//
//  CashInfoViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/7/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "CashInfoViewController.h"
#import "ClassListCellViewController.h"
#import "WBMenu.h"
@interface CashInfoViewController (){
    CashInfoType _index;
}
@property(nonatomic,strong)WBMenu *topMenu;
@end

@implementation CashInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户明细";
       _topMenu = [[WBMenu alloc]initWithFrame:CGRectMake(0, NaviHeight - 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - NaviHeight +20)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *titleArray;
    NSArray *apiArray;
    NSInteger fanyongindex;
    if ([self.curUser.memberType isEqualToString:@"CIRCLE_MASTER"]) {
        titleArray = @[@"购彩",@"追号",@"充值",@"派奖",@"提现",@"彩金",@"佣金",@"返佣",@"红包"];
        fanyongindex = 7;
            apiArray = @[API_listSubscribeDetail,API_getChasePrepayOrderList,API_listRechargeDetail,API_listBonusDetail,API_listWithdrawDetail,API_listHandselDetail,API_listFollowDetail,API_listAgentCommissionDetail,APIgetRedPacketOrderList];
    }else{
        titleArray = @[@"购彩",@"追号",@"充值",@"派奖",@"提现",@"彩金",@"佣金",@"红包"];
        fanyongindex = 8;  //没有返佣
        apiArray = @[API_listSubscribeDetail,API_getChasePrepayOrderList,API_listRechargeDetail,API_listBonusDetail,API_listWithdrawDetail,API_listHandselDetail,API_listFollowDetail,APIgetRedPacketOrderList];
    }

    [_topMenu createMenuView:titleArray size:CGSizeMake(70, 40)];
    
    for (int i = 0; i < titleArray.count ; i ++) {
        ClassListCellViewController * classListVC = [[ClassListCellViewController alloc]init];
        classListVC.navVC = self;
        classListVC.strApi  = apiArray[i];
        if (i == fanyongindex) {
            
            classListVC.firstPara = [NSMutableDictionary dictionaryWithDictionary:@{@"agentId":self.curUser.agentInfo._id==nil?@"":self.curUser.agentInfo._id,@"pageSize":@(KpageSize)}];
            
        }else{
            classListVC.firstPara = [NSMutableDictionary dictionaryWithDictionary:@{@"cardCode":self.curUser.cardCode,@"pageSize":@(KpageSize)}];
        }
        [_topMenu addViewController:classListVC atIndex:i];
    }
    if (_index != 0) {
        [_topMenu setMenuViewOffset:_index];
    }
    
    [self.view addSubview:_topMenu];
}

-(void)setMenuOffset:(CashInfoType)index{
    _index = index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
