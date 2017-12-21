//
//  BankCardSetTableViewCell.h
//  happyLottery
//
//  Created by LYJ on 2017/12/21.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankCardSetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankNum;
@property (weak, nonatomic) IBOutlet UIButton *unBindBtn;

@end
