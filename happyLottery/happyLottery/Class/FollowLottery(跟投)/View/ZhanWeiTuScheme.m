//
//  ZhanWeiTuScheme.m
//  happyLottery
//
//  Created by LYJ on 2018/5/30.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "ZhanWeiTuScheme.h"

@implementation ZhanWeiTuScheme

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadDateInFollow{
    [self.placeImage setImage:[UIImage imageNamed:@"pic_gendankongbaiye.png"]];
    self.backgroundColor = [UIColor whiteColor];
    self.placeLab.text = @"暂无数据~";
}

- (void)reloadDateInGroup{
    [self.placeImage setImage:[UIImage imageNamed:@"groupplaceImage.png"]];
    self.backgroundColor = RGBCOLOR(247, 247, 247);
    self.placeLab.text = @"暂无动态";
}

@end
