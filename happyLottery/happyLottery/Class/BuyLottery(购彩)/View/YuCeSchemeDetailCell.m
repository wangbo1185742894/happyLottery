//
//  YuCeSchemeDetailCell.m
//  Lottery
//
//  Created by onlymac on 2017/10/16.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "YuCeSchemeDetailCell.h"


@implementation YuCeSchemeDetailCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *CellID = @"YuCeSchemeDetailCell";
    YuCeSchemeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:CellID owner:nil options:nil] lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}


-(void)refreshData:(jcBetContent *)scheme{

    NSArray *array = [scheme.clash componentsSeparatedByString:@"VS"];
    self.zhuDuiLabel.text = [NSString stringWithFormat:@"%@(主)",array[0]] ;
    self.zhuDuiLabel.keyWord = @"(主)";
    self.zhuDuiLabel.keyWordFont = [UIFont systemFontOfSize:13];
    self.zhuDuiLabel.keyWordColor = SystemLightGray;
    self.keDuiLabel.text = array[1];
    NSString *weekStr = [scheme.matchId substringWithRange:NSMakeRange(0, 2)];
    NSString *numStr = [scheme.matchId substringWithRange:NSMakeRange(2, 3)];
    self.weekLabel.text = weekStr;
    self.numLabel.text = numStr;
    
    for (YCbetPlayTypes *model in scheme.betPlayTypes) {
        self.touzhuneirongLabel.text = [self reloadDataWithRec:model.options type:model.playType];
        self.wangfaLabel.text = [self getWanFaWithPlayType:model.playType];
    }
   
    
    
    
    
   
}

- (NSString *)getWanFaWithPlayType:(NSString *)playType{
//    self.rqshuLabel.hidden = YES;
//    self.topwangFaConstraints.constant = 29;
    NSString*content = [NSString string];
    switch ([playType integerValue]) {
        case 1:
            content = @"胜平负";
            
            break;
        case 5:
            content = @"让球胜平负";
//            self.rqshuLabel.hidden = NO;
//            self.topwangFaConstraints.constant = 30;
            break;
        case 4:
            content = @"半全场";
            
            break;
        case 2:
            content = @"进球数";
            break;
        case 3:
            content = @"比分";
            break;
        default:
            break;
    }
    
    if (content.length >1) {
        NSMutableString  *content1 = [NSMutableString stringWithFormat:@"%@",content];
        return content1;
    }
    return @"";
    
    
    
  
}

-(NSString *)reloadDataWithRec:(NSArray *)option type:(NSString *)playType{
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"JingCaiCode" ofType: @"plist"]] ;
    
    NSDictionary *contentArray;
    NSInteger index;
    NSString*content = [NSString string];
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
            index = 300;
            contentArray = dic[@"BQC"];
            
            break;
        case 2:
            index = 400;
            contentArray = dic[@"JQS"];
            
            break;
        case 3:
            index = 500;
            contentArray = dic[@"BF"];
            
            break;
        default:
            break;
    }
    
    NSMutableArray *mArray;
    for (NSString *op in option) {
        mArray = [NSMutableArray arrayWithCapacity:0];
        
        [mArray addObject: [self getContentJCZQ:contentArray andOption:op]];
        self.num ++;
    }
    content =[mArray componentsJoinedByString:@"\n"];
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
