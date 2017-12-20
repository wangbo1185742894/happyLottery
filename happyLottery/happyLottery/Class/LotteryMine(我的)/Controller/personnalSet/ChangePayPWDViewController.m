//
//  ChangePayPWDViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/20.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "ChangePayPWDViewController.h"

@interface ChangePayPWDViewController ()<MemberManagerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UITextField *PWD1;
@property (weak, nonatomic) IBOutlet UITextField *PWD2;
@property (weak, nonatomic) IBOutlet UITextField *PWD3;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;

@end

@implementation ChangePayPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改支付密码";
    if ([self isIphoneX]) {
        self.top.constant = 88;
    }
    
    self.memberMan.delegate = self;
    self.PWD1.delegate = self;
    self.PWD2.delegate = self;
    self.PWD3.delegate = self;
}
- (IBAction)commitBtnClick:(id)sender {
    
}
- (IBAction)forgetBtnClick:(id)sender {
    
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
