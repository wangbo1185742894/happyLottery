 //
//  WBHomeYuceListCell.m
//  Lottery
//
//  Created by 王博 on 2017/10/18.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "WBHomeYuceListCell.h"


@interface WBHomeYuceListCell ()

@property (weak, nonatomic) IBOutlet UILabel *labMatchId;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightDistanceBtnItem;
@property (weak, nonatomic) IBOutlet UIButton *labTextYuce;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftDistanceBtnItem;
@property (weak, nonatomic) IBOutlet UIView *viewResult;


@property (weak, nonatomic) IBOutlet UILabel *labMatchState;
@property (weak, nonatomic) IBOutlet UILabel *labMatchHomeName;
@property (weak, nonatomic) IBOutlet UILabel *labMatchGuestName;
@property (weak, nonatomic) IBOutlet UILabel *labMatchProce;

@property (weak, nonatomic) IBOutlet UIButton *btnSheng;
@property (weak, nonatomic) IBOutlet UIButton *btnPing;
@property (weak, nonatomic) IBOutlet UIButton *btnFu;
@property (weak, nonatomic) IBOutlet UILabel *leaName;
@property (weak, nonatomic) IBOutlet UIButton *btnWonStatus;

@property(nonatomic,strong)HomeYCModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *imgHomeIcon;

@property (weak, nonatomic) IBOutlet UIImageView *imgGuestIcon;

@end

@implementation WBHomeYuceListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"WBHomeYuceListCell" owner: nil options:nil] lastObject];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}
- (IBAction)actionToSelectMatchType:(UIButton *)sender {
    [self.delegate homeYuceListTouzhu:self.model];
}

-(void)refreshCellWithModel:(HomeYCModel *)model isZuiXin:(BOOL )isZuixin{
    [self.imgHomeIcon sd_setImageWithURL:[NSURL URLWithString:model.homeImageUrl]];
    [self.imgGuestIcon sd_setImageWithURL:[NSURL URLWithString:model.guestImageUrl]];

    self.labTextYuce.layer.cornerRadius = 2;
    
    self.labMatchProce.hidden = NO;
    [self.btnSheng setTitleColor:SystemGray forState:UIControlStateNormal];
    [self.btnPing setTitleColor:SystemGray forState:UIControlStateNormal];
    [self.btnFu setTitleColor:SystemGray forState:UIControlStateNormal];
    
    [self.btnSheng setTitleColor:SystemGray forState:UIControlStateSelected];
    [self.btnPing setTitleColor:SystemGray forState:UIControlStateSelected];
    [self.btnFu setTitleColor:SystemGray forState:UIControlStateSelected];
    
    self.labMatchState.adjustsFontSizeToFitWidth = YES;
    self.leaName.text = model.leagueName;
    self.btnFu.userInteractionEnabled = NO;
    self.btnPing.userInteractionEnabled = NO;
    self.btnSheng.userInteractionEnabled = NO;
    
    
    self.model = model;
    self.labMatchId.text = model.lineId;
    self.labMatchHomeName.text =[NSString stringWithFormat:@"%@",model.homeName] ;
    self.labMatchGuestName.text =[NSString stringWithFormat:@"%@", model.guestName];
    self.labMatchHomeName.adjustsFontSizeToFitWidth = YES;
    self.labMatchGuestName.adjustsFontSizeToFitWidth = YES;
    if ([model.lottery integerValue] == 10) {
        self.btnFu.hidden = YES;
        self.rightDistanceBtnItem.constant = 0;
        self.leftDistanceBtnItem.constant = 0;
        if (self.model.matchResult != nil) {
            NSString *homeScore = [[self.model.matchResult componentsSeparatedByString:@":"] firstObject];
            NSString *guestScore = [[self.model.matchResult componentsSeparatedByString:@":"] lastObject];
            if ([homeScore integerValue] > [guestScore integerValue]) {
                [self.btnSheng setTitleColor:SystemGreen forState:UIControlStateSelected];
                [self.btnSheng setTitleColor:SystemGreen forState:0];
            }else{
                [self.btnPing setTitleColor:SystemGreen forState:0];
                [self.btnPing setTitleColor:SystemGreen forState:UIControlStateSelected];
            }
        }
        
        
        
        for (JcForecastOptions *ops in model.predict) {
            switch ([ops.options integerValue]) {
                case 0:
                    self.btnSheng.selected = [ops.forecast boolValue];
                    
                    [self.btnSheng setTitle:[NSString stringWithFormat:@"主负%.2f",[ops.sp doubleValue]] forState:0];
                    break;
                case 1:
                    self.btnPing.selected = [ops.forecast boolValue];
                    [self.btnPing setTitle:[NSString stringWithFormat:@"主胜%.2f",[ops.sp doubleValue]] forState:0];
                    break;
                    
                default:
                    break;
            }
        }
        
        
    }else{
        [self showZhiboInfo:nil];
        self.btnFu.hidden = NO;
        self.rightDistanceBtnItem.constant = 0;
        self.leftDistanceBtnItem.constant = 0;
        if (self.model.matchResult != nil) {
            NSString *homeScore = [[self.model.matchResult componentsSeparatedByString:@":"] firstObject];
            NSString *guestScore = [[self.model.matchResult componentsSeparatedByString:@":"] lastObject];
            if ([homeScore integerValue] > [guestScore integerValue]) {
                [self.btnSheng setTitleColor:SystemRed forState:  UIControlStateSelected];
                [self.btnSheng setTitleColor:SystemRed forState:UIControlStateNormal];
            }else if ([homeScore integerValue] == [guestScore integerValue]){
                [self.btnPing setTitleColor:SystemRed forState: UIControlStateSelected];
                [self.btnPing setTitleColor:SystemRed forState:UIControlStateNormal ];
            }else{
                [self.btnFu setTitleColor:SystemRed forState:  UIControlStateSelected];
                [self.btnFu setTitleColor:SystemRed forState:UIControlStateNormal ];
            }
        }
        for (JcForecastOptions *ops in model.predict) {
            switch ([ops.options integerValue]) {
                case 0:
                    self.btnSheng.selected = [ops.forecast boolValue];
                    [self.btnSheng setTitle:[NSString stringWithFormat:@"主胜%.2f",[ops.sp doubleValue]] forState:0];
                    break;
                case 1:
                    self.btnPing.selected = [ops.forecast boolValue];
                    [self.btnPing setTitle:[NSString stringWithFormat:@"平局%.2f",[ops.sp doubleValue]] forState:0];
                    break;
                case 2:
                    self.btnFu.selected = [ops.forecast boolValue];
                    [self.btnFu setTitle:[NSString stringWithFormat:@"主负%.2f",[ops.sp doubleValue]] forState:0];
                    break;
                default:
                    break;
            }
        }
        
    }
    if (isZuixin) {
        self.labMatchState.text  = [NSString stringWithFormat:@"截止时间:%@",[model.dealLine substringWithRange:NSMakeRange(5, 11)]];
        self.labMatchState.textColor = SystemGreen;

    }else{
        
        self.labMatchState.text  = @"";
        self.labMatchState.textColor = SystemGreen;
    }
    
    self.labMatchProce.text = [NSString stringWithFormat:@"%@%%",model.predictIndex];
    
}
-(void)showZhiboInfo:(id)zhibo{
    if ([self.model.matchResult isEqualToString:@"(null)"]  || self.model.matchResult == nil) {
        self.labMatchState.text = [NSString stringWithFormat:@"结束比分：暂无比分"];
    }else{
        
        self.labMatchState.text = [NSString stringWithFormat:@"结束比分：%@",self.model.matchResult];
    }
    if ([self.model.hit boolValue] == YES) {
        [self.btnWonStatus setBackgroundImage:[UIImage imageNamed:@"icon_mingzhong_"] forState:0];
        [self.btnWonStatus setTitle:@"命中" forState:0];
        
        
    }else{
        if (self.model.matchResult == nil) {
            [self.btnWonStatus setBackgroundImage:[UIImage imageNamed:@"icon_daizhi_"] forState:0];
            [self.btnWonStatus setTitle:@"待知" forState:0];
            
            
            
        }else{
            [self.btnWonStatus setBackgroundImage:[UIImage imageNamed:@"icon_weizhong_"] forState:0];
            [self.btnWonStatus setTitle:@"未中" forState:0];
            
        }
    }
}

-(void)setMatchResult:(NSString *)result{
    if (result == nil || result .length ==0) {
    self.labMatchState.text  = [NSString stringWithFormat:@"赛果:待知"];
    }else{
        self.labMatchState.text  = [NSString stringWithFormat:@"赛果:%@",self.model.matchResult];
    }
    
    self.labMatchState.textColor = SystemGreen;
}


@end
