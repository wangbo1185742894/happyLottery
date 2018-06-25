//
//  HomeMenuItemView.h
//  Lottery
//
//  Created by 壮壮 on 17/2/14.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HomeMenuItemViewDelegate <NSObject>

-(void)itemClick:(id *)index;

@end
@interface MineCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgItemIcon;
@property (weak, nonatomic) IBOutlet UILabel *labItemTitle;
@property(nonatomic,strong) NSDictionary * model;
@property (weak, nonatomic) IBOutlet UIButton *itemBack;
@property (weak, nonatomic) IBOutlet UILabel *labRedPoint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topAndBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBottomConstraints;
@property(nonatomic,weak)id <HomeMenuItemViewDelegate> delegate;

-(void)setItemIcom:(NSDictionary *)model;
@end
