//
//  JingCaiChaunFaSelectView.h
//  Lottery
//
//  Created by 王博 on 2017/7/18.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCZQTranscation.h"
#import "JCLQTransaction.h"


@protocol JingCaiChaunFaSelectViewDelegate <NSObject>

-(void)selectChuanFa:(NSArray *)chuanFaArray;

@end


@interface JingCaiChaunFaSelectView : UIView
@property (nonatomic , strong) JCZQTranscation * transation;
@property (nonatomic , strong) JCLQTransaction * jclqtransation;
@property (nonatomic , readwrite) BOOL  supportDanguan;
@property(nonatomic,weak)id<JingCaiChaunFaSelectViewDelegate> delegate;
@property(nonatomic,strong)NSMutableArray *selectedItems;

-(void)setTitle:(NSString *)title andSingleTitle:(NSArray *)singleTitles andMutipleTitle:(NSArray *)mutipleTitles;
- (void)showFromSuperView:(UIView *)supview;
-(void)showFromSuperViewJCLQ:(UIView *)supview;

@end
