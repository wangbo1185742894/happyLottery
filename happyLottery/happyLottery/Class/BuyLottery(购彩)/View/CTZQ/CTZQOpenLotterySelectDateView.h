//
//  CTZQOpenLotterySelectDateView.h
//  Lottery
//
//  Created by 王博 on 16/3/29.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotteryRound.h"

@protocol CTZQOpenLotterySelectDateDelegate <NSObject>

-(void)actionSubmitDate:(NSInteger)index;

@end

@interface CTZQOpenLotterySelectDateView : UIView

@property (weak,nonatomic)id<CTZQOpenLotterySelectDateDelegate>delegate;

@property (strong,nonatomic)NSArray *pickerDataSource;
@property (strong,nonatomic)NSString *selected;

- (void)configShow;
@end
