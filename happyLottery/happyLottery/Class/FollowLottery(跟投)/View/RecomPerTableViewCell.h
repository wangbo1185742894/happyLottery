//
//  RecomPerTableViewCell.h
//  happyLottery
//
//  Created by LYJ on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecomPerModel.h"

@interface RecomPerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *personImage;

@property (weak, nonatomic) IBOutlet UILabel *personName;

@property (weak, nonatomic) IBOutlet UILabel *personInfo;

- (void)reloadDate:(RecomPerModel * )model;
@end
