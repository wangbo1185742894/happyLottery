//
//  HomeMenuItemView.m
//  Lottery
//
//  Created by 壮壮 on 17/2/14.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "MineCollectionViewCell.h"


@interface MineCollectionViewCell ()



@end

@implementation MineCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.labRedPoint.layer.cornerRadius = self.labRedPoint.mj_h / 2;
    self.labRedPoint.layer.masksToBounds = YES;
}


-(void)setItemIcom:(NSDictionary *)model{
    
}
- (IBAction)itemClick:(UIButton *)sender {
    [self.delegate itemClick:nil];
    
}

@end
