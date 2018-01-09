//
//  SchemeDetailMatchViewCell.m
//  happyLottery
//
//  Created by 王博 on 2018/1/5.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//


#import "SchemeDetailMatchViewCell.h"
#import "MGLabel.h"

@interface SchemeDetailMatchViewCell ()
{
    
    __weak IBOutlet UIView *viewBetContent;
    __weak IBOutlet UILabel *labGuestName;
    __weak IBOutlet UILabel *labHomeName;
    __weak IBOutlet UILabel *labMatchLine;
    
    __weak IBOutlet MGLabel *labResult;
}

@property(nonatomic,assign)NSInteger num;
@end

@implementation SchemeDetailMatchViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SchemeDetailMatchViewCell" owner: nil options:nil] lastObject];
    }
    return self;
}
-(void)refreshData:(NSDictionary  *)modelDic{
    for (UIView *subView in viewBetContent.subviews) {
        [subView removeFromSuperview];
        
    }
    
    labMatchLine.text = modelDic[@"matchId"];
    labHomeName.text = [[modelDic[@"clash"] componentsSeparatedByString:@"VS"] firstObject];
    labGuestName.text = [[modelDic[@"clash"] componentsSeparatedByString:@"VS"] lastObject];
    viewBetContent.layer.borderColor = TFBorderColor.CGColor;
    viewBetContent.layer.borderWidth = 1;
    NSString *playType;
    NSString *option;
    float curY = 5;
    for (NSDictionary *itemDic in modelDic[@"betPlayTypes"]) {
        
        option = [self reloadDataWithRec:itemDic[@"options"] type:itemDic[@"playType"]];
        float height = [option boundingRectWithSize:CGSizeMake(KscreenWidth - 90, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.height;
        height  = height > 25 ? height:25;
        UILabel * labOption = [self creactLab:option andFrame:CGRectMake(90, curY, viewBetContent.mj_w - 90, height)];
        labOption.textColor = SystemRed;
        [viewBetContent addSubview:labOption];
        
        playType = [self getPlayTypeRec:itemDic[@"playType"]];
        UILabel * labPlayType = [self creactLab:playType andFrame:CGRectMake(5, curY, 80, height)];
        labPlayType.textColor = SystemBlue;
        [viewBetContent addSubview:labPlayType];
        

        curY += height;
    }
    
    labResult.textColor = SystemRed;
    labResult.keyWord = @"赛果:";
    labResult.text = @"赛果:3:1";
    labResult.keyWordColor = SystemBlue;
}


-(MGLabel*)creactMGLab:(NSString *)title andFrame:(CGRect)frame{
    
    MGLabel *tempLab = [[MGLabel alloc]initWithFrame:frame];
    tempLab.text = title;
    tempLab.textAlignment = NSTextAlignmentCenter;
    tempLab.font = [UIFont systemFontOfSize:15];
    tempLab.textColor = TEXTGRAYCOLOR;
    tempLab.adjustsFontSizeToFitWidth = YES;
    tempLab.numberOfLines = 0;
    return tempLab;
    
}

-(UILabel*)creactLab:(NSString *)title andFrame:(CGRect)frame{
    
    UILabel *tempLab = [[UILabel alloc]initWithFrame:frame];
  
        tempLab.text = title;
    
        tempLab.font = [UIFont systemFontOfSize:13];
    tempLab.textColor = TEXTGRAYCOLOR;
    tempLab.numberOfLines = 0;
    return tempLab;
    
}


-(NSString *)getPlayTypeRec:(NSString *)playType{
    
    NSString*playTypeStr ;
    switch ([playType integerValue]) {
        case 1:
            playTypeStr = @"胜平负:";
            
            break;
        case 5:
            playTypeStr = @"让胜平负:";
            
            
            break;
        case 4:
            playTypeStr = @"半全场:";
            break;
        case 2:
      
            playTypeStr = @"进球数:";
            
            break;
        case 3:
            
            playTypeStr = @"比分:";
            
            break;
        default:
            break;
    }
    return playTypeStr;
}

-(NSString *)reloadDataWithRec:(NSArray *)option type:(NSString *)playType{
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"JingCaiCode" ofType: @"plist"]] ;
    NSDictionary *contentArray;
    NSInteger index;
    NSMutableString*content = [NSMutableString string];
    switch ([playType integerValue]) {
        case 1:
            index = 100;
            contentArray = dic[@"SPF"];
            
            break;
        case 5:
            index = 200;
            contentArray = dic[@"RQSPF"];
            
            break;
        case 4:
            index = 400;
            contentArray = dic[@"BQC"];
            
            break;
        case 2:
            index = 500;
            contentArray = dic[@"JQS"];
            
            break;
        case 3:
            index = 300;
            contentArray = dic[@"BF"];
            
            break;
        default:
            break;
    }
    
    for (NSString *op in option) {
        
        NSString*type = [self getContentJCZQ:contentArray andOption:op];
        [content appendFormat:@"%@",type];
        [content appendString:@", "];
        self.num ++;
    }
    
    
    
    if (content.length >1) {
        return content;
    }
    return @"";
}

-(NSString*)getContentJCZQ:(NSDictionary*)contentArray andOption:(NSString*)option{
    for (NSDictionary *dic in contentArray.allValues) {
        if ([dic[@"code"] integerValue]  == [option integerValue]) {
            return dic[@"appear"];
        }
    }
    return nil;
}
@end
