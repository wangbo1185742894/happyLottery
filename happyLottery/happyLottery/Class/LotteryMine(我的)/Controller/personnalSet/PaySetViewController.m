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

@interface PaySetViewController (){
      PayVerifyType verifyType;
    
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
    [self updateSwitchStatus];
}

-(void)updateSwitchStatus{
   
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

- (IBAction)switch1Chose:(id)sender {
   self.switch1.on=YES;
    if (self.switch1.on==YES) {
        self.curUser.payPWDThreshold = 100;
        self.switch2.on=NO;
        self.switch3.on=NO;
        self.switch4.on=NO;
        self.mianMiSwitch.on=NO;
        verifyType = PayVerifyTypeAlwaysNo;
        self.curUser.payVerifyType = [NSNumber numberWithInt:verifyType];
        [self savePayVerifyType];
    }
}
- (IBAction)switch2Chose:(id)sender {
    self.switch2.on=YES;
    if (self.switch2.on==YES) {
        self.curUser.payPWDThreshold = 100;
        self.switch1.on=NO;
        self.switch3.on=NO;
        self.switch4.on=NO;
        self.mianMiSwitch.on=NO;
        verifyType = PayVerifyTypeLessThanOneHundred;
        self.curUser.payVerifyType = [NSNumber numberWithInt:verifyType];
        [self savePayVerifyType];
    }
    
}
- (IBAction)switch3Chose:(id)sender {
    self.switch3.on=YES;
    if (self.switch3.on==YES) {
        self.curUser.payPWDThreshold = 500;
        self.switch1.on=NO;
        self.switch2.on=NO;
        self.switch4.on=NO;
        self.mianMiSwitch.on=NO;
        verifyType = PayVerifyTypeLessThanFiveHundred;
        self.curUser.payVerifyType = [NSNumber numberWithInt:verifyType];
        [self savePayVerifyType];
    }
   
}
- (IBAction)switch4Chose:(id)sender {
    self.switch4.on=YES;
    if (self.switch4.on==YES) {
        self.curUser.payPWDThreshold = 1000;
        self.switch3.on=NO;
        self.switch2.on=NO;
        self.switch1.on=NO;
        self.mianMiSwitch.on=NO;
        verifyType = PayVerifyTypeLessThanThousand;
        self.curUser.payVerifyType = [NSNumber numberWithInt:verifyType];
        [self savePayVerifyType];
    }
  
}
- (IBAction)mianMiSwitch:(id)sender {
    self.mianMiSwitch.on=YES;
    if (self.mianMiSwitch.on==YES) {
        self.curUser.payPWDThreshold = 0;
        self.switch4.on=NO;
        self.switch3.on=NO;
        self.switch2.on=NO;
        self.switch1.on=NO;
        verifyType = PayVerifyTypeAlways;
        self.curUser.payVerifyType = [NSNumber numberWithInt:verifyType];
        [self savePayVerifyType];
    }
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
