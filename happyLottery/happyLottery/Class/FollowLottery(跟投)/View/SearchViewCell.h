//
//  SearchViewCell.h
//  happyLottery
//
//  Created by LYJ on 2018/8/2.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchPerModel.h"

@interface SearchViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UIImageView *tagOne;

@property (weak, nonatomic) IBOutlet UIImageView *tagTwo;

@property (weak, nonatomic) IBOutlet UIImageView *tagThree;

@property (weak, nonatomic) IBOutlet UILabel *recentWin;

@property (weak, nonatomic) IBOutlet UILabel *totalBonus;

-(void)loadDataWithModel:(SearchPerModel *)model;

@end
