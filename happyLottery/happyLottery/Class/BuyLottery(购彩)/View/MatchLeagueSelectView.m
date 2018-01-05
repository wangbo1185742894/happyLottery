//
//  MatchLeagueSelectView.m
//  happyLottery
//
//  Created by 王博 on 2017/12/19.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "MatchLeagueSelectView.h"

@interface MatchLeagueSelectView()

@property (weak, nonatomic) IBOutlet UIButton *btnSelectAll;

@property (weak, nonatomic) IBOutlet UIButton *btnSelectInvert;
@property (weak, nonatomic) IBOutlet UIButton *btnFiveMatch;
@property (weak, nonatomic) IBOutlet UIView *viewMatchLeagueItem;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UILabel *labSelectNum;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UILabel *labSelectMatchBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightViewContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightVewFatherVIew;
@property(strong,nonatomic)NSMutableArray *arrayItemLea;
@end

@implementation MatchLeagueSelectView

-(id)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"MatchLeagueSelectView" owner:nil options:nil] lastObject];
    }
    self.arrayItemLea = [NSMutableArray arrayWithCapacity:0];
    self.frame = frame;
    return self;
}



- (IBAction)actionMatchSelect:(UIButton *)sender {
    _btnSelectAll.selected = NO;
    _btnSelectInvert.selected = NO;
    _btnFiveMatch.selected = NO;
    sender.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        
        _labSelectMatchBottom.center = CGPointMake(sender.center.x, _labSelectMatchBottom.center.y);
    }];
    
    if (sender.tag == 1000) {
        for (UIButton *btn in self.arrayItemLea) {
            btn.selected = YES;
        }
    }else if(sender.tag == 1001){
        for (UIButton *btn in self.arrayItemLea) {
            btn.selected = !btn.selected;
        }
    }else if(sender.tag == 1002){
        for (UIButton *btn in self.arrayItemLea) {
            if ([btn.currentTitle isEqualToString:@"英超"]||[btn.currentTitle isEqualToString:@"英超"]||[btn.currentTitle isEqualToString:@"英超"]||[btn.currentTitle isEqualToString:@"英超"]||[btn.currentTitle isEqualToString:@"英超"]) {
                btn.selected = YES;
            }else{
                btn.selected = NO;
            }
        }
    }
}

- (IBAction)actionCancel:(id)sender {
    self.hidden = YES;
}
- (IBAction)btnSubmit:(id)sender {
    NSMutableArray *selectArray = [NSMutableArray arrayWithCapacity:0];
    for (UIButton *btn in self.arrayItemLea) {
        if (btn.selected == YES) {
            [selectArray addObject:btn.currentTitle];
        }
    }
    [self.delegate selectedLeagueItem:selectArray];
    self.hidden = YES;
}

-(void)loadMatchLeagueInfo:(NSArray <JCZQLeaModel *> *) leaArray{
    float curX = 0;
    float curY = 0;
    float width = ( self.viewMatchLeagueItem.mj_w - 110)/3;
    float height = 30;
    float sumHeight = 0;
    for (int i = 0; i < leaArray.count; i ++) {
        
        curX = i % 3 * (width + 30) + 25;
        curY = i / 3 * (height + 7);
        JCZQLeaModel *model = leaArray[i];
        UIButton *lastButton = [self creatBtnWithFrame:CGRectMake(curX, curY, width, height) normal:@{@"nTitle":model.name,@"nImage":@"button_default",@"sImage":@"button_checked"} andTag:1000 andSelect:@"1"];
        [self.arrayItemLea addObject:lastButton];
        sumHeight = lastButton.mj_h + lastButton.mj_y;
    }
    
    if (sumHeight + 150 > 500) {
        self.heightVewFatherVIew.constant = 500;
        self.heightViewContent.constant = sumHeight + 5;
        
    }else{
        self.heightVewFatherVIew.constant = sumHeight + 170;
        self.heightViewContent.constant = sumHeight + 5;
    }
    
}
-(UIButton *)creatBtnWithFrame:(CGRect)frame normal:(NSDictionary *)dic andTag:(NSInteger )tag andSelect:(NSString *)isselect{
    
    UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
    item.frame =  frame;
    item.tag = tag;
    item.selected = [isselect boolValue];
    [item setTitle:dic[@"nTitle"] forState:UIControlStateNormal];
    [item setTitleColor:RGBCOLOR(72, 72, 72) forState:0];
    [item setTitleColor:SystemGreen forState:UIControlStateSelected];
    item.titleLabel.numberOfLines = 0;
    item.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    item.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [item setBackgroundImage:[UIImage imageNamed: dic[@"nImage"]] forState:UIControlStateNormal];
    [item setBackgroundImage:[UIImage imageNamed:dic[@"sImage"]]  forState:UIControlStateSelected];
    [self.viewMatchLeagueItem addSubview:item];
    
    [item addTarget:self action:@selector(jczqCellItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return item;
    
}

-(void)jczqCellItemClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    
}

@end
