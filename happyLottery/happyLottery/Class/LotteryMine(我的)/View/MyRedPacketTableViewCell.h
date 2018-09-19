//
//  MyRedPacketTableViewCell.h
//  happyLottery
//
//  Created by LYJ on 2017/12/27.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRedPacketTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labCreatTime;
@property (weak, nonatomic) IBOutlet UILabel *labBackCost;
@property (weak, nonatomic) IBOutlet UILabel *labRedPacketCost;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *sourceLab;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;
@property (weak, nonatomic) IBOutlet UIImageView *endImage;
@property (weak, nonatomic) IBOutlet UIImageView *packetImage;
@property (weak, nonatomic) IBOutlet UILabel *day;


@end
