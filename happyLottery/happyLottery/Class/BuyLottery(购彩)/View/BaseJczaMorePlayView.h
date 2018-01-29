//
//  BaseJczaMorePlayView.h
//  happyLottery
//
//  Created by 王博 on 2017/12/21.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCZQMatchModel.h"
#import "MGLabel.h"

@protocol JCZQSelectVIewDelegate

-(void)JCZQPlayViewSelected;
-(BOOL)canBuyThisMatch:(JCZQMatchModel *)model andIndex:(NSInteger)ind;

@end



@interface BaseJczaMorePlayView : UIView

@property(strong,nonatomic)NSMutableArray *selectItemPlay;
@property(nonatomic,strong)id<JCZQSelectVIewDelegate> delegate;
@property(nonatomic,strong)JCZQMatchModel *curModel;
-(void)jczqCellItemClickBase:(NSInteger )tag;
-(NSString *)getSpTitle:(NSArray *)oddArray index:(NSInteger)i;
-(NSString *)getSpNOTitle:(NSArray *)oddArray index:(NSInteger)i;
-(BOOL)checkThisItemCanBuy:(UIButton *)sender;
@end
