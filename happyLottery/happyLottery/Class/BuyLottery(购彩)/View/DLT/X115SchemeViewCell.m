//
//  DLTSchemeViewCell.m
//  Lottery
//
//  Created by 王博 on 17/4/25.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "X115SchemeViewCell.h"


@implementation X115SchemeViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"X115SchemeViewCell" owner:nil options:nil] lastObject];
    }
    return self;
}

-(void)refreshDataWith:(NSDictionary*)betDic andOpenResult:(NSString *)string andLotteryType:(NSString *)typeName{
    
    self.viewBallContent.layer.borderColor = RGBCOLOR(90, 160, 253).CGColor;
    self.viewBallContent.layer.borderWidth = 1;
    NSString *playType = betDic[@"playType"];
    playType = [self getCHNTypeByEnType:playType];
    if ([betDic[@"betType"] integerValue] ==2) {
        playType = [NSString stringWithFormat:@"%@胆拖",playType];
        if ([playType isEqualToString:@"前三组选胆拖"]) {
            playType = @"组三胆拖";
        }
        if ([playType isEqualToString:@"前二组选胆拖"]) {
            playType = @"组二胆拖";
        }
    }
    if ([typeName isEqualToString:@"SX115"]) {
            self.labLotteryName.text = [NSString stringWithFormat:@"陕西11选5"];
    } else {
              self.labLotteryName.text = [NSString stringWithFormat:@"山东11选5"];
    }
    self.playtype.text = playType;
    self.trDltOpenResult = string;
    NSArray *betRows = betDic[@"betRows"];
    if ([playType isEqualToString:@"前一"]) {
        NSAttributedString *bet = [self getBetNumberStr:betRows length:1 betType:NO idRandom:NO];
        self.labRedBall.attributedText = bet;
    }else if ([playType isEqualToString:@"前三直选"]) {
        NSAttributedString *bet = [self getBetNumberStr:betRows length:3 betType:NO idRandom:NO];
        self.labRedBall.attributedText = bet;
    }else if([playType isEqualToString:@"前二直选"]){
        NSAttributedString *bet = [self getBetNumberStr:betRows length:2 betType:NO idRandom:NO];
        self.labRedBall.attributedText = bet;
    }else if([playType isEqualToString:@"前三组选"]){
        NSAttributedString *bet = [self getBetNumberStr:betRows length:1 betType:YES idRandom:NO];
        self.labRedBall.attributedText = bet;
    }else if([playType isEqualToString:@"前二组选"]){
        NSAttributedString *bet = [self getBetNumberStr:betRows length:1 betType:YES idRandom:NO];
        self.labRedBall.attributedText = bet;
    }else if([playType isEqualToString:@"组三胆拖"]){
        NSAttributedString *bet = [self getBetNumberStr:betRows length:2 betType:YES idRandom:YES];
        self.labRedBall.attributedText = bet;
    }else if([playType isEqualToString:@"组二胆拖"]){
        NSAttributedString *bet = [self getBetNumberStr:betRows length:2 betType:YES idRandom:YES];
        self.labRedBall.attributedText = bet;
    }else{
        NSAttributedString *bet = [self getBetNumberStr:betRows type:playType betType:[betDic[@"betType"]integerValue]];
        
        self.labRedBall.attributedText = bet;
    }
   
}

-(CGFloat)getCellHeightWith:(NSDictionary*)betDic{
    NSArray *betRows = betDic[@"betRows"];
    NSString *playType = betDic[@"playType"];
    playType = [self getCHNTypeByEnType:playType];
    if ([betDic[@"betType"] integerValue] ==2) {
        if([playType rangeOfString:@"胆拖"].length == 0){
            playType = [NSString stringWithFormat:@"%@胆拖",playType];
        }
    }
    NSAttributedString *bet = [self getBetNumberStr:betRows type:playType betType:[betDic[@"betType"]integerValue]];

    return  [self getTotalHeightredTitle:bet.string] + 60;
}

-(NSAttributedString*)getBetNumberStr:(NSArray *)betRows length:(NSInteger )lenght betType:(BOOL)isTown idRandom:(BOOL)isRandom{
    
    
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc]init];
    
    NSArray *resultArray;
    NSInteger rowNum;
    if (self.trDltOpenResult != nil && ![self.trDltOpenResult isEqualToString:@""]) {
        resultArray = [self.trDltOpenResult componentsSeparatedByString:@","];
    }
        for (int i = 0; i<lenght; i++) {
            rowNum = i;
            if (isRandom == NO) {
                NSArray * danArray = betRows[i];
                NSString *resDanItem = resultArray[i];
                NSInteger numDan = 0;
                for (NSString *itemDan in danArray) {
                    UIColor *titleColor;
                    if ([itemDan integerValue] == [resDanItem integerValue]) {
                        titleColor = TextOrangeColor;

                    }else{
                        titleColor = TEXTGRAYCOLOR;
                    }
                    NSAttributedString * att = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",itemDan] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:titleColor}];
                    
                    [attTitle appendAttributedString:att];
                    numDan ++;
                    if (numDan  < danArray.count) {
                        NSAttributedString * comStr = [[NSAttributedString alloc]initWithString:@"," attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:TEXTGRAYCOLOR}];
                        
                        [attTitle appendAttributedString:comStr];
                    }
                    
                }
                if (rowNum < lenght - 1) {
                    NSAttributedString * comStr = [[NSAttributedString alloc]initWithString:@"#" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:TEXTGRAYCOLOR}];
                    
                    [attTitle appendAttributedString:comStr];
                }
              
            }else{
                NSString *comStr ;
                NSString *endStr ;
                if (isTown && i == 0) {
                    comStr  = @"[胆:";
                    endStr = @"]\n";
                    
                }else{
                    comStr =@"" ;
                    endStr =@"" ;
                }
                NSArray * danArray = betRows[i];
                if (resultArray == nil) {
                        NSInteger numDan = 0;
                        for (NSString *itemDan in danArray) {
                            
                            UIColor *titleColor = TEXTGRAYCOLOR;
                            if (numDan == 0) {
                                NSAttributedString * att = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",comStr,itemDan] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:titleColor}];
                                
                                [attTitle appendAttributedString:att];
                            }else{
                                NSAttributedString * att = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",itemDan] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:titleColor}];
                                
                                [attTitle appendAttributedString:att];
                            }
              
                            
                            if (numDan  < danArray.count - 1) {
                                NSAttributedString * comStr = [[NSAttributedString alloc]initWithString:@"," attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:TEXTGRAYCOLOR}];
                                
                                [attTitle appendAttributedString:comStr];
                            }
                            if (numDan == danArray.count - 1) {
                                NSAttributedString * comStr = [[NSAttributedString alloc]initWithString:endStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:TEXTGRAYCOLOR}];
                                
                                [attTitle appendAttributedString:comStr];
                            }
                            numDan ++;
                        }
                    
                        if (rowNum < lenght - 1 && !isTown) {
                            NSAttributedString * comStr = [[NSAttributedString alloc]initWithString:@"#" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:TEXTGRAYCOLOR}];
                            
                            [attTitle appendAttributedString:comStr];
                        }
                    
                }else{
                        for (NSString *itemDan in danArray) {
                            NSInteger numDan = 0;
                            UIColor *titleColor;
                            BOOL isExit = NO;
//                            for (NSString * resDanItem in resultArray) {
                            NSString * resDanItem = resultArray[i];
                                if ([itemDan integerValue] == [resDanItem integerValue]) {

                                    isExit = YES;
//                                    break;
                    
                                }
//                            }
                            if (isExit) {
                                                                    titleColor = TextOrangeColor;
                            }else{
                                titleColor = TEXTGRAYCOLOR;
                            }
                            if (numDan == 0) {
                                NSAttributedString * att = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",comStr,itemDan] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:titleColor}];
                                
                                [attTitle appendAttributedString:att];
                            }else{
                                NSAttributedString * att = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",itemDan] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:titleColor}];
                                
                                [attTitle appendAttributedString:att];
                            }
                            
                            if (numDan  < danArray.count - 1) {
                                NSAttributedString * comStr = [[NSAttributedString alloc]initWithString:@"," attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:TEXTGRAYCOLOR}];
                                
                                [attTitle appendAttributedString:comStr];
                            }
                            if (numDan == danArray.count - 1) {
                                NSAttributedString * comStr = [[NSAttributedString alloc]initWithString:endStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:TEXTGRAYCOLOR}];
                                
                                [attTitle appendAttributedString:comStr];
                            }
                            numDan ++;
                        
                        if (rowNum < lenght - 1 && !isTown) {
                            NSAttributedString * comStr = [[NSAttributedString alloc]initWithString:@"#" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:TEXTGRAYCOLOR}];
                            
                            [attTitle appendAttributedString:comStr];
                        }
                    }
                }

            }
        }
    return attTitle;
    
}

-(NSAttributedString*)getBetNumberStr:(NSArray *)betRows type:(NSString *)type betType:(NSInteger)betType{
    
    
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc]init];
    
    NSArray *resultArray;
    
    if (self.trDltOpenResult != nil && ![self.trDltOpenResult isEqualToString:@""]) {
        resultArray = [self.trDltOpenResult componentsSeparatedByString:@","];
    }

    NSInteger numDan = 0;
    if (betType  == 2) {
        for (int i = 0; i<betRows.count; i++) {
            NSArray * danArray = betRows[i];
            if (i == 0) {
                
                {
                    
                    [attTitle appendAttributedString:[[NSAttributedString alloc]initWithString:@"[胆：" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:TEXTGRAYCOLOR}]];
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
                        NSAttributedString * att = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",itemDan] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:titleColor}];
                        
                        [attTitle appendAttributedString:att];
                        
                        if (numDan  < danArray.count ) {
                            NSAttributedString * comStr = [[NSAttributedString alloc]initWithString:@"," attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:TEXTGRAYCOLOR}];
                            
                            [attTitle appendAttributedString:comStr];
                        }
                        
                    }
                    numDan = 0 ;
                    
                    [attTitle appendAttributedString:[[NSAttributedString alloc]initWithString:@"]\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:TEXTGRAYCOLOR}]];
                }
            }else{
                
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
                    NSAttributedString * att = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",itemDan] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:titleColor}];
                    
                    [attTitle appendAttributedString:att];
                    
                    if (numDan  < danArray.count) {
                        NSAttributedString * comStr = [[NSAttributedString alloc]initWithString:@"," attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:TEXTGRAYCOLOR}];
                        
                        [attTitle appendAttributedString:comStr];
                    }
                    
                }
                numDan = 0;
            }
            
        }
    }else{
        
        for (int i = 0; i<betRows.count; i++) {
            NSArray * danArray = betRows[i];
            
            if (i == betRows.count -1) {
                {
                    
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
                        NSAttributedString * att = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",itemDan] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:titleColor}];
                        
                        [attTitle appendAttributedString:att];
                        
                        if (numDan  < danArray.count) {
                            NSAttributedString * comStr = [[NSAttributedString alloc]initWithString:@"," attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:TEXTGRAYCOLOR}];
                            
                            [attTitle appendAttributedString:comStr];
                        }
                        
                    }
                    numDan = 0;
                }
            }else{
                
                
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
                    NSAttributedString * att = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",itemDan] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:titleColor}];
                    
                    [attTitle appendAttributedString:att];
                    
                    if (numDan  < danArray.count) {
                        NSAttributedString * comStr = [[NSAttributedString alloc]initWithString:@"," attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:TEXTGRAYCOLOR}];
                        
                        [attTitle appendAttributedString:comStr];
                    }
                    
                }
                numDan = 0;
                NSAttributedString * att = [[NSAttributedString alloc]initWithString:@"#" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:TEXTGRAYCOLOR}];
                
                [attTitle appendAttributedString:att];
                
            }
            
        }
    }
    
    return attTitle;
    
}

-(float)getTotalHeightredTitle:(NSString*)title{
    float redHeight = [title boundingRectWithSize:CGSizeMake(KscreenWidth - 80, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{@"UIFont":[UIFont systemFontOfSize:13]} context:nil].size.height;
    return redHeight;
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

-(NSString *)getCHNTypeByEnType:(NSString*)enStr{
    NSDictionary *enCHNTypeDic = @{@"TopOne":@"前一",
                                   @"EitherTwo":@"任选二",
                                   @"EitherThree":@"任选三",
                                   @"EitherFour":@"任选四",
                                   @"EitherFive":@"任选五",
                                   @"EitherSix":@"任选六",
                                   @"EitherSenven":@"任选七",
                                   @"EitherEight":@"任选八",
                                   @"EitherTwoTowed":@"任选二胆拖",
                                   @"EitherThreeTowed":@"任选三胆拖",
                                   @"EitherFourTowed":@"任选四胆拖",
                                   @"EitherFiveTowed":@"任选五胆拖",
                                   @"EitherSixTowed":@"任选六胆拖",
                                   @"EitherSenvenTowed":@"任选七胆拖",
                                   @"TopTwoDirect":@"前二直选",
                                   @"TopTwoDirectTowed":@"前二直选",
                                   @"TopThreeDirect":@"前三直选",
                                   @"TopThreeDirectTowed":@"前三直选",
                                   @"TopTwoGroup":@"前二组选",
                                   @"TopThreeGroup":@"前三组选",
                                   @"TopTwoGroupTowed":@"组二胆拖",
                                   @"TopThreeGroupTowed":@"组三胆拖",
                                   @"TopTwoDirectDouble":@"前二直选定位复式",
                                   @"LeTwo":@"乐选二",
                                   @"LeThree":@"乐选三",
                                   @"LeFour":@"乐选四",
                                   @"LeFive":@"乐选五"
                                   
                                   
                                   };
    NSString *chnName = enCHNTypeDic[enStr];
    if (chnName != nil) {
        return chnName;
    }else{
        return @"陕西11选5";
    }
    
}

+(NSString *)X115CHNTypeByEnType:(NSString*)enStr{
    X115SchemeViewCell *cell = [X115SchemeViewCell new];
    return [cell getCHNTypeByEnType:enStr];
}

@end
