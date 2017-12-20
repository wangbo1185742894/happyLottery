//
//  SetPayPWDViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/20.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//首次设置

#import "SetPayPWDViewController.h"

@interface SetPayPWDViewController ()<MemberManagerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *payPWDTextField;
@property (weak, nonatomic) IBOutlet UITextField *payPWDAgainTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;


@end

@implementation SetPayPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置支付密码";
    if ([self isIphoneX]) {
        self.top.constant = 88;
      
    }
    self.memberMan.delegate = self;
    self.mobileTextField.delegate = self;
    self.payPWDTextField.delegate = self;
    self.payPWDAgainTextField.delegate = self;
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
