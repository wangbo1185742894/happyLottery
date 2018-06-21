//
//  AdvantageCell.h
//  happyLottery
//
//  Created by LYJ on 2018/6/2.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvantageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *xuHaoImage;
@property (weak, nonatomic) IBOutlet UILabel *infoLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *infoLabelTwo;
@property (weak, nonatomic) IBOutlet UILabel *infoLabelThree;
@property (weak, nonatomic) IBOutlet UIImageView *womanImage;

- (void)reloadDate:(NSDictionary *)dic;

@end
