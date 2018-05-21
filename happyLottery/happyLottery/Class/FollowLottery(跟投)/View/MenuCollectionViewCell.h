//
//  HomeMenuItemView.h
//  Lottery
//
//  Created by 壮壮 on 17/2/14.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeMenuItemViewDelegate <NSObject>

-(void)itemClick:(NSInteger )index;

@end
@interface MenuCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topAndBottom;
@property(nonatomic,assign) NSInteger index;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBottomConstraints;
@property(nonatomic,weak)id <HomeMenuItemViewDelegate> delegate;

-(void)setItemIcom:(NSDictionary *)model;
-(void)setEightItemIcom:(NSDictionary *)model;
@end
