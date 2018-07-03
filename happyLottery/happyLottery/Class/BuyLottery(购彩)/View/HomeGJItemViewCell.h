//
//  HomeGJItemViewCell.h
//  Lottery
//
//  Created by 王博 on 2018/3/12.
//  Copyright © 2018年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordCupHomeItem.h"

@interface HomeGJItemViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftXuHaoCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidthCons;

+ (instancetype)cellWithTableView:(UITableView *)tableVie;

-(void)loadDataWith:(WordCupHomeItem * )model;

@end
