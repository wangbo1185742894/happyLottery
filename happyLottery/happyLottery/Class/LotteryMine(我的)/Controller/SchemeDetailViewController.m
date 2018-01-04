//
//  SchemeDetailViewController.m
//  happyLottery
//
//  Created by 王博 on 2018/1/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SchemeDetailViewController.h"
#import "JCLQOrderDetailInfoViewController.h"

@interface SchemeDetailViewController ()
{
    
    __weak IBOutlet UITableView *tabSchemeDetailList;
}
@end

@implementation SchemeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)loadData{

    
}

- (IBAction)actionOrderDetail:(UIButton *)sender {
    JCLQOrderDetailInfoViewController *orderDetailVC = [[JCLQOrderDetailInfoViewController alloc]init];
    orderDetailVC.schemeNO = self.schemeNO;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

- (IBAction)actionGotoTouzhu:(id)sender {
    
}
@end
