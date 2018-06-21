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

-(void)lotteryProfileSelectViewDelegate:(JCZQProfile *)lotteryPros andPlayType:(JCZQPlayType)playType andRes:(NSString *)res; //1 从代理调用  2  从控制器调用

@end

@interface LotteryProfileSelectView : UIView
-(void)setPlayVIew:(JCZQPlayType )playtype;
@property(nonatomic,strong)id<LotteryProfileSelectViewDelegate >delegate;
@property(nonatomic,strong)NSMutableArray <JCZQProfile * >* lotteryPros;
@property(nonatomic,assign)JCZQPlayType playtype;
@end
