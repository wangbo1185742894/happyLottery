//
//  ZhanWeiTuScheme.h
//  happyLottery
//
//  Created by LYJ on 2018/5/30.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhanWeiTuScheme : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *placeImage;


@property (weak, nonatomic) IBOutlet UILabel *placeLab;

- (void)reloadDateInFollow;

- (void)reloadDateInGroup;

@end
