//
//  GroupViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/6/2.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "GroupViewController.h"
#import "AgentInfoModel.h"
#import "GAStatusViewController.h"
#import "GroupApplyInfoViewController.h"


@interface GroupViewController ()<AgentManagerDelegate>{
    CAGradientLayer *gradientLayer;
    
}

@property (weak, nonatomic) IBOutlet UIView *theView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScrollBackGround];
    if (self.agentMan == nil) {
        self.agentMan = [[AgentManager alloc]init];
    }
    self.agentMan.delegate = self;
//    self.
    // Do any additional setup after loading the view from its nib.
}

//实现背景渐变
- (void)setScrollBackGround {
    //初始化我们需要改变背景色的UIView，并添加在视图上
    
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(self.theView.mj_x, self.theView.mj_y, KscreenWidth, self.theView.mj_size.height);
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.theView.layer insertSublayer:gradientLayer atIndex:0];
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

- (IBAction)applyForGroup:(id)sender {
    NSDictionary *dic;
    dic = @{@"cardCode":self.curUser.cardCode};
    [self.agentMan getAgentInfo:dic];
}

-(void )getAgentInfodelegate:(NSDictionary *)param isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (param == nil) {
        [self showPromptViewWithText:msg hideAfter:1];
        return;
    }
    NSString *agentStatus = [param objectForKey:@"agentStatus"];
    
    if ([agentStatus isEqualToString:@"NOT_AGENT"]) {
        GroupApplyInfoViewController *applyInfoVC =  [[GroupApplyInfoViewController alloc]init];
        applyInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:applyInfoVC animated:YES];
    }
    else {
        GAStatusViewController *statusVC = [[GAStatusViewController alloc]init];
        statusVC.hidesBottomBarWhenPushed = YES;
        statusVC.agentStatus = agentStatus;
        [self.navigationController pushViewController:statusVC animated:YES];
    }
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
