//
//  BetsListPopViewCell.m
//  Lottery
//
//  Created by AMP on 5/28/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "BetsListPopViewCell.h"

#define NumberFont  [UIFont systemFontOfSize: 15]
#define TextFont    [UIFont systemFontOfSize: 15]
#define LeftPadding         15
#define TopPadding          5
#define DeleteButtonWidth   50
#define MinLineHeight       21

#define keySerializedFrameLabelNumber  @"LabelNumber"
#define keySerializedFrameLabelSummary @"LabelSummary"
#define keySerializedFrameButtonDelete @"ButtonDelete"
#define keyBetNumberText    @"BetNumberText"
#define keyDownLine @"DownLine"

@interface BetsListPopViewCell() {
    UILabel *numberTextLabel;
    UILabel *summaryLabel;
    UIButton *deleteButton;
    
}
@end

@implementation BetsListPopViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) cellHeight: (LotteryBet *) bet withFrame: (CGRect) frame {
    if (nil != bet.betCellDataDic) {
        return bet.popViewCellHeight;
    }
    NSMutableDictionary *betCellDataDic = [NSMutableDictionary dictionary];
    CGFloat totalHeight = TopPadding;
    
    //calculate for number label
//    2016-03-16
    CGFloat numberLabelWidth = KscreenWidth - LeftPadding - DeleteButtonWidth;
    NSAttributedString *numberAttributedString;
//    if ([GlobalInstance instance].JumpToPlaylotteryIdentifier) {
//        numberAttributedString = bet.betNumbersDesc;
//        [GlobalInstance instance].JumpToPlaylotteryIdentifier = nil;
//    }else{
        numberAttributedString = [bet betNumberDesc: NumberFont];
//    }
   
    betCellDataDic[keyBetNumberText] = numberAttributedString;
    CGSize maxSize = CGSizeMake(numberLabelWidth, CGFLOAT_MAX);
    CGSize textSize = [numberAttributedString boundingRectWithSize: maxSize
                                                           options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                           context: nil].size;
    CGFloat textHeight = MinLineHeight;
    if (textSize.height > textHeight) {
        textHeight = textSize.height;
    }
    CGRect textFrame = CGRectMake(LeftPadding, totalHeight, numberLabelWidth, textHeight);
    betCellDataDic[keySerializedFrameLabelNumber] = NSStringFromCGRect(textFrame);
    totalHeight += textHeight;
    
    //calculate for summary label
    totalHeight += TopPadding;
    CGRect summaryFrame = CGRectMake(LeftPadding, totalHeight, numberLabelWidth, MinLineHeight);
    betCellDataDic[keySerializedFrameLabelSummary] = NSStringFromCGRect(summaryFrame);
    totalHeight += MinLineHeight;
    
    //add bottom padding
    totalHeight += TopPadding;
    
    //calculate for delete button
    CGFloat buttonY = (totalHeight - DeleteButtonWidth) / 2;
    CGRect buttonFrame = CGRectMake(KscreenWidth - 15 - DeleteButtonWidth, buttonY, DeleteButtonWidth, DeleteButtonWidth);
    betCellDataDic[keySerializedFrameButtonDelete] = NSStringFromCGRect(buttonFrame);
    bet.betCellDataDic = betCellDataDic;
    bet.popViewCellHeight = totalHeight;
    // 预约cell间隔条修改 lyw
    CGRect downLineFrame = CGRectMake(15, 0 , KscreenWidth - 2*15, SEPHEIGHT);
    betCellDataDic[keyDownLine] = NSStringFromCGRect(downLineFrame);
    totalHeight += SEPHEIGHT;
    return totalHeight;
}

- (void) updateWithBet: (LotteryBet *) bet {
//    NSLog(@"6666666666666------%@", bet.betCellDataDic[keyDownLine]);
//     NSLog(@"6666666666666------%@", bet.betCellDataDic[keySerializedFrameLabelNumber]);
    
//     NSLog(@"6666666666666------%@", bet.betCellDataDic[keySerializedFrameLabelSummary]);
//     NSLog(@"6666666666666------%@", bet.betCellDataDic[keySerializedFrameButtonDelete]);
    self.backgroundColor = [UIColor clearColor];
    
    if (_downLine == nil) {
        _downLine = [[UILabel alloc] initWithFrame:CGRectFromString(bet.betCellDataDic[keyDownLine])];
        _downLine.backgroundColor = SEPCOLOR;
        [self addSubview:_downLine];
    }
    
    //add number label
    if (numberTextLabel == nil) {
        numberTextLabel = [[UILabel alloc] initWithFrame: CGRectZero];
        numberTextLabel.font = NumberFont;
        numberTextLabel.numberOfLines = 0;
        numberTextLabel.backgroundColor = [UIColor clearColor];
        [self addSubview: numberTextLabel];
    }
    CGRect numberTextLabelFrame = CGRectFromString(bet.betCellDataDic[keySerializedFrameLabelNumber]);
    numberTextLabel.frame = numberTextLabelFrame;
    numberTextLabel.attributedText = bet.betCellDataDic[keyBetNumberText];
     NSLog(@"*********------%@", bet.betCellDataDic[keyBetNumberText]);
    
    //add summary text
    if (summaryLabel == nil) {
        summaryLabel = [[UILabel alloc] initWithFrame: CGRectZero];
        summaryLabel.textColor = [UIColor lightGrayColor];
        summaryLabel.backgroundColor = [UIColor clearColor];
        summaryLabel.font = NumberFont;
        [self addSubview: summaryLabel];
    }
    CGRect summaryLabelFrame = CGRectFromString(bet.betCellDataDic[keySerializedFrameLabelSummary]);
    summaryLabel.frame = summaryLabelFrame;
    summaryLabel.text = [bet getCellSummaryText];
    NSLog(@"下面的---%@",summaryLabel.text );
    
    //add delete button
    if (deleteButton == nil) {
        deleteButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [deleteButton setImage: [UIImage imageNamed: @"delete.png"] forState: UIControlStateNormal];
        [deleteButton addTarget: self action: @selector(deleteAction) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: deleteButton];
    }
    CGRect buttonFrame = CGRectFromString(bet.betCellDataDic[keySerializedFrameButtonDelete]);
    [deleteButton setFrame: buttonFrame];
}

- (void) deleteAction {
    [self.delegate removeBetAction: self.indexPath];
//    UIAlertView *deleteConfirmAlertView = [[UIAlertView alloc] initWithTitle: TextRemoveBet
//                                                                     message: nil
//                                                                    delegate: self
//                                                           cancelButtonTitle: TextDimiss otherButtonTitles: TextDelete, nil];
//    [deleteConfirmAlertView show];
}

#pragma UIAlertViewDelegate methods
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//    if (buttonIndex != alertView.cancelButtonIndex) {
//        [self.delegate removeBetAction: self.indexPath];
//    }
//}
@end
