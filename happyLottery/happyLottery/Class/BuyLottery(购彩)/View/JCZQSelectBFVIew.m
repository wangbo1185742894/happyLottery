//
//  JCZQSelectAllPlayTypeVIew
//  happyLottery
//
//  Created by 王博 on 2017/12/19.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "JCZQSelectBFVIew.h"

@interface JCZQSelectBFVIew()

{
    
    
}
@property (weak, nonatomic) IBOutlet UILabel *labGuestName;
@property (weak, nonatomic) IBOutlet MGLabel *labHomeName;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *jczqCellBfItem;

@end

@implementation JCZQSelectBFVIew

-(id)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"JCZQSelectBFVIew" owner:nil options:nil] lastObject];
    }
    self.frame = frame;
    self.selectItemPlay = [NSMutableArray arrayWithCapacity:0];
    
    return self;
}

-(void)loadAllItemTitle:(JCZQMatchModel *)model andTitleDic:(NSDictionary *)titleDic{
    self.curModel = model;
    self.labHomeName.text = [NSString stringWithFormat:@"%@(主)",model.homeName];
    
    self.labHomeName.keyWord = @"(主)";
    self.labHomeName.keyWordFont = [UIFont systemFontOfSize:12];
    self.labHomeName.keyWordColor = SystemBlue;
    self.labGuestName.text = model.guestName;
    self.labGuestName.text = self.curModel.guestName;
    
    for (UIButton *itemBtn in self.jczqCellBfItem) {
        NSString *tag = [NSString stringWithFormat:@"%ld",itemBtn.tag];
        NSString *title;
        if ([self checkThisItemCanBuy:itemBtn]) {
            
            title = [NSString stringWithFormat:@"%@%@",titleDic[tag][@"appear"],[self getSpTitle:model.BF_OddArray index:itemBtn.tag %100]];
        }else{
            
            title = [NSString stringWithFormat:@"%@0",titleDic[tag][@"appear"]];
        }
   
        
        itemBtn.selected = [model.BF_SelectMatch[itemBtn.tag %100] boolValue];
        [itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        NSMutableAttributedString *attrStrN = [[NSMutableAttributedString alloc] initWithString:title];
        NSMutableAttributedString *attrStrS = [[NSMutableAttributedString alloc] initWithString:title];
        if ([self checkThisItemCanBuy:itemBtn]) {
            NSDictionary * firstAttributesN = @{ NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:RGBCOLOR(72, 72, 72)};
            [attrStrN setAttributes:firstAttributesN range:NSMakeRange(0, attrStrN.string.length)];
            
            
            NSDictionary * firstAttributesS = @{ NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor whiteColor]};
            [attrStrS setAttributes:firstAttributesS range:NSMakeRange(0, attrStrS.string.length)];
            
        }else{
            NSDictionary * firstAttributesN = @{ NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:RGBCOLOR(72, 72, 72),NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)};
            [attrStrN setAttributes:firstAttributesN range:NSMakeRange(0, attrStrN.string.length)];
            [itemBtn setAttributedTitle:attrStrN forState:0];
            
            NSDictionary * firstAttributesS = @{ NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:RGBCOLOR(72, 72, 72),NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)};
            [attrStrS setAttributes:firstAttributesS range:NSMakeRange(0, attrStrS.string.length)];
            [itemBtn setAttributedTitle:attrStrS forState:0];
        }
        [itemBtn setAttributedTitle:attrStrS forState:UIControlStateSelected];
        [itemBtn setAttributedTitle:attrStrN forState:0];
        
        
        [itemBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:0];
        [itemBtn setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:UIControlStateSelected];
        [itemBtn setTitle:title forState:0];
    }
}

- (IBAction)actionMatchSelect:(UIButton *)sender {

    if (sender.tag == 0) {
        return;
    }
    if (![self checkThisItemCanBuy:sender]) {
        return;
    }
    sender.selected = !sender.selected;
//    if (sender.selected == YES) {
//        [self.selectItemPlay addObject:[NSString stringWithFormat:@"%ld",sender.tag]];
//    }else{
//        for (NSString *strTag in self.selectItemPlay) {
//            if ([strTag integerValue] == sender.tag) {
//                [self.selectItemPlay removeObject:strTag];
//                break;
//            }
//        }
//    }
}
- (IBAction)actionCancel:(id)sender {
    [self removeFromSuperview];
    
}
- (IBAction)btnSubmit:(id)sender {
    [self.curModel cleanAll];
    
    for (UIButton *item in _jczqCellBfItem) {
        if (item.selected == YES) {
            [self.selectItemPlay addObject:@(item.tag)];
        }
    }
    
    for (NSString *str in self.selectItemPlay) {
        [self jczqCellItemClickBase:[str integerValue]];
    }
    [self removeFromSuperview];
    [self.delegate JCZQPlayViewSelected];
}

@end
