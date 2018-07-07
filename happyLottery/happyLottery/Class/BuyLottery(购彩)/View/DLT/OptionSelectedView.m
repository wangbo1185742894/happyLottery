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
                //助手栏图片添加修改  lyw
                title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉左右空格
                if ([title isEqualToString:@"走势图"]) {
                    [btn setImage:[UIImage imageNamed:@"dlt_openlottery_ex.png"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"dlt_openlottery_ex.png"] forState:UIControlStateHighlighted];
                }else if ([title isEqualToString:@"开奖详情"]){
                    [btn setImage:[UIImage imageNamed:@"trophy.png"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"trophy.png"] forState:UIControlStateHighlighted];
                }else if([title isEqualToString:@"玩法规则"]){
                    [btn setImage:[UIImage imageNamed:@"gameplay.png"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"gameplay.png"] forState:UIControlStateHighlighted];
                }else{
                    btn.titleLabel.font = [UIFont systemFontOfSize:12];
                    [btn setBackgroundImage:[UIImage imageNamed:@"orangeBackground"] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                [self addSubview:btn];
                //分割线添加 lyw
                if (i<titleArr.count-1) {
                    UILabel *label = [[UILabel alloc]init];
                    label.frame = CGRectMake(frame.origin.x+3,btn.frame.origin.y+btn.frame.size.height, frame.size.width-6, separateLineHeight);
                    label.backgroundColor = [UIColor whiteColor];
                    [self addSubview:label];
                }
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
