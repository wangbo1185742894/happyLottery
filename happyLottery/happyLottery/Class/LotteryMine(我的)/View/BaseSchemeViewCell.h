//
//  BaseSchemeViewCell.h
//  Lottery
//
//  Created by 王博 on 17/4/25.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCZQSchemeModel.h"


@protocol BaseSchemeViewToOrderDetailDelegate <NSObject>

-(void)actionToDetail:(NSString*)schemeNo;

@end

@interface BaseSchemeViewCell : UITableViewCell

@property(nonatomic,weak)id<BaseSchemeViewToOrderDetailDelegate> delegate;

@property(nonatomic,strong)JCZQSchemeItem *scheme;

@property(nonatomic,assign)BOOL isInit;

-(void)setBtnDetailHiden:(BOOL)isHiden;

-(UILabel*)creactLab:(NSString *)title andFrame:(CGRect)frame;


-(void)refreshDataWith:(JCZQSchemeItem*) schemeDetail;

- (id) objFromJson: (NSString*) jsonStr;

-(UILabel*)creactAttributedLab:(NSAttributedString *)title andFrame:(CGRect)frame;
-(NSString *)getPassType:(NSString *)passType;
@end
