//
//  DLTSchemeViewCell.m
//  Lottery
//
//  Created by 王博 on 17/4/25.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "DLTSchemeViewCell.h"


@implementation DLTSchemeViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"DLTSchemeViewCell" owner:nil options:nil] lastObject];
    }
    return self;
}

-(void)refreshDataWith:(NSDictionary*)betDic andOpenResult:(NSString *)string{
    
//    [6]    (null)    @"playType" : @"General"
    
    self.viewBallContent.layer.borderColor = RGBCOLOR(90, 160, 253).CGColor;
    self.viewBallContent.layer.borderWidth = 1;
    
    if([betDic[@"playType"] integerValue] == 1 ){
        self.labLotteryName.text = [NSString stringWithFormat:@"超级大乐透（追加）"];
    }else{
        self.labLotteryName.text = [NSString stringWithFormat:@"超级大乐透"];
    }
    self.trDltOpenResult = string;
    NSArray *redList = betDic[@"redList"];
    NSArray *redDanList = betDic[@"redDanList"];
    NSArray *blueList = betDic[@"blueList"];
    NSArray *blueDanList = betDic[@"blueDanList"];
    NSAttributedString *redTitle = [self titleNumber:redList andDan:redDanList isRed:YES];
    NSAttributedString *blueTitle = [self titleNumber:blueList andDan:blueDanList isRed:NO];
    float height = [self getHeightredTitle:redTitle.string blueTitle:blueTitle.string];
    self.labRedBall.attributedText = redTitle;
    self.labBuleBall.attributedText = blueTitle;
    self.heightRedBall.constant = height;
}

-(CGFloat)getCellHeightWith:(NSDictionary*)betDic{
    
    NSArray *redList = betDic[@"redList"];
    NSArray *redDanList = betDic[@"redDanList"];
    NSArray *blueList = betDic[@"blueList"];
    NSArray *blueDanList = betDic[@"blueDanList"];
    NSAttributedString *redTitle = [self titleNumber:redList andDan:redDanList isRed:YES];
    NSAttributedString *blueTitle = [self titleNumber:blueList andDan:blueDanList isRed:NO];
    return  [self getTotalHeightredTitle:redTitle.string blueTitle:blueTitle.string] + 40;
}

-(float)getTotalHeightredTitle:(NSString*)redTitle blueTitle:(NSString *)blueTitle{
    float redHeight = [redTitle boundingRectWithSize:CGSizeMake(KscreenWidth - 80, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{@"UIFont":[UIFont systemFontOfSize:18]} context:nil].size.height + 40;
    
    float blueHeight = [blueTitle boundingRectWithSize:CGSizeMake(KscreenWidth - 80, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{@"UIFont":[UIFont systemFontOfSize:18]} context:nil].size.height ;
    return (redHeight > 35?redHeight:35) + (blueHeight> 35?blueHeight:35) + 30;
}

-(float)getHeightredTitle:(NSString*)redTitle blueTitle:(NSString *)blueTitle{
    float redHeight = [redTitle boundingRectWithSize:CGSizeMake(KscreenWidth - 100, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{@"UIFont":[UIFont systemFontOfSize:18]} context:nil].size.height + 40;
    
    float blueHeight = [blueTitle boundingRectWithSize:CGSizeMake(KscreenWidth - 80, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{@"UIFont":[UIFont systemFontOfSize:18]} context:nil].size.height;
    return redHeight >35?redHeight:35;
}

-(NSAttributedString *)titleNumber:(NSArray*)tuoArray andDan:(NSArray *)danArray isRed:(BOOL)isRed{
    
    
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc]init];
    
    NSArray *resultArray;
    if (self.trDltOpenResult != nil && ![self.trDltOpenResult isEqualToString:@""]) {
        
        
        if (isRed) {
            resultArray = [[[self.trDltOpenResult componentsSeparatedByString:@"#"] firstObject] componentsSeparatedByString:@","];
            
            
        }else{
            resultArray = [[[self.trDltOpenResult componentsSeparatedByString:@"#"] lastObject] componentsSeparatedByString:@","];
        }
    }
    
    NSInteger numDan = 0;
    if ([self isEnble:danArray]) {
        
        [attTitle appendAttributedString:[[NSAttributedString alloc]initWithString:@"[胆：" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:TEXTGRAYCOLOR}]];
        for (NSString *itemDan in danArray) {
            numDan ++;
            bool isExit = NO;
            for (NSString *resDanItem in resultArray) {
                if ([itemDan integerValue] == [resDanItem integerValue]) {
                    isExit = YES;
                    break;
                }
            }
            UIColor *titleColor;
            if (!isExit) {
                titleColor = TEXTGRAYCOLOR;
                
            }else{
                titleColor = TextOrangeColor;
            }
            NSAttributedString * att = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",itemDan] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:titleColor}];
            
            [attTitle appendAttributedString:att];
            
            if (numDan  < danArray.count ) {
                NSAttributedString * comStr = [[NSAttributedString alloc]initWithString:@"," attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:TEXTGRAYCOLOR}];
                
                [attTitle appendAttributedString:comStr];
            }
            
        }
        
        
        [attTitle appendAttributedString:[[NSAttributedString alloc]initWithString:@"]\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:TEXTGRAYCOLOR}]];
    }
    numDan = 0;
    
    
    if ([self isEnble:tuoArray]) {
        for (NSString *itemDan in tuoArray) {
            numDan ++;
            bool isExit = NO;
            for (NSString *resDanItem in resultArray) {
                if ([itemDan integerValue] == [resDanItem integerValue]) {
                    isExit = YES;
                    break;
                }
            }
            UIColor *titleColor;
            if (!isExit) {
                titleColor = TEXTGRAYCOLOR;
                
            }else{
                titleColor = TextOrangeColor;
            }
            NSAttributedString * att = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",itemDan] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:titleColor}];
            
            [attTitle appendAttributedString:att];
            
            if (numDan  < tuoArray.count) {
                NSAttributedString * comStr = [[NSAttributedString alloc]initWithString:@"," attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:TEXTGRAYCOLOR}];
                
                [attTitle appendAttributedString:comStr];
            }
            
        }
    }
    return attTitle;
}

-(void)setNumIndex:(NSString *)numIndex andIsShow:(BOOL)isShow{
    self.labMatchNum.hidden = isShow;
    [self.labMatchNum setTitle:numIndex forState:0];
}

-(BOOL)isEnble:(NSArray *)array{

    if (array.count != 0 && array != nil) {
        return YES;
    }else{
    
        return NO;
    }
}

@end
