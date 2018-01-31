//
//  JCZQSelectAllPlayTypeVIew
//  happyLottery
//
//  Created by 王博 on 2017/12/19.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "JCZQSelectAllPlayTypeVIew.h"


@interface JCZQSelectAllPlayTypeVIew()
{
    JCZQMatchModel *_model;
    
}
@property (weak, nonatomic) IBOutlet UILabel *labGuestName;
@property (weak, nonatomic) IBOutlet  MGLabel*labHomeName;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *jczqSPFCellItem;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *jczqRQSPFCellItem;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *jczqBFCellItem;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *jczqJQSCellItem;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *jczqBQCCellItem;
@property (weak, nonatomic) IBOutlet UILabel *labRangQiuNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disItemViewToTop;

@end

@implementation JCZQSelectAllPlayTypeVIew

-(id)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"JCZQSelectAllPlayTypeVIew" owner:nil options:nil] lastObject];
    }
    self.selectItemPlay = [NSMutableArray arrayWithCapacity:0];
    self.frame = frame;
    if (frame.size.height == 568) {
        self.disItemViewToTop.constant = 15;
    }
    return self;
}

-(void)loadAllItemTitle:(JCZQMatchModel *)model andTitleDic:(NSDictionary *)titleDic{
    _model = model;
    [self loadSubItemTitle:model andTitleDic:titleDic[@"SPF"] andBtnArray:self.jczqSPFCellItem andSelectAr:model.SPF_SelectMatch andOddArray:model.SPF_OddArray];
    [self loadSubItemTitle:model andTitleDic:titleDic[@"RQSPF"] andBtnArray:self.jczqRQSPFCellItem andSelectAr:model.RQSPF_SelectMatch andOddArray:model.RQSPF_OddArray] ;
    [self loadSubItemTitle:model andTitleDic:titleDic[@"BF"] andBtnArray:self.jczqBFCellItem andSelectAr:model.BF_SelectMatch andOddArray:model.BF_OddArray];
    [self loadSubItemTitle:model andTitleDic:titleDic[@"BQC"] andBtnArray:self.jczqBQCCellItem andSelectAr:model.BQC_SelectMatch andOddArray:model.BQC_OddArray];
    [self loadSubItemTitle:model andTitleDic:titleDic[@"JQS"] andBtnArray:self.jczqJQSCellItem andSelectAr:model.JQS_SelectMatch andOddArray:model.JQS_OddArray];
}

-(void)loadSubItemTitle:(JCZQMatchModel *)model andTitleDic:(NSDictionary *)titleDic andBtnArray:(NSArray *)btnArray andSelectAr:(NSArray *)selectArray andOddArray:(NSArray *)oddArray {
    self.curModel = model;
    self.labHomeName.text = [NSString stringWithFormat:@"%@(主)",model.homeName];
    
    self.labHomeName.keyWord = @"(主)";
    self.labHomeName.keyWordFont = [UIFont systemFontOfSize:12];
    self.labHomeName.keyWordColor = SystemBlue;
    self.labGuestName.text = model.guestName;
    
    self.labRangQiuNum.text = self.curModel.handicap;
    self.labRangQiuNum.textColor = [UIColor whiteColor];
    if ([self.curModel.handicap integerValue] >0) {
        self.labRangQiuNum.backgroundColor = ColorFromImage(@"rangqiuzheng");
    }else{
        self.labRangQiuNum.backgroundColor = ColorFromImage(@"rangqiufu");
    }
    for (UIButton *itemBtn in btnArray) {
        NSString *tag = [NSString stringWithFormat:@"%ld",itemBtn.tag];
        NSString *title;
        if (itemBtn.tag /100 == 3) {
            title = [NSString stringWithFormat:@"%@\n%@",titleDic[tag][@"appear"],[self getSpNOTitle:oddArray index:itemBtn.tag %100]];
        }else{
            
            title = [NSString stringWithFormat:@"%@%@",titleDic[tag][@"appear"],[self getSpTitle:oddArray index:itemBtn.tag %100]];
        }
        
        
        itemBtn.selected = [selectArray[itemBtn.tag %100] boolValue];
        itemBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
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
        
//        [itemBtn setTitleColor:RGBCOLOR(72, 72, 72) forState:0];
//        [itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [itemBtn setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:UIControlStateSelected];
        [itemBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:0];
        [itemBtn setTitle:title forState:0];
        [itemBtn addTarget:self action:@selector(actionMatchSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)actionMatchSelect:(UIButton *)sender {
    if (sender.tag == 0) {
        return;
    }
    
    NSInteger playType = sender.tag / 100;
    BOOL isCanBuy = YES;
    switch (playType) {
        case 1:
            isCanBuy = [self.delegate canBuyThisMatch:_model andIndex:0];
            
            break;
        case 2:
            
            isCanBuy = [self.delegate canBuyThisMatch:_model andIndex:4];
            
            break;
        case 3:
            
            isCanBuy = [self.delegate canBuyThisMatch:_model andIndex:2];
            
            break;
        case 4:
            
            isCanBuy = [self.delegate canBuyThisMatch:_model andIndex:3];
            
            break;
        case 5:
            
            isCanBuy = [self.delegate canBuyThisMatch:_model andIndex:1];
            
            break;
        default:
            break;
    }
    
    if (isCanBuy == NO) {
        
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
    
   
    
    for (UIButton *item in _jczqBFCellItem) {
        if (item.selected == YES) {
            [self.selectItemPlay addObject:@(item.tag)];
        }
    }
    
    for (UIButton *item in _jczqSPFCellItem) {
        if (item.selected == YES) {
            [self.selectItemPlay addObject:@(item.tag)];
        }
    }
    
    for (UIButton *item in _jczqRQSPFCellItem) {
        if (item.selected == YES) {
            [self.selectItemPlay addObject:@(item.tag)];
        }
        
    }
    
    for (UIButton *item in _jczqBQCCellItem) {
        if (item.selected == YES) {
            [self.selectItemPlay addObject:@(item.tag)];
        }
    }
    
    for (UIButton *item in _jczqJQSCellItem) {
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
