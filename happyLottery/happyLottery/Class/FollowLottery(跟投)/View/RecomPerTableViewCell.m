//
//  RecomPerTableViewCell.m
//  happyLottery
//
//  Created by LYJ on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "RecomPerTableViewCell.h"

@implementation RecomPerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.personImage.clipsToBounds = NO;
    self.personImage.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadDate:(RecomPerModel * )model{
    [self.personImage setImage:[UIImage imageNamed:model.personImageName]];
    self.personName.text = model.personName;
    self.personInfo.text = model.personInfo;
}

@end
