//
//  RuZhangViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/5.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "RuZhangViewController.h"
#import "ZhuangZhangListVC.h"

@interface RuZhangViewController ()<AgentManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfJine;
@property (weak, nonatomic) IBOutlet UILabel *labInfo;

@property (weak, nonatomic) IBOutlet UILabel *labYue;
@end

@implementation RuZhangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.agentMan.delegate = self;
    self.title = @"入账余额";
    self.labYue.text = [NSString stringWithFormat:@"佣金余额  %@",self.agentInfo.commission];
    self.labInfo.text = @"注意：\n1:每周一可提现至余额，其他时间不可提现。\n2:余额账户到账时间在2小时。\n3:提现金额超过2000元，需财务审核通过即可转入余额账户";
    UIBarButtonItem *faqi = [self creatBarItem:@"" icon:@"icon_shezhi" andFrame:CGRectMake(0, 10, 30, 30) andAction:@selector(optionRightButtonAction)];
    self.navigationItem.rightBarButtonItems = @[faqi];
}

-(void)optionRightButtonAction{
    ZhuangZhangListVC *listVC = [[ZhuangZhangListVC alloc]init];
    listVC.model = self.agentInfo;
    [self.navigationController pushViewController:listVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionTixian:(id)sender {
    if ([self.tfJine.text doubleValue] == 0) {
        [self showPromptViewWithText:@"请输入金额" hideAfter:1.8];
        return;
    }
    [self.agentMan transferAccount:@{@"agentId":self.agentInfo._id,@"cardCode":self.agentInfo.cardCode,@"transferCost":self.tfJine.text}];
}

-(void)transferAccountdelegate:(NSString *)string isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (success == NO) {
        [self showPromptViewWithText:msg hideAfter:1.8];
        return;
    }else{
        [self showPromptViewWithText:@"转账成功" hideAfter:1.8];
        return;
    }
}


@end
