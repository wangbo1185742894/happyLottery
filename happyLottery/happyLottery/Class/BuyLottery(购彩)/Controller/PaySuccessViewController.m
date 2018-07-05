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
#import "JCLQSchemeDetailViewController.h"
#import "MyPostSchemeViewController.h"
#import "FASSchemeDetailViewController.h"
#import "LotteryPlayViewController.h"



#import "DLTPlayViewController.h"
#import "SSQPlayViewController.h"
#import "JCZQPlayViewController.h"
#import "CTZQPlayViewController.h"
#import "JCLQPlayController.h"
#import "GYJPlayViewController.h"
#import "PersonCenterViewController.h"
#import "MyNoticeViewController.h"
#import "FollowSendViewController.h"
#import "SearchViewController.h"
#import "UMChongZhiViewController.h"
#import "YuCeSchemeCreateViewController.h"
#import "GroupFollowViewController.h"

@interface PaySuccessViewController ()<LotteryManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnPostScheme;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeightPostScheme;
@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约支付";
    if (self.schemetype == SchemeTypeGenDan ||self.schemetype == SchemeTypeFaqiGenDan) {
         self.btnHeightPostScheme.constant = 0;
    }else if(self.isShowFaDan){
        self.btnHeightPostScheme.constant = 44;
    }else{
        self.btnHeightPostScheme.constant = 0;
    }
    self.lotteryMan.delegate = self;
    if (self.isMoni) {
        self.labChuPiaoimg.text = @"";
    }else{
        self.labChuPiaoimg.text = @"正在出票，祝您好运连连";
    }
    if ([Utility isIOS11After]) {
        self.automaticallyAdjustsScrollViewInsets = NO; // tableView 莫名其妙  contentOffset.y 成-64了  MMP
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionLookOrder:(id)sender {
   
    if (self.schemetype == SchemeTypeGenDan) {
        MyPostSchemeViewController *myOrderListVC = [[MyPostSchemeViewController alloc]init];
        myOrderListVC.isFaDan = NO;
        NSMutableArray * vcS = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [vcS addObject:myOrderListVC];
        self.navigationController.viewControllers = vcS;
        FASSchemeDetailViewController *detailCV = [[FASSchemeDetailViewController alloc]init];
        detailCV.schemeNo = self.schemeNO;
        detailCV.schemeType = @"BUY_FOLLOW";
        [self.navigationController pushViewController:detailCV animated:YES];
    }else if ( self.schemetype == SchemeTypeFaqiGenDan){
        MyPostSchemeViewController *myOrderListVC = [[MyPostSchemeViewController alloc]init];
        myOrderListVC.isFaDan = YES;
        NSMutableArray * vcS = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [vcS addObject:myOrderListVC];
        self.navigationController.viewControllers = vcS;
        FASSchemeDetailViewController *detailCV = [[FASSchemeDetailViewController alloc]init];
        detailCV.schemeNo = self.schemeNO;
        detailCV.schemeType = @"BUY_INITIATE";
        [self.navigationController pushViewController:detailCV animated:YES];
    }else{
        MyOrderListViewController *myOrderListVC = [[MyOrderListViewController alloc]init];
        NSMutableArray * vcS = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [vcS addObject:myOrderListVC];
        self.navigationController.viewControllers = vcS;
        if ([self.lotteryName isEqualToString:@"胜负14场"] || [self.lotteryName isEqualToString:@"任选9场"]) {
            CTZQSchemeDetailViewController *schemeVC = [[CTZQSchemeDetailViewController alloc]init];
            schemeVC.schemeNO = self.schemeNO;
            [self.navigationController pushViewController:schemeVC animated:YES];
        }else if([self.lotteryName isEqualToString:@"大乐透"]||[self.lotteryName isEqualToString:@"双色球"] || [self.lotteryName isEqualToString:@"陕西11选5"] || [self.lotteryName isEqualToString:@"山东11选5"]){
            DLTSchemeDetailViewController *schemeVC = [[DLTSchemeDetailViewController alloc]init];
            schemeVC.schemeNO = self.schemeNO;
            [self.navigationController pushViewController:schemeVC animated:YES];
        }else if ([self.lotteryName isEqualToString:@"冠军"] || [self.lotteryName isEqualToString:@"冠亚军"]){
            GYJSchemeDetailViewController *schemeVC = [[GYJSchemeDetailViewController alloc]init];
            schemeVC.schemeNO = self.schemeNO;
            [self.navigationController pushViewController:schemeVC animated:YES];
        }else if ([self.lotteryName isEqualToString:@"竞彩篮球"]){
            JCLQSchemeDetailViewController *schemeVC = [[JCLQSchemeDetailViewController alloc]init];
            schemeVC.schemeNO = self.schemeNO;
            [self.navigationController pushViewController:schemeVC animated:YES];
        }else{
            SchemeDetailViewController *schemeVC = [[SchemeDetailViewController alloc]init];
            schemeVC.schemeNO = self.schemeNO;
            [self.navigationController pushViewController:schemeVC animated:YES];
        }

    }

}

- (IBAction)actionBackHome:(id)sender {
    [self navigationBackToLastPage];
}

-(void)navigationBackToLastPage{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        NSLog(@"-----%@------",controller);
        if ([controller isKindOfClass:[GYJPlayViewController class]]) {
            GYJPlayViewController *revise =(GYJPlayViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
            return;
        }
        
        if ([controller isKindOfClass:[DLTPlayViewController class]]) {
            DLTPlayViewController *revise =(DLTPlayViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
            return;
        }
        if ([controller isKindOfClass:[SSQPlayViewController class]]) {
            SSQPlayViewController *revise =(SSQPlayViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
            return;
        }
        if ([controller isKindOfClass:[JCZQPlayViewController class]]) {
            JCZQPlayViewController *revise =(JCZQPlayViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:KSELECTMATCHCLEAN object:nil];
            return;
        }
        if ([controller isKindOfClass:[CTZQPlayViewController class]]) {
            CTZQPlayViewController *revise =(CTZQPlayViewController *)controller;
            [[NSNotificationCenter defaultCenter]postNotificationName:KSELECTMATCHCLEAN object:nil];
            [self.navigationController popToViewController:revise animated:YES];
            return;
            
        }
        if ([controller isKindOfClass:[JCLQPlayController class]]) {
            JCLQPlayController *revise =(JCLQPlayController *)controller;
            [[NSNotificationCenter defaultCenter]postNotificationName:KSELECTMATCHCLEAN object:nil];
            [self.navigationController popToViewController:revise animated:YES];
            return;
        }
        if ([controller isKindOfClass:[YuCeSchemeCreateViewController class]]) {
            YuCeSchemeCreateViewController *revise =(YuCeSchemeCreateViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
            return;
        }
        
        if ([controller isKindOfClass:[LotteryPlayViewController class]]) {
            LotteryPlayViewController *revise =(LotteryPlayViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
            return;
        }
        
        if ([controller isKindOfClass:[FollowSendViewController class]]) {
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[PersonCenterViewController class]]) {
                    PersonCenterViewController *revise =(PersonCenterViewController *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                    return;
                }
                if ([controller isKindOfClass:[MyNoticeViewController class]]) {
                    MyNoticeViewController *revise =(MyNoticeViewController *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                    return;
                }
                if ([controller isKindOfClass:[JCZQPlayViewController class]]) {
                    JCZQPlayViewController *revise =(JCZQPlayViewController *)controller;
                    [[NSNotificationCenter defaultCenter]postNotificationName:KSELECTMATCHCLEAN object:nil];
                    [self.navigationController popToViewController:revise animated:YES];
                    return;
                }
                if ([controller isKindOfClass:[JCLQPlayController class]]) {
                    JCLQPlayController *revise =(JCLQPlayController *)controller;
                    [[NSNotificationCenter defaultCenter]postNotificationName:KSELECTMATCHCLEAN object:nil];
                    [self.navigationController popToViewController:revise animated:YES];
                    return;
                }
                if ([controller isKindOfClass:[SearchViewController class]]) {
                    SearchViewController *revise =(SearchViewController *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                    return;
                }
            }
            FollowSendViewController *revise =(FollowSendViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
            return;
        }
        if ([controller isKindOfClass:[MyPostSchemeViewController class]]) {
            MyPostSchemeViewController *revise =(MyPostSchemeViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
            return;
        }
        if ([controller isKindOfClass:[GroupFollowViewController class]]) {
            GroupFollowViewController *revise =(GroupFollowViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
            return;
        }
        
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionPostScheme:(id)sender {
   
    [self.lotteryMan initiateFollowScheme:@{@"schemeNo":self.schemeNO}];
}
- (void)initiateFollowScheme:(NSString *)resultStr errorMsg:(NSString *)msg{
    if(resultStr != nil && resultStr.length > 0){
        [self showPromptText:@"发单成功" hideAfterDelay:1.9];
    }else{
        [self showPromptText:msg hideAfterDelay:1.9];
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FASSchemeDetailViewController *myOrderListVC = [[FASSchemeDetailViewController alloc]init];
        myOrderListVC.schemeNo = self.schemeNO;
        myOrderListVC.schemeType = @"BUY_INITIATE";
        NSMutableArray * vcS = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [vcS addObject:myOrderListVC];
        self.navigationController.viewControllers = vcS;
    });
   
}

@end
