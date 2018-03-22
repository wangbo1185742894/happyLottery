
//
//  OpenLotteryResultCell.m
//  Lottery
//
//  Created by 王博 on 16/3/28.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "OpenLotteryResultCell.h"
@interface OpenLotteryResultCell()
@property (weak, nonatomic) IBOutlet UILabel *laMatchNum;

@property (weak, nonatomic) IBOutlet UILabel *laHomeName;
@property (weak, nonatomic) IBOutlet UILabel *laGuestName;
@property (weak, nonatomic) IBOutlet UILabel *laMatchResult;
@property (weak, nonatomic) IBOutlet UILabel *laResult;

@end

@implementation OpenLotteryResultCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"OpenLotteryResultCell" owner:nil options:nil] lastObject];
        
    }
    return self;
    
}

- (void)refreshWithMatchInfo:(NSDictionary*)match{
    
    _laMatchNum.text = [Utility legalString:match[@"serialNumber"]];
    _laHomeName.text = [Utility legalString:match[@"homeName"]];
    _laGuestName.text = [Utility legalString:match[@"guestName"]];
    _laResult.text = [Utility legalString:match[@"lotteryResult"]];
    _laMatchResult.text = [Utility legalString:match[@"matchResult"]];
    
}

@end
