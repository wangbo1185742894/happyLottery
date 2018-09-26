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

-(void)loadDataRedCell:(FollowRedPacketModel *)model{
    if (model.headUrl == nil) {
          self.imgIcon.image = [UIImage imageNamed:@"user_mine.png"];
    }else{
        [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:model.headUrl]];
    }
  
    if ([model.redPacketStatus isEqualToString:@"LOCK"]) {
        [self.redImage setImage:[UIImage imageNamed:@"rengouredsuoding.png"]];
    }else if ([model.redPacketStatus isEqualToString:@"UN_OPEN"]) {
        [self.redImage setImage:[UIImage imageNamed:@"rengouredjiesuo.png"]];
    }else if ([model.redPacketStatus isEqualToString:@"OPEN"]) {
        [self.redImage setImage:[UIImage imageNamed:@"rengoureddakaitest.png"]];
    }else if ([model.redPacketStatus isEqualToString:@"INVALID"]) {
        [self.redImage setImage:[UIImage imageNamed:@"rengouredsuoding.png"]];
    }
    if (model.nikeName == nil) {
        if (model.mobile == nil) {
             self.labName.text = [model.cardCode stringByReplacingCharactersInRange:NSMakeRange(2, 3) withString:@"***"];
        }else{
             self.labName.text = [model.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
    }else{
        self.labName.text = model.nikeName;
    }
    self.imgIcon.layer.cornerRadius  =self.imgIcon.mj_h / 2;
    self.imgIcon.layer.masksToBounds = YES;
    self.labHis.hidden = YES;
    self.labTime.text = model.createTime;
}

@end
