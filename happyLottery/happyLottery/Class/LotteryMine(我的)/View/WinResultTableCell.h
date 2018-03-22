//
//  WinResultTableCell.h
//  Lottery
//
//  Created by only on 16/1/27.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WinResultTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *winNotLa;
- (void)refreshWithInfo:(NSString *)info;
- (void)refreshWithGYJInfo:(NSString *)info;
@end
