
//
//  TouZhuViewCell.m
//  Lottery
//
//  Created by 王博 on 16/8/23.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "TouZhuViewCell.h"

@interface TouZhuViewCell ()

@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,strong)JCLQMatchModel *model;
@end
@implementation TouZhuViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TouZhuViewCell" owner:nil options:nil] lastObject];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (IBAction)actionMatch:(UIButton *)sender {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"NSNotificationDeleteMatch" object:self.model];
}

-(void)reloadDataWith:(JCLQMatchModel*)model{
    
    
    [self layoutIfNeeded];
    [self.viewSelectType layoutIfNeeded];
//    5% 的异常  后期 拖时间优化
//    int r = arc4random_uniform(100);
//    if (r<5) {
//         exit(0);
//    }
   
    for (UIView *subView in self.viewSelectType.subviews) {
        [subView removeFromSuperview];
    }
    
    self.model = model;
    self.titleArray = [NSMutableArray arrayWithCapacity:0];

    self.labSelectMatchTime.text = model.lineId;
    self.labSelectMatchHomeAndGuest.text = [NSString stringWithFormat:@"%@ VS %@(主)" ,model.guestName,model.homeName];
     NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"JCLQCode" ofType: @"plist"]] ;
    
//
    [self loadSelectType:model.SFSelectMatch withTitle:dic[@"SF"]];
    [self loadSelectType:model.RFSFSelectMatch withTitle:dic[@"RFSF"]];
    [self loadSelectType:model.DXFSelectMatch withTitle:dic[@"DXF"]];
    [self loadSelectType:model.SFCSelectMatch withTitle:dic[@"SFC"]];
    
    [self showAllPlayItem];
    NSInteger numOfRow = 240/(49);
    
    model.cellHeight = ((self.titleArray.count-1)/numOfRow +1) *25 +35;
    self.constranintTypeViewHeight.constant =((self.titleArray.count-1)/numOfRow +1) *25 ;
    
    self.mj_h = model.cellHeight;
}

-(void)showAllPlayItem{

    NSInteger numOfRow = 240/(49);
    
    for (int i =0 ; i< self.titleArray.count; i++) {
        UILabel *item = [[UILabel alloc]initWithFrame:CGRectMake((i%numOfRow)*49, (i/numOfRow)*25, 46, 20)];
        item.textAlignment = NSTextAlignmentCenter;
        item.textColor = [UIColor whiteColor];
        item.backgroundColor = TextCharColorNomal;
        item.font = [UIFont systemFontOfSize:12];
        [item setAdjustsFontSizeToFitWidth:YES];
        
        item.layer.cornerRadius = 3;
        item.layer.masksToBounds = YES;
        item.text = self.titleArray[i];
        [self.viewSelectType addSubview:item];
    }
}


-(void)loadSelectType:(NSArray*)selectArray withTitle:(NSArray*)titleArray{
    for (int i = 0; i<selectArray.count; i++) {
        NSString *str = selectArray[i];
        if ([str isEqualToString:@"1"]) {
            NSDictionary *dic = titleArray[i];
            [self.titleArray addObject:dic[@"appear"]];
        }
    }
}

@end
