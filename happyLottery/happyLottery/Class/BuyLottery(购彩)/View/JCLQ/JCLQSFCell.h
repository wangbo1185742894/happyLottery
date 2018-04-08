//
//  JCLQSFCell.h
//  Lottery
//
//  Created by 王博 on 16/8/22.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"

@interface JCLQSFCell :BaseCell

@property (weak, nonatomic) IBOutlet UILabel *labSFCGameName;
@property (weak, nonatomic) IBOutlet UILabel *labSFCGameDay;
@property (weak, nonatomic) IBOutlet UILabel *labSFCGameTime;
@property (weak, nonatomic) IBOutlet UIButton *btnSFGuestWin;

@property (weak, nonatomic) IBOutlet UIButton *btnSFHomeWin;
@property (weak, nonatomic) IBOutlet UILabel *labGuestName;
@property (weak, nonatomic) IBOutlet UILabel *labHomeName;

@property (weak, nonatomic) IBOutlet UILabel *labGuestPeiLv;

@property (weak, nonatomic) IBOutlet UILabel *labHomePeiLv;
@property (weak, nonatomic) IBOutlet UIImageView *imgDanguan;

@end
