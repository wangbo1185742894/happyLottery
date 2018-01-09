//
//  ConversionCodeViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/1/5.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "ConversionCodeViewController.h"

@interface ConversionCodeViewController ()

@end

@implementation ConversionCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐码";
    if ([self isIphoneX]) {
//        self.top.constant = 88;
//        self.bottom.constant = 34;
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
