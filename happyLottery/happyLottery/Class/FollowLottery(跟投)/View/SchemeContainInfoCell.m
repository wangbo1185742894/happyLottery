//
//  SchemeContainInfoCell.m
//  happyLottery
//
//  Created by LYJ on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SchemeContainInfoCell.h"
#import "SchemeDetailMatchViewCell.h"

@implementation SchemeContainInfoCell{
    NSArray *itemDic;
    SchemeDetailMatchViewCell * tabcell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.orderNoLab.layer.borderColor = RGBCOLOR(231,231,231).CGColor;
    self.orderNoLab.layer.borderWidth = 0.5;
    self.orderNoLab.numberOfLines = 2;
    self.groupMatchLab.layer.borderColor = RGBCOLOR(231,231,231).CGColor;
    self.groupMatchLab.layer.borderWidth = 0.5;
    self.betContentLab.layer.borderColor = RGBCOLOR(231,231,231).CGColor;
    self.betContentLab.layer.borderWidth = 0.5;
    self.matchResultLab.layer.borderColor = RGBCOLOR(231,231,231).CGColor;
    self.matchResultLab.layer.borderWidth = 0.5;
    tabcell = [[SchemeDetailMatchViewCell alloc]init];;
    
    // Initialization code
}


-(void)refreshData:(JcBetContent  *)modelDic andResult:(NSArray<OpenResult *> *)resultArray{
    OpenResult *open;
    for (OpenResult *openItem in resultArray) {
        if ([openItem.matchKey integerValue] == [modelDic.matchInfo[@"matchKey"] integerValue]) {
            open = openItem;
        }
    }
    if (open == nil) {
        self.matchResultLab.text = @"--:--";
    }else{
        if ([open.matchStatus isEqualToString:@"CANCLE"]) {
           self.matchResultLab.text = @"取消";
        }else if ([open.matchStatus isEqualToString:@"PAUSE"]){
           self.matchResultLab.text = @"暂停";
        }else{
           self.matchResultLab.text = [NSString stringWithFormat:@"%@:%@",open.homeScore,open.guestScore];
        }
    }
    for (NSDictionary *itemDic in modelDic.matchInfo[@"betPlayTypes"]) {
        NSString *option = [tabcell reloadDataWithRec:itemDic[@"options"] type:itemDic[@"playType"] andMatchKey:modelDic.matchInfo[@"matchKey"]];
        self.betContentLab.text = option;
    }
    self.orderNoLab.text = modelDic.matchInfo[@"matchId"];
    self.groupMatchLab.text = modelDic.matchInfo[@"clash"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
