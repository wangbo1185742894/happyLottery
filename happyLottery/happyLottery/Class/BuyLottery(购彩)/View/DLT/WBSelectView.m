//
//  WBSelectView.m
//  select
//
//  Created by 王博 on 16/2/23.
//  Copyright © 2016年 aoli. All rights reserved.
//

#import "WBSelectView.h"

@implementation WBSelectView

-(id)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"WBSelectView" owner:nil options:nil] lastObject];
        self.frame = frame;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [_cancelBtn setTitleColor:TEXTGRAYCOLOR forState:UIControlStateNormal];
     [_cancelBtn setTitleColor:TextLightgrayColor forState:UIControlStateHighlighted];
    return self;
}

/**
 *  tableView 代理方法
 *
 *  @param sender <#sender description#>
 */

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    self.tableViewHeight.constant = self.dataArray.count * 44<KscreenHeight-120?self.dataArray.count * 44:KscreenHeight-120;
    
    return self.dataArray.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"dataCell"];
    if (cell ==nil) {
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"dataCell"];
        //label居中
        UILabel *lable = [[UILabel alloc]init];
        lable.text = self.dataArray[indexPath.row];
        lable.textColor = TEXTGRAYCOLOR;
        [lable sizeToFit];
        lable.frame = CGRectMake((self.frame.size.width-lable.frame.size.width)/2, (cell.frame.size.height-lable.frame.size.height)/2, lable.frame.size.width, lable.frame.size.height);
        [cell addSubview:lable];
    }
    if (indexPath.row == self.index) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView.backgroundColor = CellSelectedColor;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    [self.delegate didSelect:indexPath];

}

- (IBAction)cancelButton:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)backGroundButton:(UIButton *)sender {
    
    [self removeFromSuperview];
}
@end
