//
//  CTZQBetInfoCell.m
//  Lottery
//
//  Created by LC on 16/3/29.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "CTZQBetInfoCell.h"
@interface CTZQBetInfoCell()
{
    UIImageView* laDanArr[14];
    UILabel* laBetNumArr[3][14];
    //122
}


@end

@implementation CTZQBetInfoCell

- (void)awakeFromNib {
    // Initialization code
    
    CGFloat topLeading = 10;
    CGFloat leftLeading = 15;
    CGFloat sep = 2;
    CGFloat laWidth = (KscreenWidth - leftLeading*2 - 13*sep)/14;
    CGFloat laHeight = 24;
    CGFloat imWidth  = 15;
    CGFloat imHeight = 15;
    for (NSInteger i = 0; i<14;i++) {
        laDanArr[i] = [[UIImageView alloc] initWithFrame:CGRectMake(leftLeading + i *(laWidth + sep)+2, topLeading+5, imWidth, imHeight)];
        [laDanArr[i] setContentMode:UIViewContentModeScaleAspectFit];
//        laDanArr[i].backgroundColor = [UIColor clearColor];
//        laDanArr[i].layer.backgroundColor = [UIColor cyanColor].CGColor;
//        laDanArr[i].text = [NSString stringWithFormat:@"胆"];
//        laDanArr[i].textColor = [UIColor whiteColor];
//        laDanArr[i].font = [UIFont systemFontOfSize:14];
//        laDanArr[i].textAlignment = NSTextAlignmentCenter;
        laDanArr[i].hidden = YES;
        [self.contentView addSubview:laDanArr[i]];
    }
    CGFloat x = leftLeading;
    CGFloat y = topLeading + laHeight + sep;
    for (NSInteger i = 0; i<3;i++) {
        for (NSInteger j = 0; j<14; j++) {
            laBetNumArr[i][j] = [[UILabel alloc] initWithFrame:CGRectMake(x + j *(laWidth + sep), y + i * (laHeight + sep), laWidth, laHeight)];
            laBetNumArr[i][j].backgroundColor = [UIColor clearColor];
            laBetNumArr[i][j].layer.backgroundColor = SystemGray.CGColor;
            laBetNumArr[i][j].text = [NSString stringWithFormat:@"%@%@",@(i),@(j)];
            laBetNumArr[i][j].textColor = [UIColor whiteColor];
            laBetNumArr[i][j].font = [UIFont systemFontOfSize:14];
            laBetNumArr[i][j].textAlignment = NSTextAlignmentCenter;
            laBetNumArr[i][j].hidden = YES;
            [self.contentView addSubview:laBetNumArr[i][j]];

        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithBetInfo:(id)infoDic andWinResult:(NSString *)winResult{
//    全胆中
//    info = @"#310,#10,#301,#31,#310,#0,#310,#10,#310,#310,#301,#10,#30,#31";
    NSString *info = infoDic[@"lotteryNumber"];
    
//    全胆不中
//    info = @"#10,3,#31,*,#10,#1,#310,*,#10,#30,#30,#1,#0,#3";
//    info = @"#310,#310,#301,#31,#310,#0,#310,#10,#310,#10,#301,#10,#30,#31";
//    info = @"#310,*,#301,*,#310,*,*,#10,#310,#10,*,#10,*,#31";
     winResult = infoDic[@"winNumber"];
//    winResult = @"--,1,0,1,3,1,3,1,3,1,3,--,3,--";
//    winResult = @"3,1,0,1,3,0,*,3,3,1,1,0,3,1";
//    winResult = @"*,*,*,*,*,*,*,*,*,*,*,*,*,*";
    
    NSArray *winInfoArr = [winResult componentsSeparatedByString:@","];
//    NSLog(@"%@",winInfoArr);
    NSArray *matchBetArr = [info componentsSeparatedByString:@","];
//    NSLog(@"%@",matchBetArr);
    NSInteger indexY = 0;
    for (NSString *eachMatch in matchBetArr) {
        
//        NSLog(@"-------------------------------");
//        NSArray *eachInfoNumArr = [eachMatch componentsSeparatedByString:@""];
        
        NSMutableArray *eachInfoNumArr =[[NSMutableArray alloc] init] ;
        for (NSInteger i = 0; i< eachMatch.length; i++) {
            NSRange keyRange =NSMakeRange(i, 1);
            [eachInfoNumArr addObject:[eachMatch substringWithRange:keyRange]];
        }
        
        NSLog(@"%@",eachInfoNumArr);
        NSInteger count = eachInfoNumArr.count;
        NSLog(@"%zd",count);
        
        //选中处理
        BOOL isWin = NO;
        NSString *winNum;
        if ([winResult isEqualToString:@"未开奖"]||[winResult isEqualToString:@"(null)"]||[winResult isEqualToString:@""]) {
            isWin = NO;
        }else{
            winNum = [winInfoArr objectAtIndex:indexY];
            if ([eachMatch containsString:winNum]||([winNum isEqualToString:@"--"]&& count > 0)) {
                isWin = YES;
            }
        }
        
        if ([eachMatch containsString:@"#"]) {
            laDanArr[indexY].hidden = NO;
            laDanArr[indexY].image = [UIImage imageNamed:@"dan_notWin"];
            count -= 1;
            if (isWin) {
                laDanArr[indexY].image = [UIImage imageNamed:@"dan_Win"];

            }
            
        }
        
        for (NSInteger indexX=0 ; indexX<count; indexX++) {
            if ([eachMatch containsString:@"3"]) {
                laBetNumArr[indexX][indexY].text = @"3";
                laBetNumArr[indexX][indexY].hidden = NO;
                if ([winNum isEqualToString:@"3"]||[winNum isEqualToString:@"--"]) {
                    laBetNumArr[indexX][indexY].backgroundColor = TextCharColor;
                }
                indexX++;
            }
            if ([eachMatch containsString:@"1"]) {
                laBetNumArr[indexX][indexY].text = @"1";
                laBetNumArr[indexX][indexY].hidden = NO;
                if ([winNum isEqualToString:@"1"]||[winNum isEqualToString:@"--"]) {
                    laBetNumArr[indexX][indexY].backgroundColor = TextCharColor;
                }
                indexX++;
                
            }
            if ([eachMatch containsString:@"0"]) {
                laBetNumArr[indexX][indexY].text = @"0";
                laBetNumArr[indexX][indexY].hidden = NO;
                if ([winNum isEqualToString:@"0"]||[winNum isEqualToString:@"--"]) {
                    laBetNumArr[indexX][indexY].backgroundColor = TextCharColor;
                }
                indexX++;
            }
            if ([eachMatch containsString:@"*"]) {
                laBetNumArr[indexX][indexY].text = @"*";
                laBetNumArr[indexX][indexY].hidden = NO;

                indexX++;
            }
            
        }
        
        
        indexY ++;
        
        }
    
        
}


@end
