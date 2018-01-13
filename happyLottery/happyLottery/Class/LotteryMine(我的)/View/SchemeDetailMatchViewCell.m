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
-(void)refreshData:(NSDictionary  *)modelDic andResult:(NSArray<OpenResult *> *)resultArray{
    for (UIView *subView in viewBetContent.subviews) {
        [subView removeFromSuperview];
        
    }
    
    OpenResult *open;
    for (OpenResult *openItem in resultArray) {
        if ([openItem.matchKey isEqualToString:modelDic[@"matchKey"]]) {
            open = openItem;
        }
    }
    
    labMatchLine.text = modelDic[@"matchId"];
    labHomeName.text = [[modelDic[@"clash"] componentsSeparatedByString:@"VS"] firstObject];
    labGuestName.text = [[modelDic[@"clash"] componentsSeparatedByString:@"VS"] lastObject];
    viewBetContent.layer.borderColor = TFBorderColor.CGColor;
    viewBetContent.layer.borderWidth = 1;
    NSString *playType;
    NSString *option;
    NSString *result;
    float curY = 5;
    viewBetContent.mj_w = KscreenWidth - 20;
    for (NSDictionary *itemDic in modelDic[@"betPlayTypes"]) {
        
        option = [self reloadDataWithRec:itemDic[@"options"] type:itemDic[@"playType"]];
//        NSString *
        NSString *funcName = [self getPlayTypeRecEn:itemDic[@"playType"]] ;
        SEL func = NSSelectorFromString(funcName);
        if ([open respondsToSelector:func]) {
            result = [self reloadDataWithRecResult:@[[open performSelector:func withObject:nil]] type:itemDic[@"playType"]];
        }
        
        
        float height = [option boundingRectWithSize:CGSizeMake(KscreenWidth - 110, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        height  = height > 25 ? height:25;
        MGLabel * labOption = [self creactLab:option andFrame:CGRectMake(90, curY, KscreenWidth - 110, height)];
//        labOption.textColor = TEXTGRAYCOLOR;
        labOption.keyWord = result;
        labOption.keyWordColor = SystemRed;
        [viewBetContent addSubview:labOption];
        
        playType = [self getPlayTypeRec:itemDic[@"playType"]];
        MGLabel * labPlayType = [self creactLab:playType andFrame:CGRectMake(5, curY, 80, height)];
        labPlayType.textColor = SystemBlue;
        [viewBetContent addSubview:labPlayType];

        curY += height;
    }
    
    labResult.textColor = SystemRed;
    labResult.keyWord = @"赛果:";
    if (open == nil) {
        labResult.text = @"赛果:未知";
    }else{
        labResult.text = [NSString stringWithFormat:@"赛果:%@:%@",open.homeScore,open.guestScore];
    }
    
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

-(MGLabel*)creactLab:(NSString *)title andFrame:(CGRect)frame{
    
    MGLabel *tempLab = [[MGLabel alloc]initWithFrame:frame];
  
        tempLab.text = title;
    
        tempLab.font = [UIFont systemFontOfSize:13];
    tempLab.textColor = TEXTGRAYCOLOR;
    tempLab.numberOfLines = 0;
    return tempLab;
    
}

-(NSString *)getPlayTypeRecEn:(NSString *)playType{
    
    NSString*playTypeStr ;
    switch ([playType integerValue]) {
        case 1:
            playTypeStr = @"SPF";
            
            break;
        case 5:
            playTypeStr = @"RQSPF";
            
            
            break;
        case 4:
            playTypeStr = @"BQC";
            break;
        case 2:
            
            playTypeStr = @"JQS";
            
            break;
        case 3:
            
            playTypeStr = @"BF";
            
            break;
        default:
            break;
    }
    return playTypeStr;
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

-(NSString *)reloadDataWithRecResult:(NSArray *)option type:(NSString *)playType{
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"JingCaiOrderCode" ofType: @"plist"]] ;
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
            index = 300;
            contentArray = dic[@"JQS"];
            
            break;
        case 3:
            index = 500;
            contentArray = dic[@"BF"];
            
            break;
        default:
            break;
    }
    
    for (NSString *op in option) {
        
        NSString*type = [self getContent:contentArray andOption:op];
        [content appendFormat:@"%@",type];
        [content appendString:@", "];
        self.num ++;
    }
    
    
    
    if (content.length >1) {
        return content;
    }
    return @"";
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

-(NSString*)getContent:(NSDictionary*)contentArray andOption:(NSString*)option{
    for (NSDictionary *dic in contentArray.allValues) {
        if (dic[option] != nil) {
            return dic[option];
        }
    }
    return @"";
}

@end
