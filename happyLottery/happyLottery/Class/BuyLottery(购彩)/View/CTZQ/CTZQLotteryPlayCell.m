//
//  CTZQLotteryPlayCell.m
//  Lottery
//
//  Created by only on 16/3/24.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "CTZQLotteryPlayCell.h"
#import "UIImage+ImageWithColor.h"

@implementation CTZQLotteryPlayCell

- (void)awakeFromNib {
    for (UIButton *btn in _btnArr) {
        [self setUpBtn:btn];
        [self updateBtns];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [super awakeFromNib];
}

- (void)setFrame:(CGRect)frame{
//    frame.origin.y += 6;
    frame.size.height -= 6;
    [super setFrame:frame];
}

- (void)setUpBtn:(UIButton *)btn{
    
    [btn setBackgroundImage:[UIImage imageWithColor:MAINBGC] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:UIControlStateSelected];
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
    

    // Configure the view for the selected state
}

- (void)updateWithMatch:(CTZQMatch *)match{
    self.match = match;
    self.matchNumStr.text = [NSString stringWithFormat:@"第%@场",_match.matchNum];
    self.matchLegueNum.text = _match.leagueName;
    self.matchBeginTime.text = _match.startTime;
    self.homeName.text = _match.homeName;
    self.guestName.text = _match.guestName;
    [self updateBtns];
}
- (void)updateBtns{
    for (UIButton *btn in _btnArr) {
        NSInteger btnIndex = [_btnArr indexOfObject:btn];
        UIColor *color = TEXTGRAYCOLOR;
        NSString *oddsArrow = @"";
        NSString *oddStr = @"";
        NSString *oddStrNum = @"";
        NSString *title = @"";
        NSString *selected = @"";
        NSString *key = @"";
        switch (btnIndex) {
        case 0:
            {
                title = @"3";
                if (_match) {
                    oddStr = _match.oddsS;
                    oddStrNum = _match.oddsSNum;
                    selected = _match.selectedS;
//                    _match.oddsFStr
                    key = @"oddsSStr";
                }
            }
            break;
        case 1:
            {
                title = @"1";
                if (_match) {
                    oddStr = _match.oddsP;
                    oddStrNum = _match.oddsPNum;
                    selected = _match.selectedP;
                    key = @"oddsPStr";
                }
            }
            break;
        case 2:
            {
                title = @"0";
                if (_match) {
                    oddStr = _match.oddsF;
                    oddStrNum = _match.oddsFNum;
                    selected = _match.selectedF;
                    key = @"oddsFStr";
                }
            }
            break;
        default:
            
            break;
        }
        if ([oddStr isEqualToString:@"-1"]) {
            color = SystemGreen;
            oddsArrow = @"";//↑
        }else if ([oddStr isEqualToString:@"0"]){
            color = SystemLightGray;
        }else if ([oddStr isEqualToString:@"1"]){
            color = SystemRed;
            oddsArrow = @"";//⬇︎↓↓↓
        }
        if ([oddStrNum integerValue] == 0) {
            oddStrNum = @"--";
        }
        oddStr = [NSString stringWithFormat:@"(%@%@)",oddStrNum,oddsArrow];
        if ([oddStrNum isEqualToString:@""]) {
            oddStr = @"";
        }
        NSMutableAttributedString *attstrN = [[NSMutableAttributedString alloc] init];
        [attstrN appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",title] attributes:@{NSForegroundColorAttributeName:TEXTGRAYCOLOR}]];
        [attstrN appendAttributedString:[[NSAttributedString alloc] initWithString:oddStr attributes:@{NSForegroundColorAttributeName:color}]];
        NSMutableAttributedString *attstrS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",title,oddStr] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [btn setAttributedTitle:attstrN forState:UIControlStateNormal];
        [btn setAttributedTitle:attstrS forState:UIControlStateSelected];
        
        [_match setValue:attstrN forKey:key];
        
        if ([selected integerValue] == 1) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
        
    }
}
- (IBAction)userSelected:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSInteger btnIndex = [_btnArr indexOfObject:sender];
    CTZQWinResultType selectedResult = CTZQWinResultEmpty;
//    if (sender.selected) {
        switch (btnIndex) {
            case 0:
            {
                if(sender.selected){
                    selectedResult = CTZQWinResultHomeWin;
                    _match.selectedS = @"1";
                }else{
                    selectedResult = CTZQWinResultEmpty;
                    _match.selectedS = @"0";
                }
            }
                break;
            case 1:
            {
                if (sender.selected) {
                    selectedResult = CTZQWinResultHomeDraw;
                    _match.selectedP = @"1";
                }else{
                    selectedResult = CTZQWinResultEmpty;
                    _match.selectedP = @"0";
                }
                
            }
                break;
            case 2:
            {
                if (sender.selected) {
                    selectedResult = CTZQWinResultHomeLose;
                    _match.selectedF = @"1";
                }else{
                    selectedResult = CTZQWinResultEmpty;
                    _match.selectedF = @"0";
                }
            }
                break;
            default:
                selectedResult = CTZQWinResultEmpty;
                break;
        }
//    }
    if ([_delegate respondsToSelector:@selector(CTZQLPCell:DidSelected:)]) {
        [_delegate CTZQLPCell:self DidSelected:selectedResult];
    }
//    sender.selected = !sender.selected;
}



@end
