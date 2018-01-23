//
//  YCSchemeViewCell.h
//  happyLottery
//
//  Created by 王博 on 2018/1/22.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBLoopProgressView.h"

@interface YCSchemeViewCell : UITableViewCell
{
    WBLoopProgressView *progressView;
}
@property (weak, nonatomic) IBOutlet UILabel *labAVGShouyi;

-(void)loadData:(NSDictionary *)infoDic;
@end
