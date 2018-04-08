//
//  JCLQDXFCell.m
//  Lottery
//
//  Created by 王博 on 16/8/17.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "JCLQDXFCell.h"

@implementation JCLQDXFCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"JCLQDXFCell" owner:nil options:nil] lastObject];
    }
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    // Configure the view for the selected state
}

- (IBAction)actionClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.delegate clickItem:@"1" model:self.model andIndex:sender.tag];
    }else{
        [self.delegate clickItem:@"0" model:self.model andIndex:sender.tag];
    
    }
    
}

-(void)loadDataWithModel:(JCLQMatchModel *)model{
    
    self.model = model;
    self.imgDanguan.hidden = !model.isDanGuan;
    self.labDXFGameName.text = model.leagueName;
    self.labDXFGameDay.text = model.lineId;
    self.labDXFGameTime.text =[NSString stringWithFormat:@"%@截止",[[[model.stopBuyTime componentsSeparatedByString:@" "] lastObject]substringToIndex:5]];
//    self.labDXFHomeAndGoust.text = [NSString stringWithFormat:@"%@ VS %@(主)",model.homeName,model.guestName];
    
    NSString *string =  [NSString stringWithFormat:@"%@客 VS %@主",model.guestName,model.homeName];
    
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange r1 = NSMakeRange(model.guestName.length, 1);
    NSRange r2 = NSMakeRange(string.length-1, 1);
    
    [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:r1];
    [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:r2];
    
    [aStr addAttribute:NSForegroundColorAttributeName value:SystemGreen range:r1];
    [aStr addAttribute:NSForegroundColorAttributeName value:SystemGreen range:r2];
    self.labDXFHomeAndGoust.attributedText = aStr;

    [self.btnDXFDY setTitle:[NSString stringWithFormat:@"大于%@  %.2f",model.hilo,[model.DXFSOddArray[0] doubleValue]] forState:UIControlStateNormal];
    [self.btnDXFXY setTitle:[NSString stringWithFormat:@"小于%@  %.2f",model.hilo,[model.DXFSOddArray[1] doubleValue]] forState:UIControlStateNormal];
    
    [self refreshSelected:self.model.DXFSelectMatch baseTag:300 andEnableArray:model.DXFSOddArray];
}



@end
