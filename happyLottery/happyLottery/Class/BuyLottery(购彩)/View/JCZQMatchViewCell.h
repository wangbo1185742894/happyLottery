//
//  JCZQMatchViewCell.h
//  happyLottery
//
//  Created by 王博 on 2017/12/18.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCZQTranscation.h"
#import "JCZQMatchModel.h"
#import "HomeYCModel.h"
@protocol JCZQMatchViewCellDelegate

-(void)showAllPlayType:(JCZQMatchModel *)model :(NSDictionary *)titleDic;

-(void)showBQCPlayType:(JCZQMatchModel *)model :(NSDictionary *)titleDic;

-(void)showBFPlayType:(JCZQMatchModel *)model :(NSDictionary *)titleDic;

-(void)showSPFARQSPFSelecedMsg:(NSString *)msg;

-(void)showForecastDetailForCellBottom:(JCZQMatchModel *)model;//显示cell下面部分view

-(void)showMatchDetailWith:(HomeYCModel *)model;

-(void)showSchemeRecom;

-(BOOL)canBuyThisMatch:(JCZQMatchModel *)model andIndex:(NSInteger)ind;

@end

@interface JCZQMatchViewCell : UITableViewCell

@property(nonatomic,weak)id<JCZQMatchViewCellDelegate>delegate;

-(void)refreshWithYcInfo:(HomeYCModel *)homeModel;

-(void)reloadDataMatch:(JCZQMatchModel * )match andProfileTitle:(NSString *)title andGuoguanType:(JCZQPlayType )playType;
@end
