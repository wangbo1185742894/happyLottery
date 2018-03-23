//
//  PaySuccessViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/27.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "DLTSchemeDetailViewController.h"
#import "SchemeDetailViewController.h"
#import "MyOrderListViewController.h"
#import "CTZQSchemeDetailViewController.h"
#import "GYJSchemeDetailViewController.h"

@interface PaySuccessViewController ()

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约支付";
    
    if (self.isMoni) {
        self.labChuPiaoimg.text = @"";
    }else{
        self.labChuPiaoimg.text = @"正在出票，祝您好运连连";
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionLookOrder:(id)sender {
    MyOrderListViewController *myOrderListVC = [[MyOrderListViewController alloc]init];
    NSMutableArray * vcS = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    [vcS addObject:myOrderListVC];
    self.navigationController.viewControllers = vcS;
    if ([self.lotteryName isEqualToString:@"胜负14场"] || [self.lotteryName isEqualToString:@"任选9场"]) {
        CTZQSchemeDetailViewController *schemeVC = [[CTZQSchemeDetailViewController alloc]init];
        schemeVC.schemeNO = self.schemeNO;
        
        
        [self.navigationController pushViewController:schemeVC animated:YES];
    }else if([self.lotteryName isEqualToString:@"大乐透"]){
        DLTSchemeDetailViewController *schemeVC = [[DLTSchemeDetailViewController alloc]init];
        schemeVC.schemeNO = self.schemeNO;
        [self.navigationController pushViewController:schemeVC animated:YES];
    }else if ([self.lotteryName isEqualToString:@"冠军"] || [self.lotteryName isEqualToString:@"冠亚军"]){
        GYJSchemeDetailViewController *schemeVC = [[GYJSchemeDetailViewController alloc]init];
        schemeVC.schemeNO = self.schemeNO;
        [self.navigationController pushViewController:schemeVC animated:YES];
    }
    else
    {
        SchemeDetailViewController *schemeVC = [[SchemeDetailViewController alloc]init];
        schemeVC.schemeNO = self.schemeNO;
        [self.navigationController pushViewController:schemeVC animated:YES];
    }

}
- (IBAction)actionBackHome:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)navigationBackToLastPage{
    [self.navigationController popToRootViewControllerAnimated:YES];

}

@end
