//
//  TZSelectMatchCell.m
//  happyLottery
//
//  Created by 王博 on 2017/12/22.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "TZSelectMatchCell.h"
#import "MGLabel.h"
@interface TZSelectMatchCell ()

@property (weak, nonatomic) IBOutlet UIView *viewSelectItemContentView;
@property(strong,nonatomic) JCZQMatchModel *model;
@property (weak, nonatomic) IBOutlet UILabel *labLineId;
@property (weak, nonatomic) IBOutlet MGLabel *labHomeName;
@property (weak, nonatomic) IBOutlet UILabel *labGuestName;

@end

@implementation TZSelectMatchCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"TZSelectMatchCell" owner:nil options:nil] lastObject];
    }
    return self;
}

-(void)loadData:(JCZQMatchModel *)model{
    self.model = model;
    self.labHomeName.text = [NSString stringWithFormat:@"%@(主)",model.homeName];
    
    self.labHomeName.keyWord = @"(主)";
    self.labHomeName.keyWordFont = [UIFont systemFontOfSize:12];
    self.labHomeName.keyWordColor = SystemBlue;
    self.labGuestName.text = model.guestName;
    self.labLineId.text = model.lineId;
    
    for (UIView *subView in self.viewSelectItemContentView.subviews) {
        [subView removeFromSuperview];
    }
    float curY = 8;
    if ([model getTouzhuAppearTitleByTypeNoSp:@"SPF"] .length != 0) {
        curY += [self createLab:@"SPF" andTitle:@"胜平负" andCurY:curY andModel:model];
        
    }
    if ([model getTouzhuAppearTitleByTypeNoSp:@"RQSPF"] .length != 0) {
         curY +=[self createLab:@"RQSPF" andTitle:[NSString stringWithFormat:@"让球(%@)",model.handicap] andCurY:curY andModel:model];
        
    }
    if ([model getTouzhuAppearTitleByTypeNoSp:@"BQC"] .length != 0) {
         curY +=[self createLab:@"BQC" andTitle:@"半全场" andCurY:curY andModel:model];
        
    }
    if ([model getTouzhuAppearTitleByTypeNoSp:@"JQS"] .length != 0) {
       curY += [self createLab:@"JQS" andTitle:@"进球数" andCurY:curY andModel:model];
        
    }
    if ([model getTouzhuAppearTitleByTypeNoSp:@"BF"] .length != 0) {
       curY += [self createLab:@"BF" andTitle:@"比分" andCurY:curY andModel:model];
    }
}



-(CGFloat)createLab:(NSString *)playtype andTitle:(NSString *)title andCurY:(float)curY andModel:(JCZQMatchModel *)model{
    
    UILabel *labTitle = [[UILabel alloc]initWithFrame:CGRectMake(8, curY, 80, 18)];
    labTitle.text = [NSString stringWithFormat:@"%@：",title];
    labTitle.font = [UIFont systemFontOfSize:14];
    NSString *titleSelect = [model getTouzhuAppearTitleByTypeNoSp:playtype];
    
    [self.viewSelectItemContentView addSubview:labTitle];
    
    CGFloat height =[titleSelect boundingRectWithSize:CGSizeMake(KscreenWidth - 140, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.height;
    UILabel *labItem = [[UILabel alloc]initWithFrame:CGRectMake(93, curY, KscreenWidth - 140, height)];
    labItem.text =titleSelect;
    [self.viewSelectItemContentView addSubview:labItem];
    labTitle.textColor = RGBCOLOR(72, 72, 72);
    labItem.textColor = RGBCOLOR(254,168,19);
    labItem.font = [UIFont systemFontOfSize:13];
    labItem.numberOfLines = 0;
    return height + 2;
}
- (IBAction)actionCleanMatch:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:KSELECTMATCHCLEAN object:self.model];
}

@end
