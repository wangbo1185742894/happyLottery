//
//  WinResultTableCell.m
//  Lottery
//
//  Created by only on 16/1/27.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "WinResultTableCell.h"
#define REDBALLCENTER 40

@interface WinResultTableCell()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *redBallArr;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *blueBallArr;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redBallCenter;



@end

@implementation WinResultTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithGYJInfo:(NSString *)info{
    NSDictionary * openRes = [Utility objFromJson:info];
    self.winNotLa.text = [NSString stringWithFormat:@"%@  %@",openRes[@"indexNumber"],openRes[@"clash"]];
}

- (void)refreshWithInfo:(NSString *)info{
    
    NSLog(@"12138 数字彩开奖结果： <<%@>> ",info);
    
    if ([info isEqualToString:@"出票失败"]) {
        _winNotLa.hidden = NO;
        for (UIButton *btn in _blueBallArr) {
            btn.hidden = YES;
            btn.userInteractionEnabled = NO;
            btn.adjustsImageWhenHighlighted = NO;
        }
        for (UIButton *btn in _redBallArr) {
            btn.hidden = YES;
            btn.userInteractionEnabled = NO;
            btn.adjustsImageWhenHighlighted = NO;
        }
        self.winNotLa.text = @"出票失败";
        return;
    }
    
    if([info isEqualToString:@"未开奖"]||[info isEqualToString:@"(null)"]||[info isEqualToString:@""] || info == nil){
        _winNotLa.hidden = NO;
        _winNotLa.text = @"等待开奖";
        for (UIButton *btn in _blueBallArr) {
            btn.hidden = YES;
            btn.userInteractionEnabled = NO;
            btn.adjustsImageWhenHighlighted = NO;
        }
        for (UIButton *btn in _redBallArr) {
            btn.hidden = YES;
            btn.userInteractionEnabled = NO;
            btn.adjustsImageWhenHighlighted = NO;
        }
        return;
    }
    _winNotLa.hidden = YES;
    NSString * result;
    if ([info rangeOfString:@"#"].length>0) {
        //添加双色球
        NSRange range = [info rangeOfString:@"#"]; //现获取要截取的字符串位置
        result = [info substringToIndex:range.location]; //截取字符串
        info = [info stringByReplacingOccurrencesOfString:@"#" withString:@","];
    }
    NSArray *numRedArr = [result componentsSeparatedByString:@","];
    NSArray *numArr = [info componentsSeparatedByString:@","];
    if (numArr.count == 5) {
        
        for (NSInteger i = 0; i<numArr.count; i++) {
            UIButton *btn = _redBallArr[i];
            [btn setTitle:numArr[i] forState:UIControlStateNormal];
            if (btn.hidden == YES) {
                btn.hidden = NO;
            }
        }
        _redBallCenter.constant = REDBALLCENTER;
        for (UIButton *btn in _blueBallArr) {
            btn.hidden = YES;
        }
    }else if(numArr.count == 7){
        //双色球
        for (NSInteger i = 0; i<5; i++) {
            UIButton *btn = _redBallArr[i];
            [btn setTitle:numArr[i] forState:UIControlStateNormal];
        }
        for (NSInteger i = 5; i<numArr.count; i++) {
            UIButton *btn = _blueBallArr[i - 5];
            [btn setTitle:numArr[i] forState:UIControlStateNormal];
            //添加双色球
            if (numRedArr.count == 6 && i == 5 ) {
                [btn setBackgroundImage:[UIImage imageNamed:@"redBall.png"] forState:UIControlStateNormal];
            }
            else {
                [btn setBackgroundImage:[UIImage imageNamed:@"blueBall.png"] forState:UIControlStateNormal];
            }
            btn.hidden = NO;
            
        }
        _redBallCenter.constant = 0;
        //添加 大乐透开奖号码的显示
    }else if (numArr.count == 3){
        for (UIButton *btn in _redBallArr) {
            btn.hidden = YES;
        }
        for (NSInteger i = 1; i<4; i++) {
            UIButton *btn = _redBallArr[i];
            [btn setTitle:numArr[i-1] forState:UIControlStateNormal];
            if (btn.hidden == YES) {
                btn.hidden = NO;
            }
        }
        _redBallCenter.constant = REDBALLCENTER;
        for (UIButton *btn in _blueBallArr) {
            btn.hidden = YES;
        }
    }
}

@end
