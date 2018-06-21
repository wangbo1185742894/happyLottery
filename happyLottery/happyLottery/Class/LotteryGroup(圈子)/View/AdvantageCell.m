//
//  AdvantageCell.m
//  happyLottery
//
//  Created by LYJ on 2018/6/2.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "AdvantageCell.h"

@implementation AdvantageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x = 8;
    frame.size.width -= 16;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSMutableAttributedString *)setLabelTextStyle:(NSString *)content{
    NSMutableDictionary *attDic = [NSMutableDictionary dictionary];
    [attDic setValue:@1 forKey:NSKernAttributeName];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:content attributes:attDic];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 0;
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range: NSMakeRange(0, content.length)];
    return attStr;
}

- (void)reloadDate:(NSDictionary *)dic{
    
    [self.xuHaoImage setImage:[UIImage imageNamed:[dic objectForKey:@"xuhaoImage"]]];
    [self.womanImage setImage:[UIImage imageNamed:[dic objectForKey:@"xuanyanImage"]]];
    self.infoLabelOne.attributedText = [self setLabelTextStyle:[dic objectForKey:@"xuanyanOne"]];
    self.infoLabelTwo.attributedText = [self setLabelTextStyle:[dic objectForKey:@"xuanyanTwo"]];
    self.infoLabelThree.attributedText = [self setLabelTextStyle:[dic objectForKey:@"xuanyanThree"]];
}

@end
