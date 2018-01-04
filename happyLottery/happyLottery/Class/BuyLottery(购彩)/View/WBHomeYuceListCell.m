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

@property (weak, nonatomic) IBOutlet UILabel *labText2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftDistanceBtnItem;
@property (weak, nonatomic) IBOutlet UIView *viewResult;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewleft;
@property (weak, nonatomic) IBOutlet UILabel *labIndex;
@property (weak, nonatomic) IBOutlet UILabel *labText;

@property (weak, nonatomic) IBOutlet UILabel *labMatchState;
@property (weak, nonatomic) IBOutlet UILabel *labMatchHomeName;
@property (weak, nonatomic) IBOutlet UILabel *labMatchGuestName;
@property (weak, nonatomic) IBOutlet UILabel *labMatchProce;
@property (weak, nonatomic) IBOutlet UIButton *btnMatchYuceState;
@property (weak, nonatomic) IBOutlet UIButton *btnSheng;
@property (weak, nonatomic) IBOutlet UIButton *btnPing;
@property (weak, nonatomic) IBOutlet UIButton *btnFu;
@property (weak, nonatomic) IBOutlet UILabel *leaName;

@property(nonatomic,strong)HomeYCModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;

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
    self.labTextYuce.layer.cornerRadius = 2;
    self.viewResult.hidden = YES;
    self.labMatchProce.hidden = NO;
    self.labText2.hidden = NO;
    [self.btnSheng setTitleColor:SystemGreen forState:UIControlStateNormal];
    [self.btnPing setTitleColor:SystemGreen forState:UIControlStateNormal];
    [self.btnFu setTitleColor:SystemGreen forState:UIControlStateNormal];
    
    [self.btnSheng setTitleColor:RGBCOLOR(51, 153, 204) forState:UIControlStateSelected];
    [self.btnPing setTitleColor:RGBCOLOR(51, 153, 204) forState:UIControlStateSelected];
    [self.btnFu setTitleColor:RGBCOLOR(51, 153, 204) forState:UIControlStateSelected];
    
    self.labMatchState.adjustsFontSizeToFitWidth = YES;
    self.leaName.text = model.leagueName;
    self.btnMatchYuceState.userInteractionEnabled=  YES
    ;
    self.btnFu.userInteractionEnabled = NO;
    self.btnPing.userInteractionEnabled = NO;
    self.btnSheng.userInteractionEnabled = NO;
    
    if ([model.spfSingle boolValue] == NO && [model.lottery isEqualToString:@"10"]) {
        self.btnMatchYuceState.hidden = YES;
    }else{
        
        self.btnMatchYuceState.hidden = NO;
    }
    
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
        
        self.btnFu.hidden = NO;
        self.rightDistanceBtnItem.constant = 0;
        self.leftDistanceBtnItem.constant = 0;
        if (self.model.matchResult != nil) {
            NSString *homeScore = [[self.model.matchResult componentsSeparatedByString:@":"] firstObject];
            NSString *guestScore = [[self.model.matchResult componentsSeparatedByString:@":"] lastObject];
            if ([homeScore integerValue] > [guestScore integerValue]) {
                [self.btnSheng setTitleColor:SystemGreen forState:  UIControlStateSelected];
                [self.btnSheng setTitleColor:SystemGreen forState:UIControlStateNormal];
            }else if ([homeScore integerValue] == [guestScore integerValue]){
                [self.btnPing setTitleColor:SystemGreen forState: UIControlStateSelected];
                [self.btnPing setTitleColor:SystemGreen forState:UIControlStateNormal ];
            }else{
                [self.btnFu setTitleColor:SystemGreen forState:  UIControlStateSelected];
                [self.btnFu setTitleColor:SystemGreen forState:UIControlStateNormal ];
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
        self.btnWidth.constant = 60;
        self.btnHeight.constant = 27;
        self.btnMatchYuceState.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnMatchYuceState setBackgroundImage:[UIImage imageNamed:@"btnOrangeBack"] forState:0];
        [self.btnMatchYuceState setTitle:@"预约投注" forState:0];
    }else{
        self.btnMatchYuceState.userInteractionEnabled = NO;
        self.labMatchState.text  = @"";
        self.labMatchState.textColor = SystemGreen;
        [self.btnMatchYuceState setTitle:@"" forState:0];
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
      
        self.imgViewleft.image = [UIImage imageNamed:@"minghzong_icon_yuce"];
        [self setViewresultState:0];
        
    }else{
        if (self.model.matchResult == nil) {
            self.imgViewleft.image = [UIImage imageNamed:@"wait_icon_yuce"];
            
            [self setViewresultState:1];
            
        }else{
            self.imgViewleft.image = [UIImage imageNamed:@"weizhong_icon_yuce"];
            [self setViewresultState:2];
        }
    }
}

-(void)setViewresultState:(NSInteger)index{
    self.viewResult.hidden = NO;
    self.btnMatchYuceState.hidden = YES;
    self.labMatchProce.hidden = YES;
    self.labText2.hidden = YES;
    UIColor *textColor ;
    UIColor *bordColor ;
    if (index == 0) {  // 命中
        textColor = SystemGreen;
        bordColor = SystemGreen;
    }else if (index == 1){  // 待知
        textColor = SystemGreen;
        bordColor =  RGBCOLOR(200, 200, 200);
    }else if (index == 2){ // 未命中
        textColor = SystemGreen;
        bordColor = RGBCOLOR(200, 200, 200);
    }
    self.labIndex.text =[NSString stringWithFormat:@"%@%%",self.model.predictIndex];
    self.labIndex.textColor = textColor;
    self.labText.textColor = textColor;
    self.viewResult.layer.cornerRadius = 3;
    self.viewResult.layer.masksToBounds = YES;
    self.viewResult.layer.borderColor = bordColor.CGColor;
    self.viewResult.layer.borderWidth = 1;
    self.viewResult.backgroundColor = [UIColor whiteColor];
    
}


@end
