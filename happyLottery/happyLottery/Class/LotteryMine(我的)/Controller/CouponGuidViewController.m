//
//  CouponGuidViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/1/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "CouponGuidViewController.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"

@interface CouponGuidViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation CouponGuidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠券指南";
    if ([self isIphoneX]) {
        self.top.constant = 88;
    }
   [UILabel changeLineSpaceForLabel:self.label WithSpace:5.0];
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
