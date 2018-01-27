//
//  PaySuccessViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/27.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "SchemeDetailViewController.h"
#import "MyOrderListViewController.h"

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
    MyOrderListViewController *myOrderListVC = [[MyOrderListViewController alloc]init];
    NSMutableArray * vcS = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    [vcS addObject:myOrderListVC];
    self.navigationController.viewControllers = vcS;
    [self.navigationController pushViewController:schemeVC animated:YES];
}
- (IBAction)actionBackHome:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)navigationBackToLastPage{
    [self.navigationController popToRootViewControllerAnimated:YES];

}

@end
