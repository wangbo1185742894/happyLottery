//
//  FeedBackHistoryTableViewCell.m
//  happyLottery
//
//  Created by LYJ on 2018/1/12.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FeedBackHistoryTableViewCell.h"



@interface FeedBackHistoryTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *askLab;

@property (weak, nonatomic) IBOutlet UILabel *answerLab;
@property (weak, nonatomic) IBOutlet UIButton *answerBtn;

@end

@implementation FeedBackHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
 

}

- (void)setModel:(FeedBackHistory *)model
{
    _model = model;
    self.askLab.text=model.feedbackContent;
    if ([model.reply isEqualToString:@"1"]) {
        [self.answerBtn setBackgroundImage:[UIImage  imageNamed:@"answer.png"]  forState:UIControlStateNormal];
        self.answerLab.text=model.replyContent;
    }else{
          [self.answerBtn setBackgroundImage:[UIImage imageNamed:@"response.png"]  forState:UIControlStateNormal];
        self.answerLab.text = @"平台会尽快回复您，请您耐心等待，也可拨打客服电话400-668-0778";
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
