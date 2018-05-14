//
//  HomeMenuItemView.m
//  Lottery
//
//  Created by 壮壮 on 17/2/14.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "MenuCollectionViewCell.h"


@interface MenuCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgItemIcon;
@property (weak, nonatomic) IBOutlet UILabel *labItemTitle;

@property (weak, nonatomic) IBOutlet UIButton *itemBack;


@end

@implementation MenuCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


-(void)setItemIcom:(NSDictionary *)model{
    self.imgItemIcon .image = [UIImage imageNamed:model[@"itemImage"]];
    self.labItemTitle.text =model[@"itemTitle"];
}

-(void)setEightItemIcom:(NSDictionary *)model{
    self.imgItemIcon .layer.cornerRadius = self.imgItemIcon.mj_h / 2;
    self.imgItemIcon.layer.masksToBounds = YES;
    if (model[@"headUrl"] == nil) {
        self.imgItemIcon .image = [UIImage imageNamed: @"usermine"];
    }else{
        [self.imgItemIcon sd_setImageWithURL:[NSURL URLWithString:model[@"headUrl"]]];
    }
    
    self.labItemTitle.text =model[@"cardCode"];
}

- (IBAction)itemClick:(UIButton *)sender {
    if (self.index == -1) {
        return;
    }
    [self.delegate itemClick:self.index];
    
}

@end
