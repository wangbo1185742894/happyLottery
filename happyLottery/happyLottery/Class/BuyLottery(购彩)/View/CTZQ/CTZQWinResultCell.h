//
//  CTZQWinResultCell.h
//  Lottery
//
//  Created by LC on 16/3/29.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTZQWinResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *winNotLa;
- (void)refreshWithInfo:(NSString *)infoResult;
- (void)refreshWithInfoGYJ:(NSString *)infoResult;
@end
