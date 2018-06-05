//
//  AgentDynamicCell.m
//  happyLottery
//
//  Created by LYJ on 2018/6/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "AgentDynamicCell.h"

@implementation AgentDynamicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSAttributedString*)getAttStrByHtmlStr:(NSString*)htmlString{
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrStr;
}


- (NSMutableAttributedString *)getRangeStr:(NSMutableAttributedString *)text findText:(NSString *)findText
{
    NSString *str = text.string;
    NSRange range = [str rangeOfString:findText];
    if (range.location != NSNotFound && range.length != 0)
    {
        for (int i = 0;; i++)
        {
            if (i == 0)
            {
               [text replaceCharactersInRange:range withString:@""];
            }
            else
            {
                NSString *str = text.string;
                NSRange range = [str rangeOfString:findText];
                if (range.location == NSNotFound && range.length == 0)
                {
                    break;
                    
                }
                [text replaceCharactersInRange:range withString:@""];
            }
        }
    }
    return text;
}


-(NSString *)setMatchData:(NSString *)time{
    if ([time containsString:@"-"]) {
        NSString *curDateM = [Utility timeStringFromFormat:@"MM" withDate:[NSDate date]];
        NSString *curDateD = [Utility timeStringFromFormat:@"dd" withDate:[NSDate date]];
        NSString *matchDateM =[[[time componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"][1];
        NSString *matchDateD =[[[[time componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] lastObject];
        if ([curDateM isEqualToString:matchDateM]) {
            NSInteger dayNum = [matchDateD integerValue] - [curDateD integerValue];
            if (dayNum == 0) {  // == 0 今天  ==1 明天   == 2  后天   == 3 大后天
                return [NSString stringWithFormat:@"今日%@",[time substringWithRange:NSMakeRange(11, 5)]];
            }else{
                return [NSString stringWithFormat:@"%@", [time substringWithRange:NSMakeRange(5, 11)]];
            }
        }else{
            return [NSString stringWithFormat:@"%@", [time substringWithRange:NSMakeRange(5, 11)]];
        }
    }
    return time;
}



- (void)reloadDate :(AgentDynamic *)model{
    NSString *htmlStr = [model.dynamic stringByReplacingOccurrencesOfString:@"<p>" withString:@"<p style='color:fea513'>"];
    NSAttributedString *attStr = [self getAttStrByHtmlStr:htmlStr];
    NSMutableAttributedString *mubStr = [[NSMutableAttributedString alloc]initWithAttributedString:attStr];
    [self getRangeStr:mubStr findText:@"\n"];
    self.dynamicLab.attributedText = mubStr;
    self.createTimeLab.text = [self setMatchData:model.createTime];
}

@end
