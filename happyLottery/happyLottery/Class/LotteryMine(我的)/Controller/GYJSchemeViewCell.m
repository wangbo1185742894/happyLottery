//
//  JCLQSchemeViewCell.m
//  Lottery
//
//  Created by 王博 on 17/4/25.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "GYJSchemeViewCell.h"
#import "LotteryManager.h"
#import "WordCupHomeItem.h"
#import "LotteryScheme.h"
@interface GYJSchemeViewCell()<LotteryManagerDelegate>
{
    NSMutableArray  *groupList;
}
@property(nonatomic,assign)NSInteger num;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLabchuanfa;
@property(nonatomic,strong)LotteryManager *lotteryMan;

@end


@implementation GYJSchemeViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"GYJSchemeViewCell" owner:nil options:nil] lastObject];
    }
    self.num = 0;
    self.labZhuBei.adjustsFontSizeToFitWidth = YES;
    return self;
}

- (void) gotlistJcgyjItem:(NSArray *)infoArray  errorMsg:(NSString *)msg{
    
    [self gotlistJcgjItem:infoArray errorMsg:msg];
}

-(void)refreshDataWith:(LotteryScheme *)scheme{
    
    if (_lotteryMan == nil) {
        _lotteryMan = [[LotteryManager alloc]init];
        _lotteryMan.delegate = self;
    }
    
    if ([scheme.lottery isEqualToString:@"JCGYJ"]) {
        [self.lotteryMan listJcgyjItem:nil];
    }else{
        [self.lotteryMan listJcgjItem:nil];
    }
    
    if (scheme.betContent!=nil&&scheme.betContent.length>0) {
        self.labZhuBei.text = [NSString stringWithFormat:@"(%@注%@倍)",scheme.units, scheme.multiple];
    } else {
        self.labZhuBei.text = @"";
    }
    
    if ([NSString stringWithFormat:@"%@",scheme.ticketCount].integerValue > 0){
        self.btnToOrderDetail.hidden = NO;
          [self.btnToOrderDetail setTitle:[NSString stringWithFormat:@"出票:%@/%@(单)",scheme.printCount,scheme.ticketCount] forState:UIControlStateNormal];
    }else{
        self.btnToOrderDetail.hidden = YES;
    }
    self.scheme = scheme;
    
    NSString *gyjTitle;
    if ([scheme.lottery isEqualToString:@"JCGYJ"]) {
        gyjTitle = @"冠亚军球队";
    }else{
        gyjTitle = @"冠军球队";
    }
    
    NSArray *titleArray = @[@"序号",gyjTitle];
    NSArray *widthArray = @[@(50),@(KscreenWidth - 150)];
    NSArray *curXArray = @[@(0),@(50)];
    CGFloat curY = 0;
    for (int i = 0; i < titleArray.count; i++) {
        UILabel *lab = [self creactLab:titleArray[i] andFrame:CGRectMake([curXArray[i] floatValue], curY, [widthArray[i] floatValue], 29)];
        [self.betcontentView addSubview:lab];
    }
    curY += 29;
    UILabel *lab2 = [self creactLab:@"" andFrame:CGRectMake(0, curY, KscreenWidth , 0.5)];
    lab2.backgroundColor = RGBCOLOR(200, 200, 200);
    [self.betcontentView addSubview:lab2];
    
    
}

- (void) gotlistJcgjItem:(NSArray *)infoArray  errorMsg:(NSString *)msg{
    
    if (infoArray == nil) {
        return;
    }
    if (groupList == nil) {
        groupList = [NSMutableArray arrayWithCapacity:0];
    }
    [groupList removeAllObjects];
    for (int i = 0 ; i < infoArray.count; i++ ) {
        NSDictionary *itemDic = infoArray[i];
        WordCupHomeItem *model = [[WordCupHomeItem alloc]initWith:itemDic];
        [groupList addObject:model];
    }
    
    NSDictionary * selectArray = [[Utility objFromJson:self.scheme.betContent] firstObject][@"number"];
    CGFloat curY = 30;
    for (NSString *num in selectArray) {
        for (WordCupHomeItem *item in groupList) {
            if ([item.indexNumber integerValue] == [num integerValue]) {
                UILabel *lab = [self creactLab:item.indexNumber andFrame:CGRectMake(0, curY, 50, 30)];
                // “冠军-亚军” 替换成 “冠军   VS   亚军”
                if (item.yaKey!= nil) {
                    item.clash = [item.clash stringByReplacingOccurrencesOfString:@"—" withString:@"   VS   "];
                }
                UILabel *lab1 = [self creactLab:item.clash andFrame:CGRectMake(50, curY, KscreenWidth - 150, 30)];
                [self.betcontentView addSubview:lab1];
                [self.betcontentView addSubview:lab];
                curY +=29;
                UILabel *lab2 = [self creactLab:@"" andFrame:CGRectMake(0, curY, KscreenWidth , 1)];
                lab2.backgroundColor = RGBCOLOR(200, 200, 200);
                [self.betcontentView addSubview:lab2];
                curY += 1;
            }
        }
    }
}

-( NSString *)reloadDataWithRec:(NSArray *)option type:(NSString *)playType{
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"JCLQCode" ofType: @"plist"]] ;
    NSArray *contentArray;
    
    NSMutableString*content = [NSMutableString string];
    
    switch ([playType integerValue]) {
        case 1:
        contentArray = dic[@"SF"];
       
        break;
        case 2:
        contentArray = dic[@"RFSF"];
        
        break;
        case 4:
        contentArray = dic[@"DXF"];
       
        break;
        case 3:
        contentArray = dic[@"SFC"];
        
        break;
        default:
        break;
    }
    
    for (NSString *op in option) {
    
        NSString*type = [self getContent:contentArray andOption:op];
        [content appendFormat:@"%@",type];
        [content appendString:@"\n"];
        self.num ++;
    }
    
    
    
    if (content.length >1) {
        return content;
    }
    return @"";
    
}

-(NSString *)getOpenResultByPlayType:(NSString *)playType resultDic:(NSDictionary*)openDic{
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"JCLQCode" ofType: @"plist"]] ;
    NSArray *contentArray;
     NSString *strResult ;
    
    switch ([playType integerValue]) {
        case 1:
            contentArray = dic[@"SF"];
            strResult = openDic[@"SF"];
            
            break;
        case 2:
            contentArray = dic[@"RFSF"];
            strResult = openDic[@"RFSF"];
            
            break;
        case 4:
            contentArray = dic[@"DXF"];
            strResult = openDic[@"DXF"];
            
            break;
        case 3:
            contentArray = dic[@"SFC"];
            strResult = openDic[@"SFC"];
            
            break;
        default:
            break;
    }
    
    if (strResult == nil) {
        return  @"";
    }
    for (NSDictionary *dic in contentArray) {
        for (NSString *key in dic.allKeys) {
            if ([strResult isEqualToString:key]) {
                return dic[strResult];
            }
        }
    }
    
    return @"";
}

-(NSString*)getContent:(NSArray*)contentArray andOption:(NSString*)option{
    for (NSDictionary *dic in contentArray) {
       NSInteger type =  [dic[@"code"] integerValue]%100;
        if (type == [option integerValue]) {
            return dic[@"appear"];
        }
    }
    return @"";
}

- (IBAction)actionToDetail:(UIButton *)sender {
    
    [self.delegate actionToDetail:self.scheme.schemeNO];
}

-(void)setBtnDetailHiden:(BOOL)isHiden{

    self.btnToOrderDetail.hidden = isHiden;
}

@end
