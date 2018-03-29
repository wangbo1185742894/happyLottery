//
//  HomeGJItemViewCell.m
//  Lottery
//
//  Created by 王博 on 2018/3/12.
//  Copyright © 2018年 AMP. All rights reserved.
//

#import "HomeGJItemViewCell.h"

@interface HomeGJItemViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgGroupFlag;
@property (weak, nonatomic) IBOutlet UILabel *nameGroupFlag;
@property (weak, nonatomic) IBOutlet UIButton *labMatchBack;
@property (weak, nonatomic) IBOutlet UILabel *pfBeiShu;
@property (weak, nonatomic) IBOutlet UILabel *labForeCast;
@property (weak, nonatomic) IBOutlet UILabel *xuHao;

@end

@implementation HomeGJItemViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *CellID = @"HomeGJItemViewCell";
    HomeGJItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:CellID owner:nil options:nil] lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}


-(void)loadDataWith:(WordCupHomeItem * )model{
    self.labMatchBack.selected = model.isSelect;
    self.imgGroupFlag.image = [UIImage imageNamed:model.imgGuanKey];
    self.nameGroupFlag.text = model.clash;

    self.labForeCast.text = [NSString stringWithFormat:@"%.2f%%",[model.probability doubleValue]];
    self.labForeCast.font = [UIFont fontWithName:@"Helvetica-Condensed-Black-Se" size:18];
    self.pfBeiShu.text = model.odds;
    self.xuHao.text = model.indexNumber;
    if (model.isSelect) {
        self.labMatchBack.backgroundColor = RGBCOLOR(255,243,222);
    } else {
        self.labMatchBack.backgroundColor = [UIColor whiteColor];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
