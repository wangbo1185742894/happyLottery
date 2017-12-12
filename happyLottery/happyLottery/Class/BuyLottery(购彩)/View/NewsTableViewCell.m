//
//  NewsTableViewCell.m
//  happyLottery
//
//  Created by 王博 on 2017/12/12.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "NewsTableViewCell.h"

@interface NewsTableViewCell()
{
    
    
}
@property (weak, nonatomic) IBOutlet UILabel *labNewTitle;
@property (weak, nonatomic) IBOutlet UILabel *labLookNum;
@property (weak, nonatomic) IBOutlet UILabel *labNewTime;

@property (weak, nonatomic) IBOutlet UIImageView *imgNewIcon;

@end

@implementation NewsTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:nil options:nil] lastObject];
    }
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
