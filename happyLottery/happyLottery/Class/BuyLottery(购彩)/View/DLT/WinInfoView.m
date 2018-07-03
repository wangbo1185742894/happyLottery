//
//  WinInfoView.m
//  Lottery
//
//  Created by Yang on 15/7/8.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import "WinInfoView.h"

#define CellH 30

@implementation WinInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (UILabel *)lable:(CGRect)fram textColor:(UIColor *)color text:(NSString *)text textAligment:(int)aligment{
    
    UILabel * lable = [[UILabel alloc] initWithFrame:fram];
    lable.textColor = color;
    lable.textAlignment = aligment;
    lable.numberOfLines  = 0;
    lable.text = text;
    lable.numberOfLines = 0;
    lable.adjustsFontSizeToFitWidth = YES;
    lable.backgroundColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:13];
    return lable;
}

- (UILabel *)lableFrame:(CGRect)frame  withColor:(UIColor *)textColor{

    UILabel * lable = [[UILabel alloc] initWithFrame:frame];
    lable.textColor = textColor;
    lable.numberOfLines = 0;
    lable.lineBreakMode = NSLineBreakByCharWrapping;
    lable.textAlignment = NSTextAlignmentLeft;
    lable.font = [UIFont systemFontOfSize:13];
    lable.backgroundColor = [UIColor clearColor];
    return lable;
}

- (UIView *)forJCitemViewWithInfo:(NSArray *)orderInfoArray withPositionY:(float)y{
    /*{
        "prizeDataList" :[{
                  "afterTaxPrize" : 652.88,
                  "formula" : "1.85x1.84x6.85x3.5x2x4",
                  "prize" : 163.22,
                  "prizePassType" : 4,
                  "winUnits" : 4,
                  "won" : true
                   },
                        {
                  "afterTaxPrize" : 186.53,
                  "formula" : "1.85x1.84x6.85x2x4",
                  "prize" : 186.53,
                  "prizePassType" : 3,
                  "winUnits" : 4,
                  "won" : true
                  }],
     "totalAfterTaxPrize" : 839.41,
     "totalPrize" : 839.41,
     "totalWinUnits" : 8,
     "won" : true
     }
*/
    float curY =0;
    UIView * subContent = [[UIView alloc] initWithFrame:CGRectMake(10, y, self.frame.size.width-20, 0)];
    [self addSubview:subContent];
    
    for (int i=0; i<orderInfoArray.count; i++) {
        NSDictionary * orderInfo = orderInfoArray[i];
        UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, curY, CGRectGetWidth(subContent.frame), 25)];
        
            curY += titleView.frame.size.height;
            float titleLbSpading = 0.5;
            float titleLbW = (CGRectGetWidth(titleView.frame)-4*titleLbSpading) / 3.0;
            float titleLbH = CGRectGetHeight(titleView.frame) - 2*titleLbSpading;
        
         UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, curY, CGRectGetWidth(subContent.frame), (titleLbH+2)*(orderInfoArray.count))];
        
        NSString *prizePassType = [NSString stringWithFormat:@"%@关",orderInfo[@"prizePassType"]];
            [contentView addSubview:[self lable:CGRectMake(titleLbSpading, /*titleLbSpading*/(titleLbH*i+(i+1)), titleLbW, titleLbH) textColor:TEXTGRAYCOLOR text:prizePassType textAligment:NSTextAlignmentCenter]];
            [contentView addSubview:[self lable:CGRectMake(titleLbSpading*2+titleLbW, /*titleLbSpading*/(titleLbH*i)+(i+1), titleLbW, titleLbH) textColor:[UIColor redColor] text:orderInfo[@"formula"] textAligment:NSTextAlignmentCenter]];
        
        
        //NSString *prize = [NSString stringWithFormat:@"%.2f",[orderInfo[@"prize"]doubleValue]];
            NSString *prize = [NSString stringWithFormat:@"%.2f",[orderInfo[@"afterTaxPrize"]doubleValue]];
            [contentView addSubview:[self lable:CGRectMake(titleLbSpading*3+titleLbW*2, /*titleLbSpading*/(titleLbH*i)+(i+1), titleLbW, titleLbH) textColor:[UIColor redColor] text:prize textAligment:NSTextAlignmentCenter]];
        
        contentView.backgroundColor = [UIColor grayColor];
        [subContent addSubview:contentView];
        
        if(0 == i)
        {
            [titleView addSubview:[self lable:CGRectMake(titleLbSpading+25, curY-titleView.frame.size.height, CGRectGetWidth(subContent.frame), 20) textColor:TEXTGRAYCOLOR text:@"过关方式" textAligment:NSTextAlignmentLeft]];
            
            [titleView addSubview:[self lable:CGRectMake(titleLbSpading*2+titleLbW+25, curY-titleView.frame.size.height, CGRectGetWidth(subContent.frame), 20) textColor:TEXTGRAYCOLOR text:@"中奖信息" textAligment:NSTextAlignmentLeft]];
            
            [titleView addSubview:[self lable:CGRectMake(titleLbSpading*3+titleLbW*2+28, curY-titleView.frame.size.height, CGRectGetWidth(subContent.frame), 20) textColor:TEXTGRAYCOLOR text:@"金额" textAligment:NSTextAlignmentLeft]];
            [subContent addSubview:titleView];
        }
        curY += 50;
}
    
    CGRect frame =  subContent.frame;
    frame.size.height = curY;
    subContent.frame = frame;
    return subContent;
}

- (UIView *)forDltOrX115itemViewWithInfo:(NSDictionary *)orderInfo withPositionY:(float)y{
    //[{\"afterTaxPrize\":24.00,\"prize\":12,\"prizeType\":\"H2\",\"ticketID\":\"QD00085D20150703095113100036\",\"winUnits\":2,\"won\":true,\"wonHitDetail\":\"8,4,\"}
    
    UIView * itemView = [[UIView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.frame), CellH)];
    [self addSubview:itemView];
    
    float curY =5;

    NSArray * stateArray;
    if ([_orderProfile.lotteryType isEqualToString:@"DLT"]) {
        stateArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WinLevelDic" ofType:@"plist"]];
    }else{
        stateArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WinPlayTypeDictionary" ofType:@"plist"]];
    }
    //直接从详情带参数BetType赋值给_playtypename->nameAppear
    NSString * nameAppear = _playtypename;
//从WinPlayTypeDictionary获取tateInfo[@"name"]赋值给nameAppear
//    NSString * type = orderInfo[@"prizeType"];
//    for (NSDictionary * stateInfo in stateArray){
//        if ([stateInfo[@"type"] isEqualToString:type]) {
//            nameAppear = stateInfo[@"name"];
//            break;
//        }
//    }
    if (nameAppear) {
        UILabel * playTypelb = [self lable:CGRectMake(15, curY, CGRectGetWidth(itemView.frame)-15, 15) textColor:RGBCOLOR(153, 102, 51) text:[NSString stringWithFormat:@"%@:",nameAppear] textAligment:NSTextAlignmentLeft];
        [itemView addSubview:playTypelb];
        curY+=15;
    }
    
    NSMutableString * winInfoString = [NSMutableString string];
    NSInteger zhu = [orderInfo[@"winUnits"] integerValue]/[_orderProfile.multiple integerValue];
    [winInfoString appendString:[NSString stringWithFormat:@"%@X%ld注",_orderProfile.multiple,(long)zhu]];
//    [winInfoString appendString:[NSString stringWithFormat:@"%@注",orderInfo[@"winUnits"]]];
    [winInfoString appendString:[NSString stringWithFormat:@"  单注%@元",orderInfo[@"prize"]]];

    float winInfoLbWidth = 175;
    UILabel * winInfolb = [self lableFrame:CGRectMake(CGRectGetWidth(self.frame )- winInfoLbWidth, curY, winInfoLbWidth, CellH) withColor:RGBCOLOR(153, 102, 51)];
    [itemView addSubview:winInfolb];
    NSDictionary *attributes = @{NSFontAttributeName:winInfolb.font};
    CGRect rect_textLb = [winInfoString boundingRectWithSize:CGSizeMake(winInfoLbWidth, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributes
                                            context:nil];
    if (rect_textLb.size.height > CGRectGetHeight(winInfolb.frame)){
        CGRect frame = winInfolb.frame;
        frame.size.height = rect_textLb.size.height;
        winInfolb.frame = frame;
    }
    winInfolb.text = winInfoString;
    
    float max_y = 0.0;

    if ([_orderProfile.lotteryType isEqualToString:@"DLT"]) {
        NSString *numberstr = orderInfo[@"wonHitDetail"];
        NSArray *numberArray = [numberstr componentsSeparatedByString:@";"];
        for(int i=0;i<numberArray.count;i++)
        {
            NSString *numberInfostr = numberArray[i];
            NSArray * num_Array = [numberInfostr componentsSeparatedByString:@"+"];
            NSString * numString_red;
            NSUInteger rednumcount = 0;
            NSString * numString_blue;
            if(num_Array.count > 0)
            {
                numString_red = num_Array[0];
                if(![num_Array[0] isEqualToString:@""])
                {
                    NSArray *array = [numString_red componentsSeparatedByString:@","];
                    rednumcount = array.count;
                }
                if(num_Array.count > 1)
                {
                    numString_blue = num_Array[1];
                }
            }
            else
            {
                return nil;
            }
            
            float numLbWidth = (self.frame.size.width -20 - winInfoLbWidth -5)/2.0;
            float rednumLbWidth = 18 * rednumcount;
            UILabel * winNumlb_red = [self lableFrame:CGRectMake(15, curY, rednumLbWidth, CellH) withColor:[UIColor redColor]];
            [itemView addSubview:winNumlb_red];
            winNumlb_red.text = numString_red;
            
            CGRect rect_numLb_red = [numString_red boundingRectWithSize:CGSizeMake(winNumlb_red.frame.size.width, MAXFLOAT)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:attributes
                                                                context:nil];
            if (rect_numLb_red.size.height > CGRectGetHeight(winNumlb_red.frame)){
                CGRect frame = winNumlb_red.frame;
                frame.size.height = rect_numLb_red.size.height;
                winNumlb_red.frame = frame;
            }
            UILabel *winNumlb_blue= [self lableFrame:CGRectMake(CGRectGetMaxX(winNumlb_red.frame)+5, curY, numLbWidth-20, CellH) withColor:[UIColor blueColor]];
            [itemView addSubview:winNumlb_blue];
            winNumlb_blue.text = numString_blue;
            CGRect rect_numLb_blue = [numString_blue boundingRectWithSize:CGSizeMake(winNumlb_blue.frame.size.width, MAXFLOAT)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:attributes
                                                                  context:nil];
            if (rect_numLb_blue.size.height > CGRectGetHeight(winNumlb_blue.frame)){
                CGRect frame = winNumlb_blue.frame;
                frame.size.height = rect_numLb_blue.size.height;
                winNumlb_blue.frame = frame;
            }
            max_y = CGRectGetHeight(winNumlb_blue.frame)>CGRectGetHeight(winNumlb_red.frame)?CGRectGetHeight(winNumlb_blue.frame):CGRectGetHeight(winNumlb_red.frame);
            if(i<numberArray.count-1)
            {
                curY+= CellH;
            }
        }
    }else{
//       NSString * winNum = [orderInfo[@"wonHitDetail"] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        NSMutableArray *array = [orderInfo[@"wonHitDetail"] componentsSeparatedByString:@"+"];
        for(NSInteger i=0;i<array.count;i++)
        {
            if([array[i] integerValue]<10)
            {
                switch ([array[i] integerValue]) {
                    case 1:
                        array[i] = @"01";
                        break;
                    case 2:
                        array[i] = @"02";
                        break;
                    case 3:
                        array[i] = @"03";
                        break;
                    case 4:
                        array[i] = @"04";
                        break;
                    case 5:
                        array[i] = @"05";
                        break;
                    case 6:
                        array[i] = @"06";
                        break;
                    case 7:
                        array[i] = @"07";
                        break;
                    case 8:
                        array[i] = @"08";
                        break;
                    case 9:
                        array[i] = @"09";
                        break;
                        
                    default:
                        break;
                }
            }
        }
        NSString *winNum = [array componentsJoinedByString:@" "];
        
        float numLbWidth = self.frame.size.width -20 - winInfoLbWidth -5;
        UILabel * winNumlb_red = [self lableFrame:CGRectMake(15, curY, numLbWidth, CellH) withColor:[UIColor redColor]];
        [itemView addSubview:winNumlb_red];
        winNumlb_red.textAlignment = NSTextAlignmentLeft;
        
        winNumlb_red.text = winNum;
        CGRect rect_numLb = [winNum boundingRectWithSize:CGSizeMake(winInfoLbWidth, MAXFLOAT)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:attributes
                                                 context:nil];
        if (rect_numLb.size.height > CGRectGetHeight(winNumlb_red.frame)){
            CGRect frame = winNumlb_red.frame;
            frame.size.height = rect_numLb.size.height;
            winNumlb_red.frame = frame;
        }
        max_y = CGRectGetHeight(winNumlb_red.frame);
    }
    float maxHeight = (CGRectGetHeight(winInfolb.frame) > max_y?CGRectGetHeight(winInfolb.frame): max_y)+curY;
    if (maxHeight > CellH) {
        CGRect frame = itemView.frame;
        frame.size.height = maxHeight;
        itemView.frame = frame;
    }
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(10, itemView.frame.size.height, CGRectGetWidth(itemView.frame)-20, 1)];
    lable.backgroundColor = RGBCOLOR(244, 244, 244);
    [itemView addSubview:lable];
    return itemView;
}

- (void)setUpWithInfoArray:(NSArray *)infoArray BetType:(NSString*)BetType{
    self.backgroundColor = [UIColor whiteColor];
    float cur_y;
    if ([_orderProfile.lotteryType isEqualToString:@"DLT"]||[_orderProfile.lotteryType isEqualToString:@"SX115"] || [_orderProfile.lotteryType  isEqualToString:@"SD115"]) {
        cur_y =0;
        if([_orderProfile.lotteryType isEqualToString:@"SX115"]|| [_orderProfile.lotteryType  isEqualToString:@"SD115"])
        {
            _playtypename = BetType;
        }
        for (NSDictionary * winItemInfo in infoArray){
            //01-22 zwl
            if([_orderProfile.lotteryType isEqualToString:@"DLT"])
            {
                _playtypename = [self getplaytypeName:winItemInfo[@"prizeType"]];
            }
            UIView * itemView =[self forDltOrX115itemViewWithInfo:winItemInfo withPositionY:cur_y];
            cur_y += itemView.frame.size.height+1;
        }
    }else if([_orderProfile.lotteryType isEqualToString:@"JCZQ"]){
         cur_y =10;
        NSArray * contentArray = _orderProfile.winDictionary[@"prizeDataList"];
        UIView * itemView = [self forJCitemViewWithInfo:contentArray withPositionY:cur_y];
        cur_y += CGRectGetHeight(itemView.frame)+10;
    }
  
    CGRect frame = self.frame;
    frame.size.height = cur_y;
    self.frame = frame;
}
-(NSString *)getplaytypeName :(NSString *)prizeType
{
    //从WinPlayTypeDictionary获取tateInfo[@"name"]赋值给strplaytypeName
    NSString *strplaytypeName;
    NSArray* stateArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WinLevelDic" ofType:@"plist"]];
    for (NSDictionary * stateInfo in stateArray){
        if ([stateInfo[@"type"] isEqualToString:prizeType]) {
            strplaytypeName = stateInfo[@"name"];
            break;
        }
    }
    return strplaytypeName;
}
@end
