//
//  WCHomeGYJItemViewCell.m
//  Lottery
//
//  Created by 王博 on 2018/3/12.
//  Copyright © 2018年 AMP. All rights reserved.
//

#import "WCHomeGYJItemViewCell.h"

@interface WCHomeGYJItemViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgGroupFlag1;
@property (weak, nonatomic) IBOutlet UIImageView *imgGroupFlag2;
@property (weak, nonatomic) IBOutlet UIButton *labMatchBack;
@property (weak, nonatomic) IBOutlet UILabel *nameGroupFlag1;
@property (weak, nonatomic) IBOutlet UILabel *nameGroupFlag2;
@property (weak, nonatomic) IBOutlet UILabel *pfBeiShu;
@property (weak, nonatomic) IBOutlet UILabel *labForeCast;
@property (weak, nonatomic) IBOutlet UILabel *xuelie;
@property (weak, nonatomic) IBOutlet UILabel *lableVs;


//@property (weak, nonatomic) IBOutlet UILabel *labMatchIndex;
//@property (weak, nonatomic) IBOutlet UILabel *labForeCast;
//
//@property (weak, nonatomic) IBOutlet UILabel *labClash;
//@property (weak, nonatomic) IBOutlet UILabel *labSp;

@end

@implementation WCHomeGYJItemViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *CellID = @"WCHomeGYJItemViewCell";
    WCHomeGYJItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:CellID owner:nil options:nil] lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor= [UIColor clearColor];
    cell.backgroundColor= [UIColor clearColor];
    return cell;
}

-(void)loadDataWith:(WordCupHomeItem * )model
{
    self.labMatchBack.selected = model.isSelect;
    self.imgGroupFlag1.image = [UIImage imageNamed:model.imgGuanKey];
    self.imgGroupFlag2.image = [UIImage imageNamed:model.imgYaKey];
    NSString *str= @"—";
    if ([model.clash rangeOfString:str].location!=NSNotFound) {
        NSArray *array = [model.clash componentsSeparatedByString:str];
        self.nameGroupFlag1.text = array[0];
        self.nameGroupFlag2.text = array[1];
        self.lableVs.text = @"vs";
    } else {
        self.nameGroupFlag1.text = nil;
        self.nameGroupFlag2.text= nil;
        self.lableVs.text = model.clash;
    }
    self.labForeCast.text = [NSString stringWithFormat:@"%.2f%%",[model.probability doubleValue]] ;
    self.pfBeiShu.text = model.odds;
    self.xuelie.text = model.indexNumber;
    if (model.isSelect) {
        self.labMatchBack.backgroundColor = RGBCOLOR(255,243,222);
    } else {
        self.labMatchBack.backgroundColor = [UIColor whiteColor];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
