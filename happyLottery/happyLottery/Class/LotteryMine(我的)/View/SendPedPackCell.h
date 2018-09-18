//
//  SendPedPackCell.h
//  happyLottery
//
//  Created by LYJ on 2018/9/14.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedPackCircleModal.h"

@interface SendPedPackCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userNameLab;

- (void)reloadDate:(RedPackCircleModal *)model;

@end
