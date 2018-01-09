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

@interface PaySetViewController ()<WBInputPopViewDelegate,MemberManagerDelegate>{
      PayVerifyType verifyType;
      WBInputPopView *passInput;
}
@property (weak, nonatomic) IBOutlet UISwitch *switch1;
@property (weak, nonatomic) IBOutlet UISwitch *switch2;
@property (weak, nonatomic) IBOutlet UISwitch *switch3;
@property (weak, nonatomic) IBOutlet UISwitch *switch4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UISwitch *mianMiSwitch;

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
   
        int payVerifyType = [self.curUser.payVerifyType intValue];
        if (payVerifyType == PayVerifyTypeLessThanOneHundred) {
            self.switch2.on=YES;
        } else  if (payVerifyType == PayVerifyTypeLessThanFiveHundred){
            self.switch3.on=YES;
        }else  if (payVerifyType == PayVerifyTypeLessThanThousand){
             self.switch4.on=YES;
        }else  if (payVerifyType == PayVerifyTypeAlways){
                self.mianMiSwitch.on=YES;
        }else  if (payVerifyType == PayVerifyTypeAlwaysNo){
            self.switch1.on=YES;
        }
 
    
}

-(void)updateSwitchStatus{
    if (verifyType == PayVerifyTypeLessThanOneHundred) {
        self.switch2.on=YES;
        self.curUser.payPWDThreshold = 100;
        self.switch1.on=NO;
        self.switch3.on=NO;
        self.switch4.on=NO;
        self.mianMiSwitch.on=NO;
    } else  if (verifyType == PayVerifyTypeLessThanFiveHundred){
        self.switch3.on=YES;
        self.curUser.payPWDThreshold = 500;
        self.switch1.on=NO;
        self.switch2.on=NO;
        self.switch4.on=NO;
        self.mianMiSwitch.on=NO;
    }else  if (verifyType == PayVerifyTypeLessThanThousand){
        self.switch4.on=YES;
        self.curUser.payPWDThreshold = 1000;
        self.switch3.on=NO;
        self.switch2.on=NO;
        self.switch1.on=NO;
        self.mianMiSwitch.on=NO;
    }else  if (verifyType == PayVerifyTypeAlways){
        self.mianMiSwitch.on=YES;
        self.curUser.payPWDThreshold = 0;
        self.switch4.on=NO;
        self.switch3.on=NO;
        self.switch2.on=NO;
        self.switch1.on=NO;
    }else  if (verifyType == PayVerifyTypeAlwaysNo){
        self.switch1.on=YES;
        self.curUser.payPWDThreshold = 100;
        self.switch2.on=NO;
        self.switch3.on=NO;
        self.switch4.on=NO;
        self.mianMiSwitch.on=NO;
        
    }
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
        
        if (nil == passInput) {
            [self showPromptText:@"请输入支付密码" hideAfterDelay:2.7];
            return;
        }
        
        NSDictionary *cardInfo= @{@"cardCode":self.curUser.cardCode,
                                  @"payPwd":[AESUtility encryptStr:text]};
        [self.memberMan validatePaypwdSms:cardInfo];
        
      
    }];
    
}


-(void)validatePaypwdSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText:@"支付密码验证成功" hideAfterDelay:1.7];
       [passInput removeFromSuperview];
        [self updateSwitchStatus];
    }else{
         [passInput removeFromSuperview];
        [self showPromptText:msg hideAfterDelay:1.7];
        
    }
}

- (IBAction)switch1Chose:(id)sender {
    verifyType = PayVerifyTypeAlwaysNo;
    self.curUser.payVerifyType = [NSNumber numberWithInt:verifyType];
    [self savePayVerifyType];
    [self showPayPopView];
    self.switch1.on=NO;
}
- (IBAction)switch2Chose:(id)sender {
    verifyType = PayVerifyTypeLessThanOneHundred;
    self.curUser.payVerifyType = [NSNumber numberWithInt:verifyType];
    [self savePayVerifyType];
      [self showPayPopView];
    self.switch2.on=NO;
}
- (IBAction)switch3Chose:(id)sender {
    verifyType = PayVerifyTypeLessThanFiveHundred;
    self.curUser.payVerifyType = [NSNumber numberWithInt:verifyType];
    [self savePayVerifyType];
     [self showPayPopView];
   self.switch3.on=NO;
}
- (IBAction)switch4Chose:(id)sender {
    verifyType = PayVerifyTypeLessThanThousand;
    self.curUser.payVerifyType = [NSNumber numberWithInt:verifyType];
    [self savePayVerifyType];
     [self showPayPopView];
  self.switch4.on=NO;
}
- (IBAction)mianMiSwitch:(id)sender {
    verifyType = PayVerifyTypeAlways;
    self.curUser.payVerifyType = [NSNumber numberWithInt:verifyType];
    [self savePayVerifyType];
    [self showPayPopView];
    self.mianMiSwitch.on=NO;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
