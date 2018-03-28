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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame andTitleArr:(NSArray<NSString *> *)titleArr{
    
    CGFloat separateLineHeight = SEPHEIGHT;
    CGFloat btnWidth = frame.size.width;
    CGFloat btnHieight = (frame.size.height - separateLineHeight * (titleArr.count - 1)) / titleArr.count;
    _titleArr = titleArr;
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        UIButton *backGround = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backGround.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//        backGround.backgroundColor = [UIColor clearColor];
        [backGround addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backGround];
        
        UIView *btnBackView = [[UIView alloc] initWithFrame:frame];
        
        btnBackView.backgroundColor = SEPCOLOR ;
        
        [self addSubview:btnBackView];
        
        
        
       
//            等待图片素材
//        if (self.isP3P5 == NO) {
                UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(frame.origin.x,frame.origin.y - 10,btnWidth ,btnHieight * titleArr.count + 20)];
                image.image = [UIImage imageNamed:@"zhushoubg"];
        
                // 判断是否是总表控制器
        
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
                 btn.titleLabel.font = [UIFont systemFontOfSize:12];
                if ([title isEqualToString:@"开奖记录"]) {
                    [btn setImage:[UIImage imageNamed:@"kjjilu.png"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"kjjilu.png"] forState:UIControlStateHighlighted];
                }else if ([title isEqualToString:@"开奖趋势"]){
                    [btn setImage:[UIImage imageNamed:@"kjqushi.png"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"kjqushi.png"] forState:UIControlStateHighlighted];
                }else if([title isEqualToString:@"玩法介绍"]){
                    [btn setImage:[UIImage imageNamed:@"wfjieshao.png"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"wfjieshao.png"] forState:UIControlStateHighlighted];
                }else{
                    btn.titleLabel.font = [UIFont systemFontOfSize:12];
                    [btn setBackgroundImage:[UIImage imageNamed:@"orangeBackground"] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                [self addSubview:btn];
                    
                }
//            }else{
//                for (NSInteger i = 0; i < titleArr.count; i++) {
//                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//                btn.frame = CGRectMake(frame.origin.x, frame.origin.y + i *(btnHieight + separateLineHeight), btnWidth, btnHieight);
//                [btn addTarget:self action:@selector(btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
//                
//                NSString *title = titleArr[i];
//                [btn setTitle:titleArr[i] forState:UIControlStateNormal];
//                [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//                if ([title isEqualToString:@"开奖记录"]) {
//                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_record.png"] forState:UIControlStateNormal];
//                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_record_selected.png"] forState:UIControlStateHighlighted];
//                }else if ([title isEqualToString:@"开奖趋势"]){
//                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_trend.png"] forState:UIControlStateNormal];
//                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_trend_selected.png"] forState:UIControlStateHighlighted];
//                }else if([title isEqualToString:@"玩法介绍"]){
//                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_playMethod.png"] forState:UIControlStateNormal];
//                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_playMethod_selected.png"] forState:UIControlStateHighlighted];
//                }else{
//                    btn.titleLabel.font = [UIFont systemFontOfSize:14];
//                    [btn setBackgroundImage:[UIImage imageNamed:@"orangeBackground"] forState:UIControlStateNormal];
//                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                }
//                [self addSubview:btn];
//            }
        
//            }
        
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
