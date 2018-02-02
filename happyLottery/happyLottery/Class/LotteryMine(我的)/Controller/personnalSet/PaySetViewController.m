//
//  PaySetViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/19.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//PayVerifyTypeAlways =1,
//PayVerifyTypeAlwaysNo,
//PayVerifyTypeLessThanOneHundred,
//PayVerifyTypeLessThanFiveHundred,
//PayVerifyTypeLessThanThousand,

#import "PaySetViewController.h"
#import "WBInputPopView.h"
#import "BankCard.h"
#import "AESUtility.h"
#import "SetPayPWDViewController.h"

@interface PaySetViewController ()<WBInputPopViewDelegate,MemberManagerDelegate>{
      PayVerifyType verifyType;
      WBInputPopView *passInput;
      UIButton *selectSwi;
}


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UIButton *payNeedPwdAlways;
@property (weak, nonatomic) IBOutlet UIButton *payNeedPwdNo;

@property (weak, nonatomic) IBOutlet UIButton *payNeedPwdOneH;
@property (weak, nonatomic) IBOutlet UIButton *payNeedPwdFiveH;
@property (weak, nonatomic) IBOutlet UIButton *payNeedPwdOneThousand;

@end

@implementation PaySetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付设置";
    
    if ([self isIphoneX]) {
        self.top.constant = 88;
    }
    
    self.memberMan.delegate=self;
    [self initSwitchStatus];
}


-(void)initSwitchStatus{
   
        int payVerifyType = self.curUser.payVerifyType;
        if (payVerifyType == PayVerifyTypeLessThanOneHundred) {
            self.payNeedPwdOneH.selected=YES;
        } else  if (payVerifyType == PayVerifyTypeLessThanFiveHundred){
            self.payNeedPwdFiveH.selected=YES;
        }else  if (payVerifyType == PayVerifyTypeLessThanThousand){
             self.payNeedPwdOneThousand.selected=YES;
        }else  if (payVerifyType == PayVerifyTypeAlwaysNo){
                self.payNeedPwdNo.selected=YES;
        }else  if (payVerifyType == PayVerifyTypeAlways){
            self.payNeedPwdAlways.selected=YES;
        }
 
    
}

-(void)updateSwitchStatus{
    if (verifyType == PayVerifyTypeLessThanOneHundred) {
        [self setSwitchState:self.payNeedPwdOneH];
    } else  if (verifyType == PayVerifyTypeLessThanFiveHundred){
        [self setSwitchState:self.payNeedPwdFiveH];
    }else  if (verifyType == PayVerifyTypeLessThanThousand){
        [self setSwitchState:self.payNeedPwdOneThousand];
    }else  if (verifyType == PayVerifyTypeAlways){
        [self setSwitchState:self.payNeedPwdAlways];
    }else  if (verifyType == PayVerifyTypeAlwaysNo){
        [self setSwitchState:self.payNeedPwdNo];
    }
}

-(void)setSwitchState:(UIButton  *)switc{
    self.payNeedPwdAlways.selected=NO;
    self.payNeedPwdNo.selected=NO;
    self.payNeedPwdOneH.selected=NO;
    self.payNeedPwdFiveH.selected=NO;
    self.payNeedPwdOneThousand.selected=NO;
    switc.selected = YES;
}

- (void)showPayPopView{
    if (nil == passInput) {
        //        popInputView = [[PopInputView alloc] initWithFrame:self.navigationController.view.bounds];
        //        popInputView.delegate = self;
        //        popInputView.popViewResource = @"zhifu";
        
        passInput = [[WBInputPopView alloc]init];
        passInput.delegate = self;
        passInput.labTitle.text = @"请输入支付密码";
        
        
    }
    //    [popInputView showInView:self.navigationController.view withTitle:TextComfirmPayPwdForPay tfPlaceHolder:TextPasswrodRule];
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


-(void)validatePaypwdSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
     [passInput removeFromSuperview];
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText:@"支付密码验证成功" hideAfterDelay:1.7];
        
        [self updateSwitchStatus];
        [self savePayVerifyType];
        [self setSwitchState:selectSwi];
    }else{
        
        [self showPromptText:msg hideAfterDelay:1.7];
        
    }
}


- (IBAction)btnSelectPayType:(UIButton*)sender {
    
    if (sender.selected == YES) {
        return;
    }
    
    if(self.curUser.paypwdSetting == NO) {
        SetPayPWDViewController *spvc = [[SetPayPWDViewController alloc]init];
        spvc.titleStr = @"设置支付密码";
        [self.navigationController pushViewController:spvc animated:YES];
        return;
    }
    
    selectSwi = (UIButton*)sender;
    verifyType = (PayVerifyType)sender.tag - 100;
    [self showPayPopView];
}


-(void)savePayVerifyType{
    
    if ([self.fmdb open]) {
        NSString *mobile =self.curUser.mobile;
        NSString * verify = [NSString stringWithFormat:@"%d", verifyType];
        //update t_student set score = age where name = ‘jack’ ;
        [self.fmdb executeUpdate:@"update  t_user_info set payVerifyType = ? where mobile = ?",verify, mobile];
        [self.fmdb close];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)findPayPwd{
    [self forgetPayPwd];
}


@end
