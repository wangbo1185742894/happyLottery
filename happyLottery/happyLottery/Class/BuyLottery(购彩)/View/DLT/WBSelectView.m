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
        
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.textColor = TEXTGRAYCOLOR;
    
    {
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = CellSelectedColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view;
        if ([cell subviews].count>1) {
            view = [cell subviews][1];
        }
        
        CGRect downLineFrame = view.frame;
        [view removeFromSuperview];
        if ([self respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
            downLineFrame.origin.y = [self tableView:tableView heightForRowAtIndexPath:indexPath] - SEPHEIGHT;
        }else{
            downLineFrame.origin.y = 44 - SEPHEIGHT;
        }
        
        downLineFrame.origin.x = SEPLEADING;
        downLineFrame.size.width = tableView.frame.size.width - 2*SEPLEADING;
        downLineFrame.size.height = SEPHEIGHT;
        UILabel *downLine = [[UILabel alloc] init];
        downLine.backgroundColor = SEPCOLOR;
        NSInteger lineCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
        if (indexPath.row == lineCount - 1) {
            downLineFrame.origin.x = 0;
            downLineFrame.size.width = tableView.frame.size.width;
            //            downLineFrame.origin.y -= 1;
            //            downLine.frame =
        }//else{
        //downLine.frame = downLineFrame;
        //        }
        downLine.frame = downLineFrame;
        [cell addSubview:downLine];
        
        if (indexPath.row == self.index) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        
        if (indexPath.row == 0) {
            UILabel *upLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, SEPHEIGHT)];
            upLine.backgroundColor = SEPCOLOR;
            [cell addSubview:upLine];
            
        }

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
