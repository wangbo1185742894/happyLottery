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


- (void)reloadDate :(AgentDynamic *)model{
    NSString *htmlStr = [model.dynamic stringByReplacingOccurrencesOfString:@"<p>" withString:@"<p style='color:fea513'>"];
    NSAttributedString *attStr = [self getAttStrByHtmlStr:htmlStr];
    NSMutableAttributedString *mubStr = [[NSMutableAttributedString alloc]initWithAttributedString:attStr];
    [self getRangeStr:mubStr findText:@"\n"];
    self.dynamicLab.attributedText = mubStr;
    self.createTimeLab.text = model.createTime;
}

@end
