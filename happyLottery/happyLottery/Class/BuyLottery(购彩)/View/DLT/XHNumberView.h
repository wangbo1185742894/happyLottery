//
//  XuanHaoNumberView.h
//  Lottery
//
//  Created by AMP on 5/23/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotteryXHSection.h"
#import "LotteryNumber.h"

#define TitleTextDanHao @"胆"

typedef enum {
    //title color is gray and unable to select
    NumberViewStateDisabled,
    NumberViewStateNormal,
    NumberViewStateSelected,
    NumberViewStateDanHao
} NumberViewState;

@protocol XHNumberViewDelegae;

@interface XHNumberView : UIView

@property (nonatomic, strong) LotteryXHSection *lotteryXH;
@property (nonatomic, weak) id<XHNumberViewDelegae> delegate;
@property NumberViewState numberState;
@property (nonatomic, strong) LotteryNumber *numberObj;

- (void) drawNumber;
- (void) reset;
- (void) updateButtonForCurrentState;

@end


@protocol XHNumberViewDelegae <NSObject>
@required
- (void) numberView: (XHNumberView*) numberView lotteryXuanHao: (LotteryXHSection*) lotteryXH numberStateUpdate: (NumberViewState) state;
- (NumberViewState) numberView: (XHNumberView*) numberView lotteryXuanHao: (LotteryXHSection*) lotteryXH nextViewState: (NumberViewState) maxState;





@end