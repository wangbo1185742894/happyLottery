//
//  LotteryProfileSelectView.h
//  happyLottery
//
//  Created by 王博 on 2017/12/18.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCZQProfile.h"
#import "JCZQTranscation.h"

@protocol LotteryProfileSelectViewDelegate

-(void)lotteryProfileSelectViewDelegate:(JCZQProfile *)lotteryPros andPlayType:(JCZQPlayType)playType;

@end

@interface LotteryProfileSelectView : UIView

@property(nonatomic,strong)id<LotteryProfileSelectViewDelegate >delegate;
@property(nonatomic,strong)NSMutableArray <JCZQProfile * >* lotteryPros;
@end
