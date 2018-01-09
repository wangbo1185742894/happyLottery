//
//  PaySuccessViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/27.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "SchemeDetailViewController.h"

@interface PaySuccessViewController ()

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约支付";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionLookOrder:(id)sender {
    SchemeDetailViewController *schemeVC = [[SchemeDetailViewController alloc]init];
    schemeVC.schemeNO = self.schemeNO;
    [self.navigationController pushViewController:schemeVC animated:YES];
}
- (IBAction)actionBackHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)navigationBackToLastPage{
    [self.navigationController popToRootViewControllerAnimated:YES];

}

@end
