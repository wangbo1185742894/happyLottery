//
//  OptionSelectedView.m
//  OptionSelectedView
//
//  Created by LC on 16/2/17.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "OptionSelectedView.h"
@interface OptionSelectedView()

@property (nonatomic, strong)NSArray<NSString*>* titleArr;

@end
@implementation OptionSelectedView

- (instancetype)initWithFrame:(CGRect)frame andTitleArr:(NSArray<NSString *> *)titleArr{
    
    CGFloat separateLineHeight = 1;
    CGFloat btnWidth = frame.size.width;
    CGFloat btnHieight = (frame.size.height - separateLineHeight * (titleArr.count - 1)) / titleArr.count;
    _titleArr = titleArr;
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        UIButton *backGround = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backGround.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [backGround addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backGround];
        
        UIView *btnBackView = [[UIView alloc] initWithFrame:frame];
        
        btnBackView.backgroundColor = BtnDisAbleBackColor;
        
        [self addSubview:btnBackView];
    
                UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(frame.origin.x,frame.origin.y - 10,btnWidth ,btnHieight * titleArr.count + 20)];
                image.image = [UIImage imageNamed:@"dltrightmenubg.png"];
        
                 if ([titleArr[0] isEqualToString:@"推荐计划"]) {
            
                 }else{
                     [self addSubview:image];
                 }
                for (NSInteger i = 0; i < titleArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(frame.origin.x, frame.origin.y + i *(btnHieight + separateLineHeight), btnWidth, btnHieight);
                [btn addTarget:self action:@selector(btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                NSString *title = titleArr[i];
                [btn setTitle:titleArr[i] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    btn.contentMode = UIViewContentModeLeft;
                 btn.titleLabel.font = [UIFont systemFontOfSize:14];
                    if (i != titleArr.count -1) {
                        UILabel  * line = [[UILabel alloc]initWithFrame:CGRectMake(10, btn.mj_h-1, btn.mj_w - 20, 1)];
                        line.backgroundColor = SystemLightGray;
                        [btn addSubview: line];
                    }
                   
                    
                if ([title isEqualToString:@" 开奖详情"]) {
                    [btn setImage:[UIImage imageNamed:@"trophy"] forState:UIControlStateNormal];
            
                }else if ([title isEqualToString:@" 走势图  "]){
                    [btn setImage:[UIImage imageNamed:@"dlt_openlottery_ex"] forState:UIControlStateNormal];
                
                }else if([title isEqualToString:@" 玩法规则"]){
                    [btn setImage:[UIImage imageNamed:@"gameplay"] forState:UIControlStateNormal];
                    ;
                }else if([title isEqualToString:@" 我的投注"]){
                    [btn setImage:[UIImage imageNamed:@"bet"] forState:UIControlStateNormal];
                    
                }else{
                    btn.titleLabel.font = [UIFont systemFontOfSize:12];
                    [btn setBackgroundImage:[UIImage imageNamed:@"orangeBackground"] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                [self addSubview:btn];
                    
                }
    }
    return self;
}

- (void)btnDidClicked:(UIButton *)btn{
    NSLog(@"220987 dianle");
    if ([self.delegate respondsToSelector:@selector(optionDidSelacted:andIndex:)]) {
        [self.delegate optionDidSelacted:self andIndex:[_titleArr indexOfObject:[btn currentTitle]]];
    }
    [self hide];
}
- (void)hide{
    [self removeFromSuperview];
    
}
@end
