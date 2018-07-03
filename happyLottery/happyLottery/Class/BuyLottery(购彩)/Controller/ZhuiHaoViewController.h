//
//  ZhuiHaoViewController.h
//  Lottery
//
//  Created by LIBOTAO on 15/9/19.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LotteryTransaction.h"
#import "LotteryPhaseInfoView.h"

#import "optimizeView.h"
@protocol ZhuiHaoViewControllerDelegate <NSObject>
@optional
- (void) NumListShow:(BOOL)flag;
@end

@interface ZhuiHaoViewController : BaseViewController<LotteryManagerDelegate,optimizeViewDelegate,LotteryPhaseInfoViewDelegate,LotteryManagerDelegate>

@property (nonatomic, weak) id<ZhuiHaoViewControllerDelegate> delegate;
@property (nonatomic, strong) Lottery *lottery;
@property (nonatomic, strong) LotteryTransaction *transaction;
//@property (nonatomic, strong) UIButton *RadomgetNumBtn;
@property (nonatomic, readwrite) NSUInteger multiple;
@property (nonatomic, readwrite) NSUInteger issue;
@property (nonatomic, readwrite) NSUInteger zhushu;
@property (nonatomic, readwrite) NSInteger lowrate;
@property (nonatomic, readwrite) NSInteger preissue;
@property (nonatomic, readwrite) NSInteger prerate;
@property (nonatomic, readwrite) NSInteger laterate;
@property (nonatomic, readwrite) NSInteger lowprofit;
@property (nonatomic, readwrite) NSInteger planType;

@end
