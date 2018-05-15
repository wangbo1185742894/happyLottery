//
//  PersonCenterCell.h
//  happyLottery
//
//  Created by LYJ on 2018/5/11.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonCenterModel.h"

@protocol PersonCenterCellDelegate <NSObject>

- (void)addOrReliefAttend;

@end

@interface PersonCenterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *fenshiNum;
@property (weak, nonatomic) IBOutlet UILabel *initiateStatusFirst;
@property (weak, nonatomic) IBOutlet UILabel *initiateStatusTwo;
@property (weak, nonatomic) IBOutlet UILabel *initiateStatusThird;
@property (weak, nonatomic) IBOutlet UILabel *initiateStatusForth;
@property (weak, nonatomic) IBOutlet UILabel *initiateStatusFifth;
@property (weak, nonatomic) IBOutlet UILabel *initiateStatusSum;
@property (weak, nonatomic) IBOutlet UIButton *noticeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picLianjie;
@property (weak, nonatomic) IBOutlet UIImageView *picLian;
@property(nonatomic,weak)id <PersonCenterCellDelegate> delegate;

- (void)reloadCell:(PersonCenterModel *)model  isAttend:(BOOL)isAttend;

- (IBAction)attendAction:(id)sender;

@end
