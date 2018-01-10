//
//  GetIntegralViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/1/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "GetIntegralViewController.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"

@interface GetIntegralViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

@implementation GetIntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分获取";
    if ([self isIphoneX]) {
        self.top.constant = 88;
    }
     [UILabel changeLineSpaceForLabel:self.label WithSpace:7.0];
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
