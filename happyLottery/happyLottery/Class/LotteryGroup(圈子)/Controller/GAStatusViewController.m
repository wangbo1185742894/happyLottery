//
//  GAStatusViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/6/2.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "GAStatusViewController.h"
#import "GroupApplyInfoViewController.h"

@interface GAStatusViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIImageView *statusleftImage;

@property (weak, nonatomic) IBOutlet UIImageView *statusRightImage;
@property (weak, nonatomic) IBOutlet UILabel *failurLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *waitImage;
@property (weak, nonatomic) IBOutlet UIImageView *waitImageRight;

@property (weak, nonatomic) IBOutlet UILabel *waitLabel;
@property (weak, nonatomic) IBOutlet UIButton *applayAgainBtn;
@end

@implementation GAStatusViewController{
    
    CAGradientLayer *gradientLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.leftBarButtonItem = nil;
//    self.navigationItem.hidesBackButton = YES;
    [self setScrollBackGround];
    self.title = @"审核状态";
    if ([self.agentStatus isEqualToString:@"AGENT_APPLYING"]) {
        self.statusLabel.text = @"审核中";
        self.waitImage.hidden = NO;
        self.waitImageRight.hidden = NO;
        self.statusleftImage.hidden = YES;
        self.statusRightImage.hidden = YES;
        self.failurLabel.hidden = YES;
        self.waitLabel.hidden = NO;
        self.applayAgainBtn.hidden = YES;
    } else {
        self.statusLabel.text = @"审核失败";
        self.waitImage.hidden = YES;
        self.waitImageRight.hidden = YES;
        self.statusleftImage.hidden = NO;
        self.statusRightImage.hidden = NO;
        self.failurLabel.hidden = NO;
        self.waitLabel.hidden = YES;
        self.applayAgainBtn.hidden = NO;
    }
    
    // Do any additional setup after loading the view from its nib.
}

//实现背景渐变
- (void)setScrollBackGround {
    //初始化我们需要改变背景色的UIView，并添加在视图上
    
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(self.contentView.mj_x, self.contentView.mj_y, KscreenWidth, KscreenHeight);
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.contentView.layer insertSublayer:gradientLayer atIndex:0];
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)RGBCOLOR(35, 51, 94).CGColor,
                             (__bridge id)RGBCOLOR(18, 199, 146).CGColor];
    //设置颜色分割点（范围：0-1）
    //    gradientLayer.locations = @[@(0.3f),@(0.5f), @(0.7f),@(1.0f)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationBackToLastPage{
    AppDelegate *delegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate setGroupView];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//重新申请
- (IBAction)actionToApplyAgain:(id)sender {
    GroupApplyInfoViewController *applyInfoVC =  [[GroupApplyInfoViewController alloc]init];
    [self.navigationController pushViewController:applyInfoVC animated:YES];
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
