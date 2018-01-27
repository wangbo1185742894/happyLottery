//
//  TableViewCell.m
//  happyLottery
//
//  Created by 王博 on 2017/12/12.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "NewsListCell.h"
#import "LoopProgressView.h"
#import "MGLabel.h"
@interface NewsListCell()
{
    
    LoopProgressView * progressView;
    JczqShortcutModel * model;
}

@property(strong,nonatomic)JczqShortcutModel * model;
@property (weak, nonatomic) IBOutlet UILabel *labMatchLine;
@property (weak, nonatomic) IBOutlet UIImageView *imgWinIcon;
@property (weak, nonatomic) IBOutlet UILabel *labDeadLine;
@property (weak, nonatomic) IBOutlet UIImageView *imgHomeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgGuestIcon;
@property (weak, nonatomic) IBOutlet MGLabel*labHomeName;
@property (weak, nonatomic) IBOutlet UILabel *labGuestName;
@property (weak, nonatomic) IBOutlet UIButton *btnCollection;
@property (weak, nonatomic) IBOutlet UIButton *btnForecast;
@property (weak, nonatomic) IBOutlet UIButton *btnHomeWin;
@property (weak, nonatomic) IBOutlet UIButton *btnHomePing;
@property (weak, nonatomic) IBOutlet UIButton *btnHomeLose;
@property (weak, nonatomic) IBOutlet UILabel *labMatchResult;

@end

@implementation NewsListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"NewsListCell" owner:nil options:nil] lastObject];
        
    }
   
    return self;
}
- (IBAction)actionCollect:(UIButton *)sender {
    [self.delegate newScollectMatch:self.model andIsSelect:!self.btnCollection.selected ];
}



-(void)refreshDataCollect:(JczqShortcutModel * )model andSelect:(BOOL)isSelect{
    if (progressView == nil) {
        progressView = [[LoopProgressView alloc]initWithFrame:CGRectMake(KscreenWidth-124,20, 55, 55)];
        progressView.color1 = SystemBlue;
        progressView.color2 = SystemLightGray;
        
        
        [self addSubview:progressView];
    }
    
    self.labMatchResult.hidden = NO;
    if (model.matchResult  == nil || model.matchResult.length ==0 || [model.matchResult isEqualToString:@"(null)"]) {
        self.labMatchResult.text  = [NSString stringWithFormat:@"赛果:待知"];
    }else{
        self.labMatchResult.text  = [NSString stringWithFormat:@"赛果:%@",model.matchResult];
    }
    
    self.btnCollection.selected = isSelect;
    self.model = model;
    self.labMatchLine.text = [NSString stringWithFormat:@"%@ %@",model.leagueName, model.lineId];

    [self.imgHomeIcon sd_setImageWithURL:[NSURL URLWithString:model.homeImageUrl]];
    [self.imgGuestIcon sd_setImageWithURL:[NSURL URLWithString:model.guestImageUrl]];
    self.labHomeName.text =[NSString stringWithFormat:@"%@(主)",model.homeName] ;
    self.labHomeName.keyWord = @"(主)";
    self.labHomeName.keyWordFont = [UIFont systemFontOfSize:12];
    self.labHomeName.keyWordColor = BtnDisAbleTitleColor;
    self.labGuestName.text = [NSString stringWithFormat:@"%@",model.guestName];
    
    [self setMatchData:model];
    
        self.imgWinIcon.hidden =  ![self.model.hit boolValue];

    if (self.model.matchResult != nil) {
        NSString *homeScore = [[self.model.matchResult componentsSeparatedByString:@":"] firstObject];
        NSString *guestScore = [[self.model.matchResult componentsSeparatedByString:@":"] lastObject];
        if ([homeScore integerValue] > [guestScore integerValue]) {
            [self.btnHomeWin setTitleColor:SystemRed forState:  UIControlStateSelected];
            [self.btnHomeWin setTitleColor:SystemRed forState:UIControlStateNormal];
        }else if ([homeScore integerValue] == [guestScore integerValue]){
            [self.btnHomePing setTitleColor:SystemRed forState: UIControlStateSelected];
            [self.btnHomePing setTitleColor:SystemRed forState:UIControlStateNormal ];
        }else{
            [self.btnHomeLose setTitleColor:SystemRed forState:  UIControlStateSelected];
            [self.btnHomeLose setTitleColor:SystemRed forState:UIControlStateNormal ];
        }
    }
    
    progressView.progress = [model.predictIndex doubleValue] / 100.0;
    for (JcForecastOptions  * op in model.predict) {
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

-(void)refreshData:(JczqShortcutModel * )model andSelect:(BOOL)isSelect{
    if (progressView == nil) {
        progressView = [[LoopProgressView alloc]initWithFrame:CGRectMake(KscreenWidth-124,20, 55, 55)];
        progressView.color1 = SystemBlue;
        progressView.color2 = SystemLightGray;
        
        
        [self addSubview:progressView];
    }
    self.btnCollection.selected = isSelect;
    self.model = model;
    [self setMatchData:model];
    self.labMatchLine.text = [NSString stringWithFormat:@"%@ %@",model.leagueName, model.lineId];
    [self.imgHomeIcon sd_setImageWithURL:[NSURL URLWithString:model.homeImageUrl]];
    [self.imgGuestIcon sd_setImageWithURL:[NSURL URLWithString:model.guestImageUrl]];
    self.labHomeName.text =[NSString stringWithFormat:@"%@(主)",model.homeName] ;
    self.labHomeName.keyWord = @"(主)";
    self.labHomeName.keyWordFont = [UIFont systemFontOfSize:12];
    self.labHomeName.keyWordColor = BtnDisAbleTitleColor;
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

-(void)setMatchData:(JczqShortcutModel *)model{
    
    NSString *curDateM = [Utility timeStringFromFormat:@"MM" withDate:[NSDate date]];
    NSString *curDateD = [Utility timeStringFromFormat:@"dd" withDate:[NSDate date]];
    NSString *matchDateM =[[[model.dealLine componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"][1];
    NSString *matchDateD =[[[[model.dealLine componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] lastObject];
    
    if ([curDateM isEqualToString:matchDateM]) {
        NSInteger dayNum = [matchDateD integerValue] - [curDateD integerValue];
        if (dayNum == 0) {  // == 0 今天  ==1 明天   == 2  后天   == 3 大后天 哈哈 后面俩 逗测试玩玩
            self.labDeadLine.text =[NSString stringWithFormat:@"今日 %@", [model.dealLine substringWithRange:NSMakeRange(11, 5)]];
        }else if (dayNum == 1){
            self.labDeadLine.text =[NSString stringWithFormat:@"明日 %@", [model.dealLine substringWithRange:NSMakeRange(11, 5)]];
        }else{
            self.labDeadLine.text =[NSString stringWithFormat:@"%@", [model.dealLine substringWithRange:NSMakeRange(5, 11)]];
        }
    }else{
        self.labDeadLine.text =[NSString stringWithFormat:@"%@", [model.dealLine substringWithRange:NSMakeRange(5, 11)]];
    }
    
}
@end
