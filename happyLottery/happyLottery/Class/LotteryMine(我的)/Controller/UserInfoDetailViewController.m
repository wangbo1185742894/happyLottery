//
//  UserInfoDetailViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/7/6.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "UserInfoDetailViewController.h"
#import "MGLabel.h"

@interface UserInfoDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labLeft;
@property (weak, nonatomic) IBOutlet MGLabel *labRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;

@end

@implementation UserInfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topDis.constant = NaviHeight;
    self.title = @"明细详情";

    self.labLeft .text = [self.model getLeftTitle];
    self.labRight.text = [self.model getRightTitle];
    NSArray *keyList = [[self.model getRightTitle] componentsSeparatedByString:@" "];
    if (keyList.count > 2) {
        self.labRight.keyWord = keyList[2];
        self.labRight.keyWordColor = SystemGreen;
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

