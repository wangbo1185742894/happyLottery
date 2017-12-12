//
//  TableViewCell.m
//  happyLottery
//
//  Created by 王博 on 2017/12/12.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "NewsListCell.h"
#import "LoopProgressView.h"
@interface NewsListCell()
{
    
    LoopProgressView * progressView;
}
@property (weak, nonatomic) IBOutlet UILabel *labMatchLine;
@property (weak, nonatomic) IBOutlet UILabel *labDeadLine;
@property (weak, nonatomic) IBOutlet UIImageView *imgHomeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgGuestIcon;
@property (weak, nonatomic) IBOutlet UILabel *labHomeName;
@property (weak, nonatomic) IBOutlet UILabel *labGuestName;
@property (weak, nonatomic) IBOutlet UIButton *btnCollection;
@property (weak, nonatomic) IBOutlet UIButton *btnForecast;
@property (weak, nonatomic) IBOutlet UIButton *btnHomeWin;
@property (weak, nonatomic) IBOutlet UIButton *btnHomePing;
@property (weak, nonatomic) IBOutlet UIButton *btnHomeLose;

@end

@implementation NewsListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"NewsListCell" owner:nil options:nil] lastObject];
        
    }
    if (progressView == nil) {
        progressView = [[LoopProgressView alloc]initWithFrame:CGRectMake(KscreenWidth-124,20, 55, 55)];
        progressView.color1 = SystemBlue;
        progressView.color2 = SystemLightGray;
        progressView.progress = 0.4;
        
        [self addSubview:progressView];
    }
    return self;
}
- (IBAction)actionCollect:(UIButton *)sender {
    sender.selected = !sender.selected;
}
@end
