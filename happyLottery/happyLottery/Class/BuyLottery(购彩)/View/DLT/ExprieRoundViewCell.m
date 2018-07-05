//
//  ExprieRoundViewCell.m
//  Lottery
//
//  Created by only on 16/1/19.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "ExprieRoundViewCell.h"

@implementation ExprieRoundViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)roundDesInfo:(DltOpenResult *)round andProfileID:(NSInteger )profileID{

    for (UIButton *btn in _ballArr) {
        [btn setBackgroundImage:nil forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setHidden:NO];
        [btn setUserInteractionEnabled:NO];
    }

//    if ((round.subRes && round.subRes.length != 0) || profileID == 9 || profileID == 10|| profileID == 21 || profileID == 22) {
//        _isX115 = NO;
//    }else{
//        _isX115 = YES;
//    }


    _qiHaoLa.text = [NSString stringWithFormat:@"第%@期",round.issueNumber];
    _qiHaoLa.textColor = SystemLightGray;
    NSString *betCountStr = [NSString stringWithFormat: @"%@", round.openResult];

    
    //不同的x115  玩法需要显示的数字个数不同；
    NSUInteger numCount;
    if (_isX115) {
        NSArray *betnumArray = [betCountStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"#,"]];
        switch (profileID) {
            case 8:     //前1
                numCount = 1;
                break;
            case 9:     //前2
                numCount = 2;
                break;
            case 10:    //前3
                numCount = 3;
                break;
            case 11:    //前2组
                numCount = 2;
                break;
            case 12:    //前3组
                numCount = 3;
                break;


            default:
                numCount = betnumArray.count;
                break;
        }

        for (UIButton *item in _ballArr) {
            item.hidden = YES;
        }
        for (int i=0; i < numCount; i++) {
          
            NSString *tempstr;
            tempstr = [NSString stringWithFormat:@"%02d",[betnumArray[i] intValue]];
            NSInteger index = [tempstr integerValue];


            UIButton *btn=(UIButton *) _ballArr[i];
            btn.hidden = NO;
            [btn setTitleColor:SystemRed forState:0];
            [btn setTitle:tempstr forState:0];
            
        }

    }else{
        NSArray *betnumArray = [betCountStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
        NSArray *redNum  = [[betnumArray firstObject] componentsSeparatedByString:@","];
        for (int i=0; i<redNum.count; i++) {
            NSString *tempstr;
            tempstr = [NSString stringWithFormat:@"%02d",[redNum[i] intValue]];
            UIButton *btn=(UIButton *) _ballArr[i];
            [btn setTitleColor:SystemRed forState:0];
            [btn setTitle:tempstr forState:UIControlStateNormal];
            
        }
        
        NSArray *subnumArray = [[betnumArray lastObject] componentsSeparatedByString:@","];
        //修改 _ballArr[5+i] --> _ballArr[redNum.count+i] lyw
        for (int i = 0; i<subnumArray.count; i++) {
            UIButton *btn = (UIButton*)_ballArr[redNum.count+i];
            [btn setTitle:subnumArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:SystemBlue forState:0];
            
        }
        NSMutableDictionary *subResNumberAttrsDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
        subResNumberAttrsDictionary[NSForegroundColorAttributeName] = [UIColor blueColor];
        //        subResNumberAttrsDictionary[NSParagraphStyleAttributeName] = paragraph;

//        [betInfoString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @" %@", round.subRes] attributes: subResNumberAttrsDictionary]];

        if(profileID == 10 || profileID == 9  || profileID == 21 || profileID == 22){
            for (int i = 5; i<11; i++) {
                UIButton *btn = (UIButton*)_ballArr[i];
                btn.hidden = YES;
            }
        }else{
            for (int i = 7; i<11; i++) {
                UIButton *btn = (UIButton*)_ballArr[i];
                btn.hidden = YES;
            }
        }
    }

    NSMutableAttributedString *betInfoString = [[NSMutableAttributedString alloc] init];

    NSMutableDictionary *textAttrsDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
    textAttrsDictionary[NSForegroundColorAttributeName] = SystemLightGray;
    //    textAttrsDictionary[NSParagraphStyleAttributeName] = paragraph;

    [betInfoString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@"第%@期",round.issueNumber] attributes: textAttrsDictionary]];

    NSMutableDictionary *mainResNumberAttrsDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
    mainResNumberAttrsDictionary[NSForegroundColorAttributeName] = [UIColor redColor];
    //    mainResNumberAttrsDictionary[NSParagraphStyleAttributeName] = paragraph;
    //bet count string


//    [betInfoString appendAttributedString: [[NSAttributedString alloc] initWithString: betNumStr attributes: mainResNumberAttrsDictionary]];

    //bet unit string
    //    NSString *qi = [NSString stringWithFormat:@"第%@期",round.issueNumber];
    //    NSString *shu = [NSString stringWithFormat:@" %@",round.mainRes];
    //    NSString *reult = [NSString stringWithFormat:@"%@%@",qi,shu];
    //
    //    cell.textLabel.text = reult;
    //    cell.textLabel.adjustsFontSizeToFitWidth = NO;
//    cell.textLabel.attributedText = betInfoString;
//    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];

}

@end
    


