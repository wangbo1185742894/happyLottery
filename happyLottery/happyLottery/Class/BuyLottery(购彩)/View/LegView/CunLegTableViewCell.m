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

@property (weak, nonatomic) IBOutlet UILabel *leaveMoney;
@property (weak, nonatomic) IBOutlet UILabel *yuE;

@end

@implementation CunLegTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
    self.renZheng.layer.masksToBounds = YES;
    self.renZheng.layer.cornerRadius = 4;
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x += 6;
    frame.origin.y += 6;
    frame.size.height -= 6;
    frame.size.width -= 12;
    [super setFrame:frame];
}


- (void)loadLegDate:(PostboyAccountModel *)legModel{
    self.selectBackGroup.selected = legModel.isSelect;
    self.legName.text = [NSString stringWithFormat:@"代买小哥%@",legModel.postboyName];
    //余额
    self.yuE.text = [NSString stringWithFormat:@"%.2f元",[legModel.totalBalance doubleValue]];
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
