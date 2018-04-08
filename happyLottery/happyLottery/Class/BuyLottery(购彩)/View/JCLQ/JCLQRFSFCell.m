//
//  JCLQRFSFCell.m
//  Lottery
//
//  Created by 王博 on 16/8/22.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "JCLQRFSFCell.h"

@implementation JCLQRFSFCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"JCLQRFSFCell" owner:nil options:nil] lastObject];
    }
    return self;
    
}

- (IBAction)actionClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.delegate clickItem:@"1" model:self.model andIndex:sender.tag];
    }else{
        [self.delegate clickItem:@"0" model:self.model andIndex:sender.tag];
        
    }
    
    self.labHomeName.attributedText = [self setLabHomeGuestTextColor:self.labHomeName.text andSelect:self.btnRFSFHomeWin.selected];
     self.labGuestName.attributedText = [self setLabHomeGuestTextColor:self.labGuestName.text andSelect:self.btnRFSFGuestWin.selected];
    
//    self.labGuestName.textColor=self.btnRFSFGuestWin.selected?[UIColor whiteColor]:TEXTGRAYCOLOR;
    [self setLaColor:self.labGuestPeiLv isSelected:self.btnRFSFGuestWin.selected];
//    self.labHomePeiLv.textColor =self.btnRFSFHomeWin.selected?[UIColor whiteColor]:RGBCOLOR(72, 72, 72);
    [self setLaColor:self.labHomePeiLv isSelected:self.btnRFSFHomeWin.selected];
//    self.labHomeName.textColor = self.btnRFSFHomeWin.selected?[UIColor whiteColor]:TEXTGRAYCOLOR;
}
- (void)setLaColor:(UILabel *)label isSelected:(BOOL)isSelected{
    NSString *laText = label.text;
    NSString *subStr = [laText substringFromIndex:2];
    subStr = [[subStr componentsSeparatedByString:@" "] firstObject];
    
    if ([subStr isEqualToString:@""]) {
        
        label.textColor =isSelected?[UIColor whiteColor]:TEXTGRAYCOLOR;
        return;
    }
    NSString *flagStr = [subStr substringToIndex:1];
    
    
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:laText];
    
    [attstr addAttribute:NSForegroundColorAttributeName value:TEXTGRAYCOLOR range:NSMakeRange(0, laText.length )];
    
   
    if (isSelected) {
        [attstr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, laText.length )];
    }else{
        if([flagStr isEqualToString:@"-"]) {
            [attstr addAttribute:NSForegroundColorAttributeName value:SystemGreen range:NSMakeRange(2, subStr.length)];
        }else{
            [attstr addAttribute:NSForegroundColorAttributeName value:SystemRed range:NSMakeRange(2, subStr.length)];
        }
        
    }
    label.attributedText = attstr;
}

-(void)loadDataWithModel:(JCLQMatchModel *)model{
    self.model = model;
    self.imgDanguan.hidden = !model.isDanGuan;
    self.labRFSFGameName.text = model.leagueName;
    self.labRFSFGameDay.text = model.lineId;
    self.labRFSFGameTime.text = [NSString stringWithFormat:@"%@截止",[[[model.stopBuyTime componentsSeparatedByString:@" "] lastObject]substringToIndex:5]];

//    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@客",model.guestName]];
//    NSRange r1 = NSMakeRange(model.guestName.length, 1);
//    NSRange r2 = NSMakeRange(0, model.guestName.length);
//    [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:r1];
//    [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:r2];
//
//    if (self.btnRFSFGuestWin.selected) {
//        
//        [aStr addAttribute:NSForegroundColorAttributeName value:TextOrangeColor range:r1];
//        [aStr addAttribute:NSForegroundColorAttributeName value:NAVORANGECOLOR range:r2];
//    }else{
//        [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:r1];
//        [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:r2];
//      
//    }

    self.labHomeName.attributedText = [self setLabHomeGuestTextColor:[NSString stringWithFormat:@"%@主",model.homeName] andSelect:[model.RFSFSelectMatch[1] isEqualToString:@"1"]];
     self.labGuestName.attributedText = [self setLabHomeGuestTextColor:[NSString stringWithFormat:@"%@客",model.guestName] andSelect:[model.RFSFSelectMatch[0] isEqualToString:@"1"]];
    
    
//    self.labGuestName.text = model.guestName;
    
//    NSRange r = [model.handicap rangeOfString:@"-"];
   if ([model.handicap integerValue]>0) {
     self.labHomePeiLv.text =[NSString stringWithFormat:@"主胜+%@ %.2f",model.handicap,[model.RFSFOddArray[1] doubleValue]];
    }else{
    self.labHomePeiLv.text =[NSString stringWithFormat:@"主胜%@ %.2f",model.handicap,[model.RFSFOddArray[1] doubleValue]];
    }
    self.labGuestPeiLv.text =[NSString stringWithFormat:@"客胜 %.2f",[model.RFSFOddArray[0] doubleValue]];

    
    [self refreshSelected:self.model.RFSFSelectMatch baseTag:200 andEnableArray:model.RFSFOddArray];
//    self.labGuestName.textColor=self.btnRFSFGuestWin.selected?[UIColor whiteColor]:TEXTGRAYCOLOR;
//    self.labGuestPeiLv.textColor = self.btnRFSFGuestWin.selected?[UIColor whiteColor]:RGBCOLOR(72, 72, 72);
//    self.labHomePeiLv.textColor =self.btnRFSFHomeWin.selected?[UIColor whiteColor]:RGBCOLOR(72, 72, 72);;
//    self.labHomeName.textColor = self.btnRFSFHomeWin.selected?[UIColor whiteColor]:TEXTGRAYCOLOR;
    
    [self setLaColor:self.labGuestPeiLv isSelected:self.btnRFSFGuestWin.selected];
    [self setLaColor:self.labHomePeiLv isSelected:self.btnRFSFHomeWin.selected];
    
}




@end
