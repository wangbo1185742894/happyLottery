//
//  CTZQTouzhuRenjiuCell.m
//  Lottery
//
//  Created by 王博 on 16/3/28.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "CTZQTouzhuRenjiuCell.h"
#import "CTZQBet.h"
#import "UIImage+ImageWithColor.h"

@implementation CTZQTouzhuRenjiuCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"CTZQTouzhuRenjiuCell" owner:nil options:nil] lastObject];
        [self setButton:self.btnDan];
        [self setButton:self.btnDraw];
        self.btnWin.adjustsImageWhenHighlighted = NO;
        [self setButton:self.btnLose];
         self.btnLose.adjustsImageWhenHighlighted = NO;
        [self setButton:self.btnWin];
         self.btnDraw.adjustsImageWhenHighlighted = NO;
    
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    frame.size.height -= 6;
    [super setFrame:frame];
}

/**
 *  胆拖点击事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)actionDan:(UIButton *)sender {

    if (self.selectArray.count <= 9) {
        [self .delegate showInfo:@"至少选择10场比赛才能设胆"];
        return;
    }
    NSInteger danNumber = [self.delegate getDanCount];
    if (danNumber<8||sender.selected == YES) {
        sender.selected = !sender.selected;
        if (sender.selected) {
            self.cBet.cMatch.danTuo = @"1";
        }else{
            self.cBet.cMatch.danTuo = @"0";
        }
        [self.delegate refreshTouzhuVCSummary];
    }else{
        [self.delegate showInfo:@"设胆场数不能超过8场"];
    }
}
/**
 *  设置Btn的属性
 *
 *  @param btn btn description
 */
-(void)setButton:(UIButton*)btn{
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled
     ];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setTitleColor:TEXTGRAYCOLOR forState:UIControlStateNormal];


    [btn setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageWithColor:MAINBGC] forState:UIControlStateNormal];
    
    [btn setBackgroundImage:[UIImage imageWithColor:TFBorderColor] forState:UIControlStateDisabled];
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    
}
/**
 *  刷新cell
 */
-(void)reloadData{
//    [self refreshButton:self.btnDan value:self.cBet.cMatch.danTuo addTitle:nil];
    [self refreshButton:self. btnDraw value:self.cBet.cMatch.selectedP addTitle:self.cBet.cMatch.oddsPStr];
    [self refreshButton: self.btnLose value:self.cBet.cMatch.selectedF addTitle:self.cBet.cMatch.oddsFStr];
    [self refreshButton: self.btnWin value:self.cBet.cMatch.selectedS addTitle:self.cBet.cMatch.oddsSStr];
    
    [self refreshButton:self.btnDan value:self.cBet.cMatch.danTuo addTitle:nil];
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
