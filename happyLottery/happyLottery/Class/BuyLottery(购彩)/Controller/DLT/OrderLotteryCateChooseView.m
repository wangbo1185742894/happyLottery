//
//  OrderLotteryCateChooseView.m
//  Lottery
//
//  Created by Yang on 15/6/22.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import "OrderLotteryCateChooseView.h"

#define CellH  44

@implementation OrderLotteryCateChooseView
{
    UILabel *sepLine;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubViews];
    }
    return self;
}


-(void)initSubViews{
    
    backControl = [[UIControl alloc] initWithFrame:self.bounds];
    [backControl addTarget:self action:@selector(cancelChoose) forControlEvents:UIControlEventTouchUpInside];
    backControl.backgroundColor = [UIColor blackColor];
    backControl.alpha = 0.1;
    [self addSubview:backControl];
    backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chosebackground"]];
    [self addSubview:backImage];
    
    tableView_ = [[UITableView alloc] init];
    //    tableView_.center = self.center;
    tableView_.frame = CGRectMake(KscreenWidth - 120, 70, 20, 200);
    tableView_.dataSource = self;
    backImage.frame = CGRectMake(KscreenWidth - 120, 64, 20, 210);    tableView_.delegate = self;
    
    //    tableView_.layer.cornerRadius = 7;
    tableView_.clipsToBounds = YES;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableView_];
}
-(void)cancelChoose{
    [self.delegate orderStateChoosed:nil];
    [self hide];
}

-(void)show:(UIView *)supView withType:(TableShowType)type{
    tableShowType = type;
    if (type == TableShowTypeOrderStateChoose) {
        _sourceArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OrderStateDictionary" ofType:@"plist"]];
        if (nil == _curSelectStateInfo) {
            self.curSelectStateInfo = _sourceArray[0];
        }
    }else if(type == TableShowTypeLotteryCateChoose){
        NSMutableArray * sourceTemp ;
        
        NSArray * array = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LotteryConfig" ofType:@"plist"]];
        sourceTemp = [NSMutableArray arrayWithArray:@[array[0],array[1],array[2],array[7],array[8],array[9],array[4],array[5]]];
        NSDictionary * dic = @{@"Name":@"所有彩种"};
        [sourceTemp insertObject:dic atIndex:0];
        _sourceArray = sourceTemp;
        if (nil == _curSelectLotteryInfo) {
            self.curSelectLotteryInfo = _sourceArray[0];
        }
    }
    //10.26
    else if (type == TableShowZHTypeOrderStateChoose){
        _sourceArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zhuihaowinStatus" ofType:@"plist"]];
        if (nil == _zhstateSelect) {
            self.zhstateSelect = _sourceArray[0];
        }
    }else if (type == TableShowZHCatchStateChoose){
        _sourceArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zhuihaocatchStatus" ofType:@"plist"]];
        if (nil == _zhCatchSelect) {
            self.zhCatchSelect = _sourceArray[0];
        }
    }else if (type == TableShowZHRightStateChoose){
        NSMutableArray * sourceTemp ;
        NSArray * array = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LotteryConfig" ofType:@"plist"]];
        sourceTemp = [NSMutableArray arrayWithArray:@[array[0],array[2],array[4],array[5]]];
        NSDictionary * dic = @{@"Name":@"所有彩种"};
        [sourceTemp insertObject:dic atIndex:0];
        _sourceArray = [NSArray arrayWithArray:sourceTemp];
        if (nil == _curSelectLotteryInfo) {
            self.curSelectLotteryInfo = _sourceArray[0];
        }
    }else if (type == TableShowHeMaiRightStateChoose){
        NSMutableArray * sourceTemp ;
        
        NSArray * array = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LotteryConfig" ofType:@"plist"]];
        sourceTemp = [NSMutableArray arrayWithArray:@[array[1],array[2],array[7],array[8],array[9],array[4],array[5]]];
        NSDictionary * dic = @{@"Name":@"所有彩种"};
        [sourceTemp insertObject:dic atIndex:0];
        _sourceArray = sourceTemp;
        if (nil == _curSelectLotteryInfo) {
            self.curSelectLotteryInfo = _sourceArray[0];
        }
        
    }else if (type == TableShowHeMaiDaTingRightStateChoose){
        NSMutableArray * sourceTemp ;
        
        NSArray * array = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LotteryConfig" ofType:@"plist"]];
        sourceTemp = [NSMutableArray arrayWithArray:@[array[1],array[2],array[7],array[8],array[9],array[4],array[5]]];
        _sourceArray = sourceTemp;
        if (nil == _curSelectLotteryInfo) {
            self.curSelectLotteryInfo = _sourceArray[0];
        }
    }
    
    float table_w = 100;
    
    float table_y = 50;
    
    float maxHeight = self.frame.size.height-2*table_y;
    float table_H = _sourceArray.count * CellH;;
    if (maxHeight < table_H) {
        table_H = maxHeight;
    }
    CGRect fram = CGRectMake(KscreenWidth - table_w-8, 64, 100, table_H);
    CGRect fram_tb = tableView_.frame;
    backImage.frame  = CGRectMake(KscreenWidth - table_w - 10, 50 , 110, table_H + 20);;
    fram_tb = fram;
    tableView_.frame = fram_tb;
    tableView_.backgroundColor = [UIColor clearColor];
    //    tableView_.center = self.center;
    
    self.alpha = 0;
    
    [tableView_ reloadData];
    tableView_.bounces = NO;
    [supView addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}
-(void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            self.alpha = 1;
        }
    }];
}


#pragma mark --  UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sourceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * cellIdentify = @"cellIdentify";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        sepLine = [[UILabel alloc]initWithFrame:CGRectMake(10,43.5,200,0.5)];
        sepLine.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:sepLine];
        
    }
    NSDictionary * sourceInfo = _sourceArray[indexPath.row];
    BOOL isSelected = NO;
    if (tableShowType == TableShowTypeOrderStateChoose) {
        if ([sourceInfo[@"appearStr"] isEqualToString:_curSelectStateInfo[@"appearStr"]]) {
            isSelected = YES;
        }
        cell.textLabel.text = sourceInfo[@"appearStr"];
        
    }else if(tableShowType == TableShowTypeLotteryCateChoose){
        if ([sourceInfo[@"Identifier"] isEqualToString:_curSelectLotteryInfo[@"Identifier"]]||[sourceInfo[@"Identifier"] isEqualToString:@"所有彩种"]) {
            isSelected = YES;
        }
        //        if (_curSelectStateInfo == nil&&_isCTZQ) {
        //            if ([_isCTZQ isEqualToString:@"RJC"]&&indexPath.row == 0) {
        //                 isSelected = YES;
        //            }else if([_isCTZQ isEqualToString:@"SFC"]&&indexPath.row == 1){
        //
        //            }else{
        //                isSelected = NO;
        //            }
        //        }
        cell.textLabel.text = sourceInfo[@"Name"];
    }else if (tableShowType == TableShowZHTypeOrderStateChoose){
        if ([sourceInfo[@"appearStr"] isEqualToString:_zhstateSelect[@"appearStr"]]) {
            isSelected = YES;
        }
        cell.textLabel.text = sourceInfo[@"appearStr"];
        
    }else if (tableShowType == TableShowZHCatchStateChoose){
        if ([sourceInfo[@"appearStr"] isEqualToString:_zhCatchSelect[@"appearStr"]]) {
            isSelected = YES;
        }
        cell.textLabel.text = sourceInfo[@"appearStr"];
        
    }else if (tableShowType == TableShowZHRightStateChoose){
        if ([sourceInfo[@"Identifier"] isEqualToString:_curSelectLotteryInfo[@"Identifier"]]||[sourceInfo[@"Identifier"] isEqualToString:@"所有彩种"]) {
            isSelected = YES;
        }
        cell.textLabel.text = sourceInfo[@"Name"];
        
    }else if(tableShowType == TableShowHeMaiRightStateChoose){
        if ([sourceInfo[@"Identifier"] isEqualToString:_curSelectLotteryInfo[@"Identifier"]]||[sourceInfo[@"Identifier"] isEqualToString:@"所有彩种"]) {
            isSelected = YES;
        }
        
        cell.textLabel.text = sourceInfo[@"Name"];
    }else if (tableShowType == TableShowHeMaiDaTingRightStateChoose){
        if ([sourceInfo[@"Identifier"] isEqualToString:_curSelectLotteryInfo[@"Identifier"]]) {
            isSelected = YES;
        }
        
        cell.textLabel.text = sourceInfo[@"Name"];
    }
    
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.alpha = 0.0;
    cell.contentView.backgroundColor = [UIColor clearColor];
    if (indexPath.row == _sourceArray.count - 1) {
//        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0,cell.bounds.size.width);
        sepLine.hidden = YES;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * stateInfo = _sourceArray[indexPath.row];
    
    if (tableShowType == TableShowTypeLotteryCateChoose) {
        
        if (_curSelectLotteryInfo == stateInfo) {
            return;
        }
        if (_curSelectLotteryInfo) {
            int index = (int)[_sourceArray indexOfObject:_curSelectLotteryInfo];
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        self.curSelectLotteryInfo = stateInfo;
        [self.delegate lotteryCateChoosed:_curSelectLotteryInfo];
        
    }else if (tableShowType == TableShowTypeOrderStateChoose){
        
        if (_curSelectStateInfo == stateInfo) {
            return;
        }
        if (_curSelectStateInfo) {
            int index = (int)[_sourceArray indexOfObject:_curSelectStateInfo];
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        self.curSelectStateInfo = stateInfo;
        [self.delegate orderStateChoosed:_curSelectStateInfo];
        
    }//10.26
    else if (tableShowType == TableShowZHTypeOrderStateChoose){
        if (_zhstateSelect == stateInfo) {
            return;
        }
        if (_zhstateSelect) {
            int index = (int)[_sourceArray indexOfObject:_zhstateSelect];
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        self.zhstateSelect = stateInfo;
        [self.delegate zhStateChoose:_zhstateSelect];
        
    }else if (tableShowType == TableShowZHCatchStateChoose){
        if (_zhCatchSelect == stateInfo) {
            return;
        }
        if (_zhCatchSelect) {
            int index = (int)[_sourceArray indexOfObject:_zhCatchSelect];
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        self.zhCatchSelect = stateInfo;
        [self.delegate zhCatchChoose:_zhCatchSelect];
        
    }else if (tableShowType == TableShowZHRightStateChoose){
        
        if (_curSelectLotteryInfo == stateInfo) {
            return;
        }
        if (_curSelectLotteryInfo) {
            int index = (int)[_sourceArray indexOfObject:_curSelectLotteryInfo];
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        self.curSelectLotteryInfo = stateInfo;
        [self.delegate lotteryCateChoosed:_curSelectLotteryInfo];
        
    }else if (tableShowType == TableShowHeMaiRightStateChoose){
        
        if (_curSelectStateInfo == stateInfo) {
            return;
        }
        if (_curSelectStateInfo) {
            int index = (int)[_sourceArray indexOfObject:_curSelectStateInfo];
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        self.curSelectStateInfo = stateInfo;
        [self.delegate orderStateChoosed:_curSelectStateInfo];
        
    }else if (tableShowType == TableShowHeMaiDaTingRightStateChoose){
        if (_curSelectStateInfo == stateInfo) {
            return;
        }
        if (_curSelectStateInfo) {
            int index = (int)[_sourceArray indexOfObject:_curSelectStateInfo];
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        self.curSelectStateInfo = stateInfo;
        [self.delegate orderStateChoosed:_curSelectStateInfo];

    }
}
@end
