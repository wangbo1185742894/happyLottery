//
//  PayOrderViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/18.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "PayOrderViewController.h"
#import "PaySuccessViewController.h"
#define KPayTypeListCell @"PayTypeListCell"
@interface PayOrderViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,MemberManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labLotteryName;
@property (weak, nonatomic) IBOutlet UILabel *labOrderCost;
@property (weak, nonatomic) IBOutlet UILabel *labBanlance;
@property (weak, nonatomic) IBOutlet UITableView *tabPayTypeList;
@property (weak, nonatomic) IBOutlet UIButton *btnTouzhuRule;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectRule;
@property (weak, nonatomic) IBOutlet UIButton *btnTouzhu;
@property (weak, nonatomic) IBOutlet UILabel *labZheKou;

@end

@implementation PayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    
    self.memberMan.delegate = self;
    [self.memberMan getMemberByCardCode:@{@"cardCode":self.curUser.cardCode}];
    [self showLoadingText:@"正在提交订单"];
    self.lotteryMan.delegate = self;
}
-(void)gotMemberByCardCode:(NSDictionary *)userInfo errorMsg:(NSString *)msg{
    [self hideLoadingView];
    User *user = [[User alloc]initWith:userInfo];
    self.curUser.balance = user.balance;
    self.curUser.sendBalance = user.sendBalance;
    self.curUser.score = user.score;
    self.labBanlance.text = [NSString stringWithFormat:@"%@ 元",self.curUser.balance] ;
    self.labOrderCost.text = [NSString stringWithFormat:@"%ld 元",self.cashPayMemt.realSubscribed] ;
}

-(void)setTableView{
    self.tabPayTypeList .dataSource =self;
    self.tabPayTypeList.delegate = self;
    [self.tabPayTypeList registerClass:[PayTypeListCell class] forCellReuseIdentifier:KPayTypeListCell];
}

-(void)navigationBackToLastPage{
    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"返回将清空所选赛事，确定返回吗？"];
    [alert addBtnTitle:@"取消" action:^{
        
    }];
    [alert addBtnTitle:@"确定" action:^{
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
    [alert showAlertWithSender:self];
}

#pragma LotteryManagerDelegate

#pragma UITableViewDelegate,UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayTypeListCell *cell = [tableView dequeueReusableCellWithIdentifier:KPayTypeListCell];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)actionTouzhu:(id)sender {
    
    if (self.cashPayMemt.costType == CostTypeCASH) {
        [self.lotteryMan schemeCashPayment:@{@"cardCode":self.cashPayMemt.cardCode,
                                             @"schemeNo":self.cashPayMemt.schemeNo,
                                             @"subCopies":@(self.cashPayMemt.subCopies),
                                             @"subscribed":@(self.cashPayMemt.subscribed),
                                             @"realSubscribed":@(self.cashPayMemt.realSubscribed),
                                             @"isSponsor":@(true)
                                             }];
    }else{
        [self.lotteryMan schemeScorePayment:@{@"cardCode":self.cashPayMemt.cardCode,
                                             @"schemeNo":self.cashPayMemt.schemeNo,
                                             @"subCopies":@(self.cashPayMemt.subCopies),
                                             @"subscribed":@(self.cashPayMemt.subscribed),
                                             @"realSubscribed":@(self.cashPayMemt.realSubscribed),
                                             @"isSponsor":@(true)
                                             }];
    }
}

-(void)paySuccess{
    PaySuccessViewController * paySuccessVC = [[PaySuccessViewController alloc]init];
    paySuccessVC.schemeNO = self.cashPayMemt.schemeNo;
    [self.navigationController pushViewController:paySuccessVC animated:YES];
}

-(void)gotSchemeCashPayment:(BOOL)isSuccess errorMsg:(NSString *)msg{
    if (isSuccess) {
        [self paySuccess];
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
    
}

-(void)gotSchemeScorePayment:(BOOL)isSuccess  errorMsg:(NSString *)msg{
    if (isSuccess) {
        [self paySuccess];
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}



@end
