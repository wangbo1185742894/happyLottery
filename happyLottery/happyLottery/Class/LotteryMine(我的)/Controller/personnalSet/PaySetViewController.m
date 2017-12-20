//
//  PaySetViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/19.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "PaySetViewController.h"

@interface PaySetViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *switch1;
@property (weak, nonatomic) IBOutlet UISwitch *switch2;
@property (weak, nonatomic) IBOutlet UISwitch *switch3;
@property (weak, nonatomic) IBOutlet UISwitch *switch4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

@implementation PaySetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付设置";
    if ([self isIphoneX]) {
        self.top.constant = 88;
        
    }
}
- (IBAction)switch1Chose:(id)sender {
}
- (IBAction)switch2Chose:(id)sender {
    if (self.switch2.on==YES) {
        self.curUser.payPWDThreshold = 100;
        self.switch3.on=NO;
        self.switch4.on=NO;
    }
    
}
- (IBAction)switch3Chose:(id)sender {
    if (self.switch2.on==YES) {
        self.curUser.payPWDThreshold = 500;
        self.switch2.on=NO;
        self.switch4.on=NO;
    }
   
}
- (IBAction)switch4Chose:(id)sender {
    if (self.switch2.on==YES) {
        self.curUser.payPWDThreshold = 1000;
        self.switch3.on=NO;
        self.switch2.on=NO;
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
