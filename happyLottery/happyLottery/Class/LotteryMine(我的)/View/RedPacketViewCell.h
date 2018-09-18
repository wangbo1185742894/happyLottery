//
//  RedPacketViewCell.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/9/14.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPacketViewCell : UITableViewCell
    @property (weak, nonatomic) IBOutlet UILabel *labNum;
    @property (weak, nonatomic) IBOutlet UILabel *labRedCost;
    @property (weak, nonatomic) IBOutlet UILabel *labRedDate;
    @property (weak, nonatomic) IBOutlet UILabel *labRendName;
-(void)loadData:(id)model;
@end
