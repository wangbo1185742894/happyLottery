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

@property (weak, nonatomic) IBOutlet UILabel *orderLabel;

@property (weak, nonatomic) IBOutlet UIImageView *orderImage;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *infoOneSum;
@property (weak, nonatomic) IBOutlet UILabel *infoOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoTwoSum;
@property (weak, nonatomic) IBOutlet UILabel *infoTwoLabel;

- (void)reloadDate:(RecomPerModel * )model categoryCode:(NSString *)categoryCode;
@end
