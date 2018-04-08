//
//  LotteryProfileSelectView.h
//  happyLottery
//
//  Created by 王博 on 2017/12/18.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCZQProfile.h"
#import "JCLQTransaction.h"

@protocol JCLQLotteryProfileSelectViewDelegate

-(void)jclqlotteryProfileSelectViewDelegate:(JCZQProfile *)lotteryPros andPlayType:(JCLQGuanType)playType andRes:(NSString *)res; //1 从代理调用  2  从控制器调用

@end

@interface JCLQLotteryProfileSelectView : UIView

@property(nonatomic,strong)id<JCLQLotteryProfileSelectViewDelegate >delegate;
@property(nonatomic,strong)NSMutableArray <JCZQProfile * >* lotteryPros;
@end
