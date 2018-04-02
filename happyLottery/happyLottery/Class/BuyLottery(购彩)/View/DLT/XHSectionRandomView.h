//
//  XHSectionRandomView.h
//  Lottery
//
//  Created by YanYan on 6/3/15.
//  Copyright (c) 2015 AMP. All rights reserved.

/*
 provide random number button and random number count selector
 */

#import <UIKit/UIKit.h>
#import "LotteryXHSection.h"
#import "NumberSelectView.h"
#import "Lottery.h"

@protocol XHSectionRandomViewDelegate <NSObject>
- (void) generateRandomNumber: (int) numberCount lotteryXHSection: (LotteryXHSection*) section;
@end

@interface XHSectionRandomView : UIView <NumberSelectViewDelegate> {
    UIButton *buttonRandomeNumber;
    UIButton *buttonRandomeFive;
    UIButton *buttonRandomCountSelect;
}

@property int randomCount;
@property (nonatomic, weak) id<XHSectionRandomViewDelegate> delegate;
@property (nonatomic, strong) NumberSelectView *numberSelectView;

@property (nonatomic, strong) NSString *lotteryIdenty;
@property (nonatomic, strong) Lottery *lottery;


- (void) initUIWithLotteryXH: (LotteryXHSection *) lotteryXH curlottery:(Lottery *)lottery;
@end
