//
//  JCLQRFSFCell.h
//  Lottery
//
//  Created by 王博 on 16/8/22.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"

@interface JCLQRFSFCell :BaseCell

@property (weak, nonatomic) IBOutlet UILabel *labRFSFGameName;
@property (weak, nonatomic) IBOutlet UILabel *labRFSFGameDay;
@property (weak, nonatomic) IBOutlet UILabel *labRFSFGameTime;

@property (weak, nonatomic) IBOutlet UIButton *btnRFSFGuestWin;

@property (weak, nonatomic) IBOutlet UIButton *btnRFSFHomeWin;

@property (weak, nonatomic) IBOutlet UILabel *labGuestName;
@property (weak, nonatomic) IBOutlet UILabel *labHomeName;

@property (weak, nonatomic) IBOutlet UILabel *labGuestPeiLv;

@property (weak, nonatomic) IBOutlet UIImageView *imgDanguan;
@property (weak, nonatomic) IBOutlet UILabel *labHomePeiLv;
@end
