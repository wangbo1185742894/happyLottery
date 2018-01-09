//
//  JCZQSelectAllPlayTypeVIew
//  happyLottery
//
//  Created by 王博 on 2017/12/19.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "JCZQSelectBQCVIew.h"

@interface JCZQSelectBQCVIew()

{
    
    JCZQMatchModel *_model;
}
@property (weak, nonatomic) IBOutlet UILabel *labHomeName;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *jczqCellBQCitem;
@property (weak, nonatomic) IBOutlet UILabel *labGuestName;

@end

@implementation JCZQSelectBQCVIew

-(id)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"JCZQSelectBQCVIew" owner:nil options:nil] lastObject];
    }
    self.selectItemPlay = [NSMutableArray arrayWithCapacity:0];
    self.frame = frame;
    return self;
}

-(void)loadAllItemTitle:(JCZQMatchModel *)model andTitleDic:(NSDictionary *)titleDic{
    self.curModel = model;
    self.labHomeName.text = self.curModel.homeName;
    self.labGuestName.text = self.curModel.guestName;
    for (UIButton *itemBtn in self.jczqCellBQCitem) {
        NSString *tag = [NSString stringWithFormat:@"%ld",itemBtn.tag];
        NSString *title = [NSString stringWithFormat:@"%@%@",titleDic[tag][@"appear"],[self getSpTitle:model.BQC_OddArray index:itemBtn.tag %100]];
        [itemBtn setTitleColor:RGBCOLOR(72, 72, 72) forState:0];
        itemBtn.selected = [model.BQC_SelectMatch[itemBtn.tag %100] boolValue];
        [itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [itemBtn setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:UIControlStateSelected];
        [itemBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:0];
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
- (IBAction)btnSubmit:(id)sender{
    [self.curModel cleanAll];
   
    
    
    for (UIButton *item in _jczqCellBQCitem) {
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
