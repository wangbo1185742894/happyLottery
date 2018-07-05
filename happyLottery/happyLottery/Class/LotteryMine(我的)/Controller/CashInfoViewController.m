//
//  CashInfoViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/7/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "CashInfoViewController.h"
#import "ClassListCellViewController.h"
#import "WBMenu.h"
@interface CashInfoViewController ()
@property(nonatomic,strong)WBMenu *topMenu;
@end

@implementation CashInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       _topMenu = [[WBMenu alloc]initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44)];
    NSArray *titleArray = @[@"购彩",@"充值",@"派奖",@"提现",@"彩金",@"佣金",@"返佣"];
    [_topMenu createMenuView:titleArray size:CGSizeMake(70, 30)];
    for (int i = 0; i < titleArray.count ; i ++) {
        ClassListCellViewController * classListVC = [[ClassListCellViewController alloc]init];
        classListVC.navVC = self;
        [_topMenu addViewController:classListVC atIndex:i];
    }
    [self.view addSubview:_topMenu];
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
