//
//  LotteryWinHistoryHeadView.m
//  Lottery
//
//  Created by Yang on 6/30/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//
#define NUMLARIGHTSPACE 86
#import "LotteryWinHistoryHeadView.h"
@interface LotteryWinHistoryHeadView()
{
    __weak IBOutlet UILabel *qihaoLa;
    __weak IBOutlet UILabel *numLa;
    __weak IBOutlet UILabel *blueNumLa;
    
    __weak IBOutlet UIView *numBgView;
    
    __weak IBOutlet NSLayoutConstraint *numLaW;
    
    __weak IBOutlet NSLayoutConstraint *blueLaW;
    
    
}
@end

@implementation LotteryWinHistoryHeadView

- (void) lsetUpWithLottey:(Lottery *)lottery withViewRatio:(NSString *)ratio{
    CGFloat numBgViewW = numBgView.frame.size.width;
    if ([lottery.identifier isEqualToString:@"dlt"]) {
        
        numLaW.constant = numBgViewW/9*5.8;
        blueLaW.constant = numBgViewW/9*3.2-1;
        
      
        blueNumLa.hidden = NO;
        
    }else{
        
        numLaW.constant = numBgViewW;
        blueNumLa.hidden = YES;
    }
    
    
}

- (void) setUpWithLottey:(Lottery *)lottery withViewRatio:(NSString *)ratio{
    
    NSArray * ratioArray = [ratio componentsSeparatedByString:@","];
    float total = 0;
    for (NSString * num in ratioArray) {
        total += [num floatValue];
    }
    CGFloat width = CGRectGetWidth(self.frame)/total;
    CGFloat height = CGRectGetHeight(self.frame);
    
    NSArray * titleArray;
    NSArray * colorArray;
    if ([lottery.identifier isEqualToString:@"dlt"]) {
        titleArray = @[@"期号",@"前区",@"后区"];
        colorArray = @[[UIColor blackColor],[UIColor redColor],[UIColor blueColor]];
    }else if ([lottery.identifier isEqualToString:@"X115"]){
        titleArray = @[@"期号",@"开奖号码"];
        colorArray = @[[UIColor blackColor],[UIColor blueColor]];
    }
    __block  float cur_x = 0;
    [titleArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString * title = (NSString *)obj;
        UILabel * lable = [self lable:CGRectMake(cur_x, 0, width*[ratioArray[idx] floatValue], height) text:title textColor:colorArray[idx] textFontSize:17];
        cur_x += CGRectGetWidth(lable.frame);
        if (idx != titleArray.count-1) {
            UILabel * seperateLb = [self lable:CGRectMake(cur_x, 0, 1, height) text:nil textColor:nil textFontSize:10];
            seperateLb.backgroundColor = RGBCOLOR(140, 140, 140);
        }
    }];
    UILabel * bottomlb = [self lable:CGRectMake(0, height-1, CGRectGetWidth(self.frame), 1) text:nil textColor:nil textFontSize:10];
    bottomlb.backgroundColor = RGBCOLOR(140, 140, 140);
}

- (UILabel *)lable:(CGRect)frame text:(NSString *)text  textColor:(UIColor *)color textFontSize:(int)fontSize{
    UILabel * lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = text;

    lable.textColor = color;
    lable.font = [UIFont boldSystemFontOfSize:fontSize];
    lable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lable];
    return lable;
}


@end
