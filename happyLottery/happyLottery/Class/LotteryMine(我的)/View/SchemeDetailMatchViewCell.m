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
    
    __weak IBOutlet NSLayoutConstraint *disBottomL;
    __weak IBOutlet UIButton *btnNumIndex;
    __weak IBOutlet UILabel *labBottom;
    __weak IBOutlet NSLayoutConstraint *disTopL;
    __weak IBOutlet NSLayoutConstraint *disBottomR;
    __weak IBOutlet UIView *topInfoView;
    __weak IBOutlet UIView *viewBetContent;
    __weak IBOutlet UILabel *labGuestName;
    __weak IBOutlet UILabel *labHomeName;
    __weak IBOutlet UILabel *labMatchLine;
    
    __weak IBOutlet NSLayoutConstraint *topInfoViewHeight;
    __weak IBOutlet MGLabel *labResult;
    __weak IBOutlet UILabel *labBeiCount;
    __weak IBOutlet UILabel *labPassType;
    NSArray *itemDic;
    __weak IBOutlet NSLayoutConstraint *disTopR;
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
-(void)refreshData:(JcBetContent  *)modelDic andResult:(NSArray<OpenResult *> *)resultArray{
    for (UIView *subView in viewBetContent.subviews) {
        [subView removeFromSuperview];
        
    }
    
    if (modelDic.isShow) {
        topInfoView.hidden = NO;
        [btnNumIndex setTitle:[NSString stringWithFormat:@"%ld",modelDic.index] forState:0];
        NSArray *passType = [Utility objFromJson:modelDic.passTypes];
        topInfoViewHeight.constant =  ((passType.count / 7) + 1) * 15 + 50;
        labBeiCount.text = [NSString stringWithFormat:@"%@倍",modelDic.multiple];
        labPassType.text = [self getChuanFa:modelDic.passTypes];
        
        disTopL.constant = 8;
        disTopR.constant = 8;
        
        disBottomL.constant = 0;
        disBottomR.constant = 0;
        labBottom.hidden = YES;
        
    }else{
        topInfoView.hidden = YES;
        topInfoViewHeight.constant = 0;
        
        if (modelDic.isLast == YES) {
            disTopL.constant = 0;
            disTopR.constant = 0;
            
            disBottomL.constant = 7;
            disBottomR.constant = 7;
            labBottom.hidden = NO;
        }else{
            disTopL.constant = 0;
            disTopR.constant = 0;
            
            disBottomL.constant = 0;
            disBottomR.constant = 0;
            labBottom.hidden = YES;
        }
        
      
    }
    
    OpenResult *open;
    for (OpenResult *openItem in resultArray) {
        if ([openItem.matchKey integerValue] == [modelDic.matchInfo[@"matchKey"] integerValue]) {
            open = openItem;
        }
    }
    
    labMatchLine.text = modelDic.matchInfo[@"matchId"];
    labHomeName.text = [[modelDic.matchInfo[@"clash"] componentsSeparatedByString:@"VS"] firstObject];
    labGuestName.text = [[modelDic.matchInfo[@"clash"] componentsSeparatedByString:@"VS"] lastObject];
    
    if (modelDic.virtualSp != nil) {
        itemDic = [Utility objFromJson:modelDic.virtualSp];
    }else{
        itemDic = nil;
    }
    
    NSString *playType;
    NSString *option;
    NSString *result;
    float curY = 5;
    
    viewBetContent.mj_w = KscreenWidth - 20;
    for (NSDictionary *itemDic in modelDic.matchInfo[@"betPlayTypes"]) {
        
        option = [self reloadDataWithRec:itemDic[@"options"] type:itemDic[@"playType"] andMatchKey:modelDic.matchInfo[@"matchKey"]];

       
        NSString *funcName = [self getPlayTypeRecEn:itemDic[@"playType"]] ;
        SEL func = NSSelectorFromString(funcName);
        if ([open respondsToSelector:func]) {
            result = [self reloadDataWithRecResult:@[[open performSelector:func withObject:nil]] type:itemDic[@"playType"]];
        }
        
        float height = [option boundingRectWithSize:CGSizeMake(KscreenWidth - 110, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        height  = height > 25 ? height:25;
        MGLabel * labOption = [self creactLab:option andFrame:CGRectMake(90, curY, KscreenWidth - 110, height)];
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
        labResult.text = @"赛果:--:--";
    }else{
        if ([open.matchStatus isEqualToString:@"CANCLE"]) {
            labResult.text = @"赛果:取消";
        }else if ([open.matchStatus isEqualToString:@"PAUSE"]){
            labResult.text = @"赛果:暂停";
        }else{
            labResult.text = [NSString stringWithFormat:@"赛果:%@:%@",open.homeScore,open.guestScore];
        }
        
    }
    
    labResult.keyWordColor = SystemBlue;
}

-(NSString *)getOddWithOption:(NSString *)option matchKey:(NSString *)matchKey andPlayType:(NSInteger )playType{
    
    NSArray *oddsArray = itemDic;
    for (NSDictionary *itemDic in oddsArray) {
        if ([itemDic[@"matchKey"] integerValue] == [matchKey integerValue]) {
            NSArray *oddsList = [Utility objFromJson:itemDic[@"jcBetOddsList"]];
            for (NSDictionary *odds in oddsList) {
                if ([odds[@"playType"] integerValue] == playType) {
                    NSDictionary *itemOdds = odds[@"odds"];
                    return itemOdds[option];
                }
            }
       
        }
    }
    return @"";
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
        
        self.num ++;
    }
    
    
    
    if (content.length >1) {
        return content;
    }
    return @"";
}

-(NSString *)reloadDataWithRec:(NSArray *)option type:(NSString *)playType andMatchKey:(NSString *)matchKey{
    
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
        
        if (itemDic != nil) {
            [content appendString:[NSString stringWithFormat:@"(%.2f)",[[self getOddWithOption:op matchKey:matchKey andPlayType:[playType integerValue]] doubleValue] ]];
        }
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

-(NSString *)getChuanFa:(NSString *)strChuanfa{
    NSString *chuanfa;
    NSInteger rownum;
    if (KscreenWidth == 568) {
        rownum = 5;
    }else{
        rownum = 7;
    }
    
    
        NSString *item;
        float height = 0;
    
                NSArray *passTypes = [Utility objFromJson:strChuanfa];
                item = [passTypes componentsJoinedByString:@","];
    
                if (passTypes.count %rownum == 0) {
                    height += passTypes.count/rownum *20;
                }else{
                    height += (passTypes.count/rownum + 1) *18;
                }
        
        chuanfa =[self getPassType:item];
    return chuanfa;
}

-(NSString *)getPassType:(NSString *)passType{
    
    
    
    @try {
        NSArray *passTypes = [passType componentsSeparatedByString:@","];
        NSString *trPassType;
        NSMutableArray *types = [NSMutableArray arrayWithCapacity:0];
        
        for (NSString *type in passTypes) {
            if ([type isEqualToString:@"P1"]) {
                [types addObject: @"单场"];
            }else{
                
                NSString * temp  = [type stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
                
                [types addObject:[temp stringByReplacingOccurrencesOfString:@"_" withString:@"串"]];
            }
        }
        
        trPassType = [types componentsJoinedByString:@","];
        
        
        return trPassType;
    } @catch (NSException *exception) {
        return @"";
    }
    
}

@end
