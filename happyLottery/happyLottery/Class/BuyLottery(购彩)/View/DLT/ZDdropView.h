//
//  ZDdropView.h
//  Lottery
//
//  Created by only on 16/11/9.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZDdropViewDelegate<NSObject>
- (void)choiceIndex:(NSInteger)index andString:(NSString *)string;
@end
@interface ZDdropView : UIView
@property (nonatomic, strong) NSMutableArray * btnArray;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UILabel * rightLabel;
@property (nonatomic, strong) UILabel * middenLabel;
@property (nonatomic, assign) id<ZDdropViewDelegate>delegate;
//查遗漏
- (instancetype)initWithFrame:(CGRect)frame andDataArray:(NSArray *)array andTitleStrIndex:(NSInteger)myIndex;
//竞足、竞蓝推荐总表
- (instancetype)initWithFrame:(CGRect)frame andDataSource:(NSArray *)array andTitleStrIndex:(NSInteger)myIndex;
@end
