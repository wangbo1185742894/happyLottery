//
//  RuZhangViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/5.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "RuZhangViewController.h"
#import "ZhuangZhangListVC.h"

@interface RuZhangViewController ()<AgentManagerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfJine;
@property (weak, nonatomic) IBOutlet UILabel *labInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnTixian;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;

@property (weak, nonatomic) IBOutlet UILabel *labYue;
@end

@implementation RuZhangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topDis.constant = NaviHeight + 8;
    self.tfJine.delegate = self;
    self.agentMan.delegate = self;
    [self.btnTixian setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(90, 212, 176)] forState:UIControlStateDisabled];
      [self.btnTixian setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:0];
    self.btnTixian.enabled = NO;
    self.title = @"入账记录";
    self.labYue.text = [NSString stringWithFormat:@"佣金余额  %.2f元",[self.agentInfo.commission doubleValue]];
    self.labInfo.text = @"注意：\n1:每周一可提现至余额，其他时间不可提现。\n2:余额账户到账时间在2小时。\n3:提现金额超过2000元，需财务审核通过即可转入余额账户";
    UIBarButtonItem *faqi = [self creatBarItem:@"" icon:@"icon_history" andFrame:CGRectMake(0, 10, 30, 30) andAction:@selector(optionRightButtonAction)];
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
    [self showLoadingText:@"正在加载"];
    [self.agentMan transferAccount:@{@"agentId":self.agentInfo._id,@"cardCode":self.agentInfo.cardCode,@"transferCost":self.tfJine.text}];
}

-(void)transferAccountdelegate:(NSString *)string isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (success == NO) {
        [self showPromptViewWithText:msg hideAfter:1.8];
        return;
    }else{
        [self hideLoadingView];
        self.tfJine.text = @"";
        [self showPromptViewWithText:@"转账成功" hideAfter:1.8];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        return;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.location == 10) {
        return NO;
    }
    if ([string isEqualToString:@""]) {
        [self updataBtnState:textField];
        return YES;
    }
    
    NSString * regex;
    regex = @"^[0-9.]";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    if (isMatch) {
        NSString *stringRegex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,4}(([.]\\d{0,2})?)))?";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
        BOOL isMatch1 = [pred1 evaluateWithObject:[NSString stringWithFormat:@"%@%@",textField.text,string]];
        
        
        if (isMatch1 == YES) {
            [self updataBtnState:textField];
            return YES;
        }else{
            return NO;
        }
    }else{
        
        return NO;
    }
    
}

-(void)updataBtnState:(UITextField *)title{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([title.text doubleValue] > [self.agentInfo.commission doubleValue] || [title.text doubleValue] == 0) {
            self.btnTixian.enabled = NO;
        }else{
            self.btnTixian.enabled = YES;
        }
    });
}

@end
