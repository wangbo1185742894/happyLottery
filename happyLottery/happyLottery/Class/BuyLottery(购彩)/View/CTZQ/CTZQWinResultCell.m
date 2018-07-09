//
//  CTZQWinResultCell.m
//  Lottery
//
//  Created by LC on 16/3/29.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "CTZQWinResultCell.h"
@interface CTZQWinResultCell ()
{
    NSMutableArray *winInfoLaArr;
}
@end
@implementation CTZQWinResultCell

- (void)awakeFromNib {
    CGFloat topLeading = 10;
    CGFloat leftLeading = 15;
    CGFloat sep = 2;
    CGFloat laWidth = (KscreenWidth - leftLeading*2 - 13*sep)/14;
    CGFloat laHeight = self.frame.size.height - 2*topLeading + 3;
    winInfoLaArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<14;i++) {
        UILabel *laTemp = [[UILabel alloc] initWithFrame:CGRectMake(leftLeading + i *(laWidth + sep), topLeading, laWidth, laHeight)];
        laTemp.backgroundColor = [UIColor clearColor];
        laTemp.layer.backgroundColor = SystemGreen.CGColor;
        
        laTemp.text = [NSString stringWithFormat:@"%@",@(i)];
        laTemp.textColor = [UIColor whiteColor];
        laTemp.font = [UIFont systemFontOfSize:14];
        laTemp.textAlignment = NSTextAlignmentCenter;
        [winInfoLaArr addObject:laTemp];
        [self.contentView addSubview:laTemp];
    }
    [self.contentView bringSubviewToFront:_winNotLa];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithInfoGYJ:(NSString *)infoResult{
    if ([infoResult rangeOfString:@"—"].length != 0) {
        infoResult = [infoResult stringByReplacingOccurrencesOfString:@"—" withString:@"VS"];
    }
    _winNotLa.textColor = RGBCOLOR(72, 72, 72);
    _winNotLa.hidden = NO;
    _winNotLa.text = infoResult;
}

- (void)refreshWithInfo:(NSString *)infoResult{
    NSLog(@"TEST SHOW");
// 开奖结果展示
//    info = @"未开奖";
//    info = @"--,1,0,1,3,1,3,1,3,1,3,--,3,--";
    NSLog(@"12138 CTZQ彩开奖结果： <<%@>> ",infoResult);
    
    if([infoResult isEqualToString:@"未开奖"]||[infoResult isEqualToString:@"(null)"]||[infoResult isEqualToString:@""] || infoResult == nil ||[infoResult isEqualToString:@"出票失败"]){
        _winNotLa.hidden = NO;
        if ([infoResult isEqualToString:@"出票失败"]) {
            _winNotLa.text = @"出票失败";
        }
  
        return;
    }
    _winNotLa.hidden = YES;
    NSArray *winNum = [infoResult componentsSeparatedByString:@","];
    if (winNum.count == 14) {
        for (NSInteger i = 0; i < winNum.count; i++ ) {
            UILabel *laTemp = winInfoLaArr[i];
            if ([winNum[i] isEqualToString:@"--"]) {
                laTemp.text = @"*";
            } else {
                laTemp.text = winNum[i];
            }
        }
    }else{
       
    }
    
    
}

@end
