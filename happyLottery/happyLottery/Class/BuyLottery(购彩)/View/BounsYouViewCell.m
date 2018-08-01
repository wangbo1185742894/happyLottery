

//
//  BounsYouViewCell.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/7/27.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BounsYouViewCell.h"

@interface BounsYouViewCell()<SelectViewDelegate>{
    BounsModelItem * curModel;
}
@end

@implementation BounsYouViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.labBeiSelect.delegate = self;
    self.labBouns.adjustsFontSizeToFitWidth = YES;
    self.labBeiSelect.beiShuLimit = 9999;
    self.labBeiSelect.labContent.userInteractionEnabled = NO;
    [self.labBeiSelect setTarget:self rightAction:@selector(actionAdd) leftAction:@selector(actionSub)];
}

-(void)actionSub{
    NSInteger beiCount =[self.labBeiSelect.labContent.text integerValue];
    if ( beiCount>1) {
        beiCount --;
    }
    self.labBeiSelect.labContent.text = [NSString stringWithFormat:@"%ld",(long)beiCount];
    [self update];
}

-(void)actionAdd{
    NSInteger  beiCount =[self.labBeiSelect.labContent.text integerValue];
    if ( beiCount < self.labBeiSelect.beiShuLimit) {
        beiCount ++;
    }
    self.labBeiSelect.labContent.text = [NSString stringWithFormat:@"%ld",(long)beiCount];
    [self update];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)reloadModel:(BounsModelItem *)model{
    curModel = model;
    self.labBeiSelect.labContent.text = model.multiple;
    self.labBouns.text =  [Utility toStringByfloat:model.bouns];
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
    JCZQMatchModel *tempmodel = [JCZQMatchModel new];
    for (BounsModelBet *bet in model.selectItemList) {
        [titleArray addObject: [NSString stringWithFormat:@"%@ %@ %@(%@)",bet.lineId,bet.homeName,[tempmodel getBounsAppearTitleByTypeAndSp:bet.playType],bet.sp]];
    }
    self.labBetContent.text = [titleArray componentsJoinedByString:@"\n"];
}

-(void)update{
    if ([self.labBeiSelect.labContent.text integerValue] == 0) {
        curModel.multiple = @"1";
    }else{
        curModel.multiple = self.labBeiSelect.labContent.text;
    }
    [self .delegate actionUpdagte];
}

@end
