//
//  CTZQSchemeViewCell.m
//  Lottery
//
//  Created by 王博 on 17/4/25.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "CTZQSchemeViewCell.h"

@implementation CTZQSchemeViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CTZQSchemeViewCell" owner:nil options:nil] lastObject];
    }
    self.labBeiZhu.adjustsFontSizeToFitWidth = YES;
    return self;
}

-(void)refreshDataWith:(JCZQSchemeItem*)scheme{
    self.btnToOrderDetail.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.scheme = scheme;
    self.labBeiZhu.text = [NSString stringWithFormat:@"(%@注%@倍)",scheme.units, scheme.multiple];
 
    if ([NSString stringWithFormat:@"%@",scheme.ticketCount].integerValue > 0){
        self.btnToOrderDetail.hidden = NO;
          [self.btnToOrderDetail setTitle:[NSString stringWithFormat:@"出票:%@/%@(单)",scheme.printCount,scheme.ticketCount] forState:UIControlStateNormal];
    }else{
        self.btnToOrderDetail.hidden = YES;
    }
    
    self.labBaoMi.hidden = YES;
    
    NSArray  * matches = [self objFromJson: scheme.betContent ] ;
    NSDictionary *betcontent = [matches firstObject];
    NSArray *betMatches = betcontent[@"betMatches"];
    float curX = 3;
    float curY = 3;
    float height = 25;
    float width = (KscreenWidth - 16 -6 -26)/14;
    NSArray *openArray =[scheme.trDltOpenResult  componentsSeparatedByString:@","];
    
    for (int i = 0; i < 14; i++) {
        id obj = [self  getMatch:betMatches index:i];
        if ([obj isKindOfClass:[NSString class]]) {  //未选中的
            curY = width + 6;
            UILabel *noLab = [self creactLab:@"*" andFrame:CGRectMake(curX, curY, width, height)];
            noLab.backgroundColor = [UIColor lightGrayColor];
            noLab.textColor = [UIColor whiteColor];
            curX += width + 2;
            curY = 3;
            [self.betcontentView addSubview:noLab];
            
        }else{// 选中
            
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary * matchDic = obj;
                BOOL isDan = [matchDic[@"dan"] boolValue];
                
                UIImage *dan;
                if (isDan) {
                    BOOL isHit = NO;
                    for (NSString *title in matchDic[@"options"]) {
                        if ([title isEqualToString:openArray[i]] || [@"--" isEqualToString:openArray[i]]) {
                            isHit = YES;
                            break;
                        }
                    }
                    if (isHit) {
                        dan =[UIImage imageNamed:@"dan_Win.png"];
                    }else{
                        dan =[UIImage imageNamed:@"dan_notWin.png"];
                    }
                }else{
                    dan = nil;
                }
                UIImageView *imgDan = [[UIImageView alloc]initWithFrame:CGRectMake(curX, curY, width, width)];
                imgDan.image = dan;
            
                [self.betcontentView addSubview:imgDan];
                curY += width + 3;

                for (NSString *title in matchDic[@"options"]) {
                    UILabel *lab = [self creactLab:title andFrame:CGRectMake(curX, curY, width, height)];
                    if ([title isEqualToString:openArray[i]] || [@"--" isEqualToString:openArray[i]]) {
                        lab.backgroundColor =SystemGreen;
                        lab.textColor = [UIColor whiteColor];
                    }else{
                        lab.backgroundColor = [UIColor lightGrayColor];
                        lab.textColor = [UIColor whiteColor];
                    }
                    
                    [self.betcontentView addSubview:lab];
                    
                    curY += width + 3;
                    
                }
                curY = 3;
            }
             curX += width + 2;
        }
       
    }
    
}

-(id)getMatch:(NSArray *)betcontent index:(NSInteger)_id{
    
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_id+1];
    for (NSDictionary *dic in betcontent) {
        
        if ([index isEqualToString:[NSString stringWithFormat:@"%@",dic[@"matchId"]]]) {
            return dic;
        }
    }
    return @"*";
}

- (IBAction)actionToDetail:(UIButton *)sender {
    
    [self.delegate actionToDetail:self.scheme.schemeNO];
}
-(void)setBtnDetailHiden:(BOOL)isHiden{
    
    self.btnToOrderDetail.hidden = isHiden;
}
@end
