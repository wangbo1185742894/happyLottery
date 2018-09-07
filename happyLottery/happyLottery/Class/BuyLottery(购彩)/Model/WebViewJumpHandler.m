//
//  WebViewJumpHandler.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/9/7.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "WebViewJumpHandler.h"
#import "JCZQPlayViewController.h"
#import "MyCouponViewController.h"
#import "PersonCenterViewController.h"
#import "DiscoverViewController.h"
#import "TopUpsViewController.h"
#import "LotteryAreaViewController.h"
@interface WebViewJumpHandler()<WebViewJumpHandlerDelegate>{
    
}
@property(strong,nonatomic)UINavigationController *curNav;
@property(strong,nonatomic)BaseViewController *curVc;
@end

@implementation WebViewJumpHandler
-(id)initWithCurVC:(UIViewController *)vc{
    if (self == [super init]) {
        self.curNav = vc.navigationController;
        self.curVc = vc;
    }
    return self;
}

-(void)goToJczq{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.curVc.tabBarController.selectedIndex = 0;
        [self.curNav popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NSNotificationBuyVCJump" object:@1000];
    });
    if ([self.curVc isMemberOfClass:[DiscoverViewController class]]) {
        [self .curVc performSelector:@selector(goToJczq)];
    }
}
-(void)SharingLinks{
    SEL action = NSSelectorFromString(@"SharingLinks");
    if ([self.curVc respondsToSelector:action]) {
        [self.curVc performSelector:action];
    }
}
- (void)telPhone{
    [self.curVc actionTelMe];
}
-(void)goToLogin{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.curVc needLogin];
    });
}

-(void)exchangeToast:(NSString *)msg{
    [self.curVc showPromptText:msg hideAfterDelay:1.7];
}
-(void)goCathectic:(NSString *)lotteryCode{ //跳转竟足  充值  优惠券
    if ([self.curVc isKindOfClass:[LotteryAreaViewController class]]) {
        [self.curVc performSelector:@selector(goCathectic:) withObject:lotteryCode];
    }
}
-(void)hiddenFooter:(BOOL )isHiden{
    if ([self.curVc respondsToSelector:@selector(hiddenFooter:)]) {
        [self.curVc performSelector:@selector(hiddenFooter:)];
    }
}

-(void)goCathectic:(NSString *)lotteryCode :(NSString *)cardCode{ //跳转竟足  充值  优惠券
    if (lotteryCode == nil) {
        return;
    }
    if ([lotteryCode isEqualToString:@"JCZQ"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            JCZQPlayViewController * playViewVC = [[JCZQPlayViewController alloc]init];
            playViewVC.hidesBottomBarWhenPushed = YES;
            [self.curNav pushViewController:playViewVC animated:YES];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.curVc isMemberOfClass:[DiscoverViewController class]]) {
                [self .curVc performSelector:@selector(goToJczq)];
            }
        });
        return;
    }
    [self goCathectic:lotteryCode];
    //上面是不需要登录
    if (self.curVc.curUser.isLogin == NO) {
        [self.curVc needLogin];
        return;
    }
    //下面需要登录
    
    if ([lotteryCode isEqualToString: @"GRZX"]) {
        if (cardCode.length == 0) {
            return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            PersonCenterViewController *personVC = [[PersonCenterViewController alloc]init];
            personVC.cardCode = cardCode;
            personVC.hidesBottomBarWhenPushed = YES;
            [self.curNav pushViewController:personVC animated:YES];
        });
        return;
    }
    
    if ([lotteryCode isEqualToString:@"YHQ"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MyCouponViewController *couponVC = [[MyCouponViewController alloc]init];
            couponVC.hidesBottomBarWhenPushed = YES;
            [self .curNav pushViewController:couponVC animated:YES];
            
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.curVc isMemberOfClass:[DiscoverViewController class]]) {
                [self .curVc performSelector:@selector(goToJczq)];
            }
        });
        
        return;
    }
    
    if ([lotteryCode isEqualToString:@"CZ"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            TopUpsViewController *topUpsVC = [[TopUpsViewController alloc]init];
            topUpsVC.hidesBottomBarWhenPushed = YES;
            [self.curNav pushViewController:topUpsVC animated:YES];
            
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.curVc isMemberOfClass:[DiscoverViewController class]]) {
                [self .curVc performSelector:@selector(goToJczq)];
            }
        });
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NSNotificationJumpToPlayVC" object:lotteryCode];
        [self.curNav popToRootViewControllerAnimated:NO];
    });
}

-(NSString *)getCardCode{
    if (self.curVc.curUser.isLogin ==YES) {
        return self.curVc.curUser.cardCode;
    }else{
        [self.curVc needLogin];
        return @"";
    }
}
@end
