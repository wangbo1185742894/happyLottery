//
//  JCLQSFCell.m
//  Lottery
//
//  Created by 王博 on 16/8/22.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "JCLQSFCell.h"

@implementation JCLQSFCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"JCLQSFCell" owner:nil options:nil] lastObject];
    }
    return self;
    
}

-(void)loadDataWithModel:(JCLQMatchModel *)model{
    self.model = model;
    self.imgDanguan.hidden = !model.isDanGuan;
    self.labSFCGameName.text = model.leagueName;
    self.labSFCGameDay.text = model.lineId;
    self.labSFCGameTime.text = [NSString stringWithFormat:@"%@截止",[[[model.stopBuyTime componentsSeparatedByString:@" "] lastObject]substringToIndex:5]];
//    self.labHomeName.text = model.homeName;
//    self.labGuestName.text = model.guestName;
    
    self.labHomeName.attributedText = [self setLabHomeGuestTextColor:[NSString stringWithFormat:@"%@主",model.homeName] andSelect:[model.SFSelectMatch[1] isEqualToString:@"1"]];
    self.labGuestName.attributedText = [self setLabHomeGuestTextColor:[NSString stringWithFormat:@"%@客",model.guestName] andSelect:[model.SFSelectMatch[0] isEqualToString:@"1"]];
       [self setButton:self.btnSFGuestWin normal:[NSString stringWithFormat:@"客胜 %@",model.SFOddArray[0]] andSelect:self.model.SFSelectMatch[0]];
         [self setButton:self.btnSFHomeWin normal:[NSString stringWithFormat:@"主胜 %@",model.SFOddArray[1]] andSelect:self.model.SFSelectMatch[1]];

      [self refreshSelected:self.model.SFSelectMatch baseTag:100 andEnableArray:model.SFOddArray];
//    self.labGuestName.textColor=self.btnSFGuestWin.selected?[UIColor whiteColor]:RGBCOLOR(72, 72, 72);
//    self.labGuestPeiLv.textColor = self.btnSFGuestWin.selected?[UIColor whiteColor]:RGBCOLOR(72, 72, 72);
//    self.labHomePeiLv.textColor =self.btnSFHomeWin.selected?[UIColor whiteColor]:RGBCOLOR(72, 72, 72);;
//    self.labHomeName.textColor = self.btnSFHomeWin.selected?[UIColor whiteColor]:RGBCOLOR(72, 72, 72);
}

- (IBAction)actionClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.delegate clickItem:@"1" model:self.model andIndex:sender.tag];
    }else{
        [self.delegate clickItem:@"0" model:self.model andIndex:sender.tag];
        
    }

    self.labHomeName.attributedText = [self setLabHomeGuestTextColor:self.labHomeName.text andSelect:self.btnSFHomeWin.selected];
    self.labGuestName.attributedText = [self setLabHomeGuestTextColor:self.labGuestName.text andSelect:self.btnSFGuestWin.selected];
    
//    self.labGuestName.textColor=self.btnSFGuestWin.selected?[UIColor whiteColor]:RGBCOLOR(72, 72, 72);
//   self.labGuestPeiLv.textColor = self.btnSFGuestWin.selected?[UIColor whiteColor]:RGBCOLOR(72, 72, 72);
//    self.labHomePeiLv.textColor =self.btnSFHomeWin.selected?[UIColor whiteColor]:RGBCOLOR(72, 72, 72);;
//    self.labHomeName.textColor = self.btnSFHomeWin.selected?[UIColor whiteColor]:RGBCOLOR(72, 72, 72);
    
}

@end
