//
//  FirstBankCardSetViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/19.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//首次设置银行卡

#import "FirstBankCardSetViewController.h"

@interface FirstBankCardSetViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *getBankBtn;
@property (weak, nonatomic) IBOutlet UITextField *bankCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation FirstBankCardSetViewController
@synthesize titleStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = titleStr;
    if ([self isIphoneX]) {
        
        self.top.constant = 88;
        
    }
}
- (IBAction)getBankClick:(id)sender {
}

- (IBAction)commitBtnClick:(id)sender {
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
