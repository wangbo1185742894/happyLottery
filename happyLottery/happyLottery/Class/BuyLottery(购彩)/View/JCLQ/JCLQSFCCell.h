//
//  JCLQSFCCell.h
//  Lottery
//
//  Created by 王博 on 16/8/17.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "BaseCell.h"


@interface JCLQSFCCell : BaseCell

@property (weak, nonatomic) IBOutlet UILabel *labSFCGameName;
@property (weak, nonatomic) IBOutlet UILabel *labSFCGameDay;
@property (weak, nonatomic) IBOutlet UILabel *labSFCGameTime;

@property (weak, nonatomic) IBOutlet UILabel *labTitleHostAndGoust;
@property (weak, nonatomic) IBOutlet UIButton *btnShowDetail;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectFenShu;
- (IBAction)actionSelectFenShu:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imgDanguan;

-(void)updataSelected;
@end
