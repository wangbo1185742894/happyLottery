//
//  MyHelpViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/12.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//  帮助


#import "MyHelpViewController.h"
#import "CouponGuidViewController.h"
#import "GetIntegralViewController.h"
#import "FootBallPlayViewController.h"
#import "QuestionsViewController.h"
#import "FunctionsViewController.h"
#import "IntegeralChangeViewController.h"

@interface MyHelpViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerview;

@end

@implementation MyHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助";
    self.viewControllerNo = @"A207";
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
}

- (IBAction)footballPlay:(id)sender {
    FootBallPlayViewController * mpVC = [[FootBallPlayViewController alloc]init];
    [self.navigationController pushViewController:mpVC animated:YES];
}

- (IBAction)getIntegral:(id)sender {
  
    GetIntegralViewController * mpVC = [[GetIntegralViewController alloc]init];
    [self.navigationController pushViewController:mpVC animated:YES];
}
- (IBAction)integralChange:(id)sender {
    IntegeralChangeViewController * mpVC = [[IntegeralChangeViewController alloc]init];
    [self.navigationController pushViewController:mpVC animated:YES];
}
//功能指南
- (IBAction)FunctionalGuide:(id)sender {
    FunctionsViewController * mpVC = [[FunctionsViewController alloc]init];
    [self.navigationController pushViewController:mpVC animated:YES];
}

//优惠券指南

- (IBAction)CouponGuide:(id)sender {
    CouponGuidViewController * mpVC = [[CouponGuidViewController alloc]init];
    [self.navigationController pushViewController:mpVC animated:YES];
}

- (IBAction)question:(id)sender {
    QuestionsViewController * mpVC = [[QuestionsViewController alloc]init];
    [self.navigationController pushViewController:mpVC animated:YES];
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
