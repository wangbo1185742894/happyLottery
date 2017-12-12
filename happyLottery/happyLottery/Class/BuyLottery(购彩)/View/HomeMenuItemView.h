//
//  HomeMenuItemView.h
//  Lottery
//
//  Created by 王博 on 17/2/14.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HomeMenuItemViewDelegate <NSObject>

-(void)itemClick:(NSInteger)index;

@end
@interface HomeMenuItemView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topAndBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBottomConstraints;
@property(nonatomic,weak)id <HomeMenuItemViewDelegate> delegate;

-(void)setItemIcom:(UIImage*)image title:(NSString *)title setTag:(NSInteger)index;
@end
