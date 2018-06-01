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



-(void)refreshDataJCLQ:(JcBetContent  *)modelDic andResult:(NSArray<OpenResult *> *)resultArray{
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
        }else{//篮球赛果  客 VS 主
            self.matchResultLab.text = [NSString stringWithFormat:@"%@:%@",open.guestScore,open.homeScore];
        }
    }
    NSMutableString *option = [[NSMutableString alloc]initWithCapacity:0];
    for (NSDictionary *itemDic in modelDic.matchInfo[@"betPlayTypes"]) {
        [option appendString:[tabcell reloadDataWithRecJCLQ:itemDic[@"options"] type:itemDic[@"playType"] andMatchKey:modelDic.matchInfo[@"matchKey"]]];
    }
     self.betContentLab.text = option;
    self.orderNoLab.text = modelDic.matchInfo[@"matchId"];
    self.groupMatchLab.numberOfLines = 0;
    if (modelDic.matchInfo[@"clash"]!= nil) {
        NSArray *array = [modelDic.matchInfo[@"clash"] componentsSeparatedByString:@"VS"];
        self.groupMatchLab.text = [NSString stringWithFormat:@"%@\nvs\n%@",array[0],array[1]];
    }
}

-(CGFloat)getCellJCLQHeight:(JcBetContent  *)modelDic{
    if (tabcell == nil) {
        tabcell = [[SchemeDetailMatchViewCell alloc]init];;
    }
    NSMutableString *option = [[NSMutableString alloc]initWithCapacity:0];
    for (NSDictionary *itemDic in modelDic.matchInfo[@"betPlayTypes"]) {
        [option appendString:[tabcell reloadDataWithRecJCLQ:itemDic[@"options"] type:itemDic[@"playType"] andMatchKey:modelDic.matchInfo[@"matchKey"]]];
    }
    if ( [option boundingRectWithSize:CGSizeMake(KscreenWidth - 300, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.height > 58) {
        return [option boundingRectWithSize:CGSizeMake(KscreenWidth - 300, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.height;
    }else{
        return 58;
    }
    return 0;
}

-(CGFloat)getCellHeight:(JcBetContent  *)modelDic{
    if (tabcell == nil) {
        tabcell = [[SchemeDetailMatchViewCell alloc]init];;
    }
    NSMutableString *option = [[NSMutableString alloc]initWithCapacity:0];
    for (NSDictionary *itemDic in modelDic.matchInfo[@"betPlayTypes"]) {
        [option appendString:[tabcell reloadDataWithRec:itemDic[@"options"] type:itemDic[@"playType"] andMatchKey:modelDic.matchInfo[@"matchKey"]]];
    }
    if ( [option boundingRectWithSize:CGSizeMake(KscreenWidth - 300, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.height > 58) {
        return [option boundingRectWithSize:CGSizeMake(KscreenWidth - 300, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.height;
    }else{
        return 58;
    }
   return 0;
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
        }else{   //足球赛果  主 VS 客
           self.matchResultLab.text = [NSString stringWithFormat:@"%@:%@",open.homeScore,open.guestScore];
        }
    }
    NSMutableString *option = [[NSMutableString alloc]initWithCapacity:0];
    for (NSDictionary *itemDic in modelDic.matchInfo[@"betPlayTypes"]) {
        [option appendString:[tabcell reloadDataWithRec:itemDic[@"options"] type:itemDic[@"playType"] andMatchKey:modelDic.matchInfo[@"matchKey"]]];
    }
    self.betContentLab.text = option;
    self.orderNoLab.text = modelDic.matchInfo[@"matchId"];
    self.groupMatchLab.text = modelDic.matchInfo[@"clash"];
    self.groupMatchLab.numberOfLines = 0;
    if (modelDic.matchInfo[@"clash"]!= nil) {
        NSArray *array = [modelDic.matchInfo[@"clash"] componentsSeparatedByString:@"VS"];
        self.groupMatchLab.text = [NSString stringWithFormat:@"%@\nvs\n%@",array[0],array[1]];
    }
}

- (void)reloadDate:(JCZQSchemeItem *)scheme {
    self.orderNoLab.text = @"编号";
    if ([scheme.lottery isEqualToString:@"JCLQ"]) {
        self.groupMatchLab.text = @"客队vs主队";
    }
    else{
        self.groupMatchLab.text = @"主队vs客队";
    }
    self.betContentLab.text = @"投注内容";
    self.matchResultLab.text = @"赛果";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
