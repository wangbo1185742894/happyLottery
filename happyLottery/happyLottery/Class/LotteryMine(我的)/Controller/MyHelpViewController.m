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
#import "LotteryInstructionDetailViewController.h"
#import "WebViewController.h"

@interface MyHelpViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;

@end

@implementation MyHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助";
    self.viewControllerNo = @"A207";
    if ([self isIphoneX]) {
        self.top.constant = 24;
       
    }
    self.height.constant = 770;
}

- (IBAction)footballPlay:(id)sender {
    FootBallPlayViewController * mpVC = [[FootBallPlayViewController alloc]init];
    [self.navigationController pushViewController:mpVC animated:YES];
}
- (IBAction)actionJclqPlay:(id)sender {
    NSArray *infoArr = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"LotteryInstructionConfig" ofType: @"plist"]];
    NSDictionary *infoDic = infoArr[7];
    LotteryInstructionDetailViewController *detailVC = [[LotteryInstructionDetailViewController alloc] initWithNibName: @"LotteryInstructionDetailViewController" bundle: nil];
    detailVC.lotteryDetailDic = infoDic;
    [self.navigationController pushViewController: detailVC animated: YES];
}
- (IBAction)actionSSQPlay:(id)sender {
    WebViewController *webVC = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    webVC.type = @"html";
    webVC.title = @"双色球玩法规则";
    webVC.htmlName = @"ssq_play";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)getIntegral:(id)sender {
  
    GetIntegralViewController * mpVC = [[GetIntegralViewController alloc]init];
    [self.navigationController pushViewController:mpVC animated:YES];
}
- (IBAction)integralChange:(id)sender {
    IntegeralChangeViewController * mpVC = [[IntegeralChangeViewController alloc]init];
    [self.navigationController pushViewController:mpVC animated:YES];
}
- (IBAction)actionSFC:(UIButton *)sender {
    NSArray *infoArr = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"LotteryInstructionConfig" ofType: @"plist"]];
    NSDictionary *infoDic = infoArr[6];
    LotteryInstructionDetailViewController *detailVC = [[LotteryInstructionDetailViewController alloc] initWithNibName: @"LotteryInstructionDetailViewController" bundle: nil];
    detailVC.lotteryDetailDic = infoDic;
    [self.navigationController pushViewController: detailVC animated: YES];
}
- (IBAction)actionDLT:(UIButton *)sender {
    
    NSArray *infoArr = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"LotteryInstructionConfig" ofType: @"plist"]];
    NSDictionary *infoDic = infoArr[2];;
    
    LotteryInstructionDetailViewController *detailVC = [[LotteryInstructionDetailViewController alloc] initWithNibName: @"LotteryInstructionDetailViewController" bundle: nil];
    detailVC.lotteryDetailDic = infoDic;
    [self.navigationController pushViewController: detailVC animated: YES];
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
- (IBAction)actionTel:(UIButton *)sender {
    [self actionTelMe];
}
@end
