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
-(void)loadData:(NewsModel *)model{
    
    self.labNewTitle.text = model.title;
    self.labLookNum.text = [NSString stringWithFormat:@"%ld浏览",[model.visitNum integerValue]];
    self.labNewTime.text = model.newsTime;
    [self.imgNewIcon sd_setImageWithURL:[NSURL URLWithString:model.titleImgUrl]];
    
}
@end
