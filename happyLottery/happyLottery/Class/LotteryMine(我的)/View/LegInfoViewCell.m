//
//  LegInfoViewCell.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/10/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "LegInfoViewCell.h"
#import "LegAlertClickView.h"

@interface LegInfoViewCell(){
    NSString *_mobile;
    NSString *_wechat;
}
@property (weak, nonatomic) IBOutlet UIButton *labLegName;

@end

@implementation LegInfoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.labLegName.layer.borderColor  = RGBCOLOR(255, 160, 55).CGColor;
    self.labLegName.layer.borderWidth =  1;
    self.labLegName.layer.cornerRadius = 5;
    self.labLegName.layer.masksToBounds = YES;

}

-(void)LoadData:(NSString *)legName legMobile:(NSString *)mobile legWechat:(NSString *)wechat{
    [self.labLegName setTitle:legName forState:0];
    _mobile = mobile;
    _wechat = wechat;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)actionLegClick:(id)sender {
    
    LegAlertClickView * alertView = [[LegAlertClickView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    alertView.wechat = _wechat;
    alertView.mobile = _mobile;
     [[UIApplication sharedApplication].keyWindow addSubview:alertView];
     
}

@end
