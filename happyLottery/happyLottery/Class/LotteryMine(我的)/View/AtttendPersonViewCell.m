//
//  AtttendPersonViewCell.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/14.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "AtttendPersonViewCell.h"

@implementation AtttendPersonViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

-(void)loadData:(AttentPersonModel *)model{
    self.imgIcon.layer.cornerRadius = self.imgIcon.mj_h/ 2;
    self.imgIcon.layer.masksToBounds = YES;

    if ( model.attentNickname == nil) {
        NSString *cardCode = model.mobile;
        cardCode = [cardCode stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.labName.text  =cardCode;
    }else{
        self.labName.text  =model.attentNickname;
    }
    NSArray *wonState = [model.trRecentWon componentsSeparatedByString:@","];
    NSInteger totalWon = 0;
    for (NSString *state in wonState) {
        totalWon += [state integerValue];
    }
    
        self.labHis.text = [NSString stringWithFormat:@"近%ld中%ld",wonState.count,totalWon];
        if ( totalWon!= 0 && wonState.count/totalWon<2  ) {
            self.labHis.hidden = NO;
        } else {
            self.labHis.hidden = YES;
        }
 
   
    if (model.attentHeadUrl .length == 0) {
        [self.imgIcon setImage:[UIImage imageNamed:@"usermine"]];
    }else{
        [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:model.attentHeadUrl]];
    }
}

@end
