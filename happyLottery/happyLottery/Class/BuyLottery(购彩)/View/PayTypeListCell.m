
//
//  PayTypeListCell.m
//  happyLottery
//
//  Created by 王博 on 2017/12/26.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "PayTypeListCell.h"


@interface PayTypeListCell ()
@property (weak, nonatomic) IBOutlet UIButton *btnSelectState;
@property (weak, nonatomic) IBOutlet UILabel *labPayTypeTitle;
@property (weak, nonatomic) IBOutlet UIImageView *labPayTypeIcon;
@property (weak, nonatomic) IBOutlet UILabel *labPayTypeDes;

@end

@implementation PayTypeListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"PayTypeListCell" owner:nil options:nil] lastObject];
    }
    return self;
}

-(void)loadDataWithModel:(ChannelModel *)model{
    if ([model.channel isEqualToString:@"YUE"]) {
    self.labPayTypeDes.text = model.descValue;
    }else{
        self.labPayTypeDes.hidden = YES;
    }
    
    self.labPayTypeIcon.image = [UIImage imageNamed:model.channelIcon];
    self.labPayTypeTitle.text = model.channelTitle;
    self.btnSelectState.selected = model.isSelect;
}
-(void)chongzhiLoadDataWithModel:(ChannelModel *)model{
    if ([model.channel isEqualToString:@"UNION"]) {
        self.labPayTypeDes.textColor = SystemRed;
    }else{
        self.labPayTypeDes.textColor = RGBCOLOR(55, 55, 55);
    }
    self.labPayTypeDes.text = model.descValue;
    
    self.labPayTypeIcon.image = [UIImage imageNamed:model.channelIcon];
    self.labPayTypeTitle.text = model.channelTitle;
    self.btnSelectState.selected = model.isSelect;
}


@end
