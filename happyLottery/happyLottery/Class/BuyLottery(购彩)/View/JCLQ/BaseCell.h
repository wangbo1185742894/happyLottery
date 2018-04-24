//
//  BaseCell.h
//  Lottery
//
//  Created by 王博 on 16/8/17.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCLQMatchModel.h"


@protocol JCLQCellDelegate <NSObject>

-(void)clickItem:(NSString*)title model:(JCLQMatchModel*)model andIndex:(NSInteger)index;
-(BOOL)canBuyThisMatch:(JCLQMatchModel *)model andIndex:(NSInteger)ind;
@end

@interface BaseCell : UITableViewCell

@property(nonatomic,strong)JCLQMatchModel*model;
@property(nonatomic,strong)UIButton *notBuyBtn;

@property(nonatomic,strong)id<JCLQCellDelegate> delegate;

-(void)loadDataWithModel:(JCLQMatchModel*)model;
-(void)refreshSelected:(NSArray *)array baseTag:(NSInteger)tag andEnableArray:(NSArray *)enble;
-(NSMutableAttributedString*)setLabHomeGuestTextColor:(NSString *)str andSelect:(BOOL)select;
-(void )setButton:(UIButton *)item normal:(NSString  *)title andSelect:(NSString *)isselect;


@end
