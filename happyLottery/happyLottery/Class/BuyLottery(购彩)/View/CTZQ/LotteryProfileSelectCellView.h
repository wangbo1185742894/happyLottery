//
//  LotteryProfileSelectCellView.h
//  Lottery
//
//  Created by YanYan on 6/6/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotteryXHProfile.h"

@protocol LotteryProfileSelectCellViewDelegate;

@interface LotteryProfileSelectCellView : UIView {
    LotteryXHProfile *curProfile;
    UILabel *labelTitle;
    UILabel *labelBouns;
    UILabel *labelPercentage;
    UIButton *actionBtn;
}

@property BOOL isSelectedProfile;
@property BOOL isP3P5;
@property (nonatomic,copy) NSString *typeString;
//0 表示单关 1表示过关
@property NSInteger guoguanType;
@property (nonatomic, weak) id<LotteryProfileSelectCellViewDelegate> delegate;

- (void) initWithLotteryProfile: (LotteryXHProfile *) profile resource:vcName andguoGuanType:(NSInteger)guoGuanType;
- (void) toggleSelect: (BOOL) select;
- (void) buttonSelect:(BOOL)select curtitle:(NSString *)title;
@end


@protocol LotteryProfileSelectCellViewDelegate <NSObject>
- (void) cellView: (LotteryProfileSelectCellView*) view didSelectLotteryProfile: (LotteryXHProfile *) profile andGuoguanType:(CGFloat)guoGuanType;

@end
