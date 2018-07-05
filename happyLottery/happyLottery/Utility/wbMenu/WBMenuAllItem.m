//
//  WBMenuAllItem.m
//  appmall
//
//  Created by 阿兹尔 on 2018/4/25.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "WBMenuAllItem.h"
#define   KnumLine  4
#define   KmarginX  15
#define   KmarginY  20

@interface WBMenuAllItem(){
    UIView *contentView;
}

@end

@implementation WBMenuAllItem

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenHeight, 0)];
        contentView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]initWithFrame:self.frame];
        button .backgroundColor = [UIColor blackColor];
        button.alpha = 0.3;
        [self addSubview:button];
        [self addSubview: contentView];
    }
    return self;
}

-(void)refreshSelectItem:(NSArray *)selectItem{
    [[contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)]; 
    self .backgroundColor = [UIColor clearColor];
    contentView.mj_h = selectItem.count / 4 * 30  + 130;
    UIButton *btnAll = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAll addTarget:self action:@selector(closeAllItem) forControlEvents:UIControlEventTouchUpInside];
//    [btnAll setTitle:@"收起" forState:0];
    [btnAll setImage:[UIImage imageNamed:@"上拉箭头"] forState:0];
    btnAll .frame  =CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 5, 65, 30);
    [btnAll.titleLabel setFont: [UIFont systemFontOfSize:14]];
    [btnAll setTitleColor:RGBCOLOR(72, 72, 72) forState:0];
    [contentView addSubview:btnAll];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 90, 30)];
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = RGBCOLOR(72, 72, 72);
    lab.text = @"全部列表";
    [contentView addSubview:lab];
   

    for (int i = 0; i < selectItem.count; i ++) {
        
        CGFloat width = (KscreenWidth - (KnumLine + 1) * KmarginX) /  KnumLine;
        CGFloat height = 30;
        CGFloat  x = KmarginX +( i % KnumLine) * (KmarginX + width) ;
        CGFloat y = (i/ KnumLine ) * (KmarginY + height) +KmarginY + 40;
        
        UIButton *btnAll = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnAll addTarget:self action:@selector(closeAllItem) forControlEvents:UIControlEventTouchUpInside];
        [btnAll setTitle:selectItem [i] forState:0];
        btnAll .frame  =CGRectMake(x, y, width, height);
        [btnAll.titleLabel setFont: [UIFont systemFontOfSize:14]];
        [btnAll setTitleColor:RGBCOLOR(72, 72, 72) forState:0];
        btnAll.layer.cornerRadius = 4;
        btnAll.layer.masksToBounds = YES;
        btnAll.tag = 1000 + i;
        [btnAll addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
        btnAll.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        btnAll.layer.borderWidth = 1;
//        [contentView addSubview:btnAll];
    }
}

-(void)selectItem:(UIButton *)sender{
    sender.selected = YES;
    [self .delegate wbMenuAllItemSelect:sender.tag -1000];
}

-(void)closeAllItem{
    [UIView animateWithDuration:0.2 animations:^{
           self.hidden = YES;
    }];
}

@end
