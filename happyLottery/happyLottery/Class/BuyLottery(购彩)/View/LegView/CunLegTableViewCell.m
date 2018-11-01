//
//  CunLegTableViewCell.m
//  happyLottery
//
//  Created by LYJ on 2018/10/31.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "CunLegTableViewCell.h"


@interface CunLegTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *selectBackGroup;

@property (weak, nonatomic) IBOutlet UIImageView *legIcon;

@property (weak, nonatomic) IBOutlet UILabel *legName;
@property (weak, nonatomic) IBOutlet UILabel *renZheng;
@property (weak, nonatomic) IBOutlet UILabel *onlineLab;
@property (weak, nonatomic) IBOutlet UILabel *protectMoney;
@property (weak, nonatomic) IBOutlet UILabel *legCost;
@property (weak, nonatomic) IBOutlet UILabel *usedLeg;
@property (weak, nonatomic) IBOutlet UILabel *leaveMoney;
@property (weak, nonatomic) IBOutlet UILabel *yuE;

@end

@implementation CunLegTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x += 6;
    frame.origin.y += 3;
    frame.size.height -= 6;
    frame.size.width -= 12;
    [super setFrame:frame];
}

- (void)loadLegDate:(LegWordModel *)legModel{
    self.selectBackGroup.selected = legModel.isSelect;
    self.legName.text = legModel.legName;
    //小哥在线
    if ([legModel.overline boolValue]) {
        self.onlineLab.text = @"在线";
        self.onlineLab.backgroundColor = RGBCOLOR(21, 126, 251);
    } else {
        self.onlineLab.text = @"离线";
        self.onlineLab.backgroundColor = RGBCOLOR(184, 182, 182);
    }
    
    //跑腿费
    if ([legModel.cost integerValue] == 0) {
        self.legCost.text = @"免费跑腿";
    }else{
        self.legCost.text = [NSString stringWithFormat:@"一次%@元",legModel.cost];
    }
    
    if (legModel.isSelect) {
        self.selectBackGroup.backgroundColor = RGBCOLOR(255,235,223);
    } else {
        self.selectBackGroup.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
