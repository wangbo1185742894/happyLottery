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
    JczqShortcutModel * model;
}

@property(strong,nonatomic)JczqShortcutModel * model;
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
        
        
        [self addSubview:progressView];
    }
    return self;
}
- (IBAction)actionCollect:(UIButton *)sender {
    sender.selected = !sender.selected;
}

-(void)refreshData:(JczqShortcutModel * )model{
    
    self.model = model;
    self.labMatchLine.text = model.lineId;

    self.labDeadLine.text =[NSString stringWithFormat:@"截止:%@", [model.dealLine substringWithRange:NSMakeRange(5, 11)]];
    self.labHomeName.text =[NSString stringWithFormat:@"%@",model.homeName] ;
    self.labGuestName.text = [NSString stringWithFormat:@"%@",model.guestName];
    progressView.progress = [model.predictIndex doubleValue] / 100.0;
    for (JcForecastOptions  * op in model.forecastOptions) {
        BOOL isselect = [op.forecast boolValue];
        switch ([op.options integerValue]) {
            case 0:
                [self.btnHomeWin setTitle:[NSString stringWithFormat:@"主胜 %.2f",[op.sp doubleValue]] forState:0];
                self.btnHomeWin.selected = isselect;
                
                break;
                
            case 1:
                [self.btnHomePing setTitle:[NSString stringWithFormat:@"平 %.2f",[op.sp doubleValue]] forState:0];
                
                self.btnHomePing.selected = isselect;
                break;
                
                
            case 2:
                [self.btnHomeLose setTitle:[NSString stringWithFormat:@"客胜 %.2f",[op.sp doubleValue]] forState:0];
                
                self.btnHomeLose.selected = isselect;
                break;
            default:
                break;
        }
    }

    
    
}
@end
