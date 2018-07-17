//
//  optimizeView.h
//  Lottery
//
//  Created by LIBOTAO on 15/9/25.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertPushtView.h"
#import "RadioButton.h"
@protocol optimizeViewDelegate <NSObject>
//@optional
-(void) changeValue:(NSInteger)issNum multiple:(NSInteger)multipleNum;
-(void) schemeValue:(NSInteger)plantype lowprofit:(NSInteger)lowprofitNum;
-(void) schemeValue:(NSInteger)preissueNum prerateNum:(NSInteger)prerateNum laterateNum:(NSInteger)laterateNum;
@end

@interface optimizeView : AlertPushtView

@property (nonatomic, weak) id<optimizeViewDelegate> delegate;

@property (nonatomic, strong) Lottery *lottery;
@property (nonatomic, retain) UIButton *issuedownBtn;
@property (nonatomic, retain) UIButton *beishudownBtn;
@property (nonatomic, retain) UILabel *beishuLabel;
@property (nonatomic, retain) UILabel *issueLabel;
@property (nonatomic, retain) UIButton *issueUpBtn;
@property (nonatomic, retain) UIButton *beishuUpBtn;
@property (nonatomic, retain) UITextField *minprofitField;
@property (nonatomic, retain) UITextField *ratenumField;
@property (nonatomic, retain) UITextField *qinumField;
@property (nonatomic, retain) UITextField *qiannumField;
@property (nonatomic, retain) UITextField *minnumField;
@property (nonatomic, retain) UIView *profitview;
@property (nonatomic, retain) RadioButton *rb1;
@property (nonatomic, retain) RadioButton *rb2;
@property (nonatomic, retain) RadioButton *rb3;


@property (nonatomic, readwrite) NSInteger issueNum;
@property (nonatomic, readwrite) NSInteger multipleNum;
@property (nonatomic, readwrite) NSInteger lowrateNum;//全程最低盈利率
@property (nonatomic, readwrite) NSInteger preissueNum;//前**期
@property (nonatomic, readwrite) NSInteger prerateNum;//前**期盈利率
@property (nonatomic, readwrite) NSInteger laterateNum;//之后盈利率
@property (nonatomic, readwrite) NSInteger lowprofitNum;//全程最低盈利
@property (nonatomic, readwrite) NSInteger planTypeNum;//优化方式


@property (nonatomic, readwrite) BOOL keyboard;

@end
