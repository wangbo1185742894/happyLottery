//
//  ZDdropView.m
//  Lottery
//
//  Created by only on 16/11/9.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "ZDdropView.h"
#define KBTNTAGBASE 1000
@implementation ZDdropView
- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        _btnArray = [[NSMutableArray alloc]init];
    }
    return _btnArray;
}
- (instancetype)initWithFrame:(CGRect)frame andDataArray:(NSArray *)array andTitleStrIndex:(NSInteger)myIndex
{
    [self.btnArray removeAllObjects];
    if (self = [super initWithFrame:frame]) {
        [self layoutIfNeeded];
        self.dataArray = array;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
        UIButton * bigByn = [UIButton buttonWithType:UIButtonTypeCustom];
        bigByn.frame = self.bounds;
        bigByn.backgroundColor = [UIColor clearColor];
        [bigByn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bigByn];
        
        
        //添加一个白色的背景View
        int leftSpcing = 10;
        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, NaviHeight, KscreenWidth, 203)];
        self.bottomView.backgroundColor =RGBACOLOR(0, 0, 0, 0.7);
        [self addSubview:self.bottomView];
        
        self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftSpcing, 13, KscreenWidth / 2-50, 1.5)];
        self.leftLabel.backgroundColor = SystemGreen;
        [self.bottomView addSubview:self.leftLabel];
        self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth / 2 + 40, 13, KscreenWidth / 2-50, 1.5)];
        self.rightLabel.backgroundColor = SystemGreen;
        [self.bottomView addSubview:self.rightLabel];
        
        self.middenLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 25)];
        self.middenLabel.center = CGPointMake(self.center.x, 15);
        self.middenLabel.backgroundColor =[UIColor clearColor];
        self.middenLabel.text = @"组合遗漏";
        
        
        self.middenLabel.textColor  = [UIColor whiteColor];
        
        self.middenLabel.textAlignment = NSTextAlignmentCenter;
        self.middenLabel.font = [UIFont systemFontOfSize:16];
        [self.bottomView addSubview:self.middenLabel];
     
        
        int allwidth = KscreenWidth;
        int spacing = 10;//两个之间的横向距离
        int Height_Space = 10;////两个之间的纵向距离
        int left = 10;//第一个距离左边的距离
        int top = 35;//第一个距离上边的距离
        int width  = (allwidth-left*2-2*spacing)/3;
        int height = 32;
        for (int i = 0; i < array.count; i++) {
            NSInteger index = i % 3;
            NSInteger page = i / 3;
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(left+index*(spacing+width), top+page*(height+Height_Space), width, height);
            button.tag =KBTNTAGBASE + i;
            
            [button setTitle:array[i] forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            if (i == myIndex) {
                button.selected = YES;
            }else {
                button.selected = NO;
            }
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
//            [button setBackgroundImage:[UIImage imageNamed:@"itemback"] forState:UIControlStateNormal];
//            [button setBackgroundImage:[UIImage imageNamed:@"itemback"] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:0];
                [button setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:UIControlStateSelected];
            button.layer.borderColor = [UIColor whiteColor].CGColor;
            button.layer.borderWidth = 1;
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            
            [button addTarget:self action:@selector(choceClicked:) forControlEvents:UIControlEventTouchUpInside];

            button.adjustsImageWhenHighlighted = NO;
            button.titleLabel.font = [UIFont systemFontOfSize:15];

            [self.bottomView addSubview:button];
            [self.btnArray addObject:button];
            
        }
    }
    return self;

}
- (instancetype)initWithFrame:(CGRect)frame andDataSource:(NSArray *)array andTitleStrIndex:(NSInteger)myIndex
{
    [self.btnArray removeAllObjects];
    if (self = [super initWithFrame:frame]) {
        [self layoutIfNeeded];
        self.dataArray = array;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
        UIButton * bigByn = [UIButton buttonWithType:UIButtonTypeCustom];
        bigByn.frame = self.bounds;
        bigByn.backgroundColor = [UIColor clearColor];
        [bigByn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bigByn];
        
        
        //添加一个白色的背景View
        int leftSpcing = 10;
    
        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KscreenWidth, 55)];
        self.bottomView.backgroundColor =RGBCOLOR(255,254, 233);
        [self addSubview:self.bottomView];
        
    
        int allwidth = KscreenWidth;
        int two = 10;
        int spacing = 10;//两个之间的横向距离
        int width  = (allwidth-two*2-2*spacing)/3;
        int height = 32;
        for (int i = 0; i < array.count; i++) {
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((allwidth/2-two/2-width)+i*(width +10), 10, width, height);
            button.tag =KBTNTAGBASE + i;
            
            [button setTitle:array[i] forState:UIControlStateNormal];
            
            [button setTitleColor:RGBCOLOR(254, 253, 0) forState:UIControlStateSelected];
            if (i == myIndex) {
                button.selected = YES;
            }else {
                button.selected = NO;
            }
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            //            [button setBackgroundImage:[UIImage imageNamed:@"itemback"] forState:UIControlStateNormal];
            //            [button setBackgroundImage:[UIImage imageNamed:@"itemback"] forState:UIControlStateSelected];
            [button setBackgroundColor:RGBCOLOR(224, 57, 32)];
            
            [button addTarget:self action:@selector(choceClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            button.adjustsImageWhenHighlighted = NO;
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            
            [self.bottomView addSubview:button];
            [self.btnArray addObject:button];
            
        }
    }
    return self;
    
}

- (void)choceClicked:(UIButton *)sender
{
    NSInteger index = sender.tag-1000;
    if (self.delegate && [self.delegate respondsToSelector:@selector(choiceIndex:andString:)]) {
        sender.selected = sender.selected?NO:YES;
        if (sender.selected == YES) {
            for (UIButton * btn in _btnArray) {
                if (btn.tag != sender.tag) {
                    btn.selected = NO;
                }
                
            }
        }
        [self.delegate choiceIndex:index andString:self.dataArray[index]];
    }
    [self removeFromSuperview];
    
}
- (void)clicked:(UIButton *)sender
{
    [self removeFromSuperview];
}
@end
