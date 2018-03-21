//
//  CTZQTouzhuShisiCell.m
//  Lottery
//
//  Created by 王博 on 16/3/28.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "CTZQTouzhuShisiCell.h"
#import "CTZQTouzhuRenjiuCell.h"
#import "UIImage+ImageWithColor.h"
#import "CTZQBet.h"

@implementation CTZQTouzhuShisiCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"CTZQTouzhuShisiCell" owner:nil options:nil] lastObject];
        [self setButton:self.btnDraw];
        self.btnWin.adjustsImageWhenHighlighted = NO;
        [self setButton:self.btnLose];
        self.btnLose.adjustsImageWhenHighlighted = NO;
        [self setButton:self.btnWin];
        self.btnDraw.adjustsImageWhenHighlighted = NO;
        
    }
    return self;

}
/**
 *  设置Btn的属性
 *
 *  @param btn
 */
-(void)setButton:(UIButton*)btn{
    [btn setTitleColor:RGBCOLOR(72, 72, 72) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
}

-(void)reloadData{
    
    [self refreshButton:self. btnDraw value:self.cBet.cMatch.selectedP addTitle:self.cBet.cMatch.oddsPStr];
    [self refreshButton: self.btnLose value:self.cBet.cMatch.selectedF addTitle:self.cBet.cMatch.oddsFStr];
    [self refreshButton: self.btnWin value:self.cBet.cMatch.selectedS addTitle:self.cBet.cMatch.oddsSStr];
    
//    [self refreshButton:self. btnDraw value:self.cBet.cMatch.selectedP addTitle:[[NSAttributedString alloc] initWithString:@"1"]];
//    [self refreshButton: self.btnLose value:self.cBet.cMatch.selectedF addTitle:[[NSAttributedString alloc] initWithString:@"0"]];
//    [self refreshButton: self.btnWin value:self.cBet.cMatch.selectedS addTitle:[[NSAttributedString alloc] initWithString:@"3"]];
    
    self.labHomeName.text = self.cBet.cMatch.homeName;
    self.labGuestName.text = self.cBet.cMatch.guestName;
    [self.delegate refreshTouzhuVCSummary];
}

-(void)refreshButton : (UIButton *)btn value:(NSString *)str addTitle:(NSAttributedString*)atterstr{
    if ([str isEqualToString:@"0"]) {
        btn.selected = NO;
        if (atterstr != nil) {
            [btn setAttributedTitle:atterstr forState:UIControlStateNormal];
        }
        
    }else{
        btn.selected = YES;
        if (atterstr) {
            NSMutableAttributedString *attstrS = [[NSMutableAttributedString alloc] initWithString:atterstr.string attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            
            [btn setAttributedTitle:attstrS forState:UIControlStateSelected];
            
        }
    }
    
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{

}

@end
