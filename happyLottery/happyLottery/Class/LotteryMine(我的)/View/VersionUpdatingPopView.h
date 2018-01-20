//
//  VersionUpdatingPopView.h
//  Lottery
//
//  Created by onlymac on 2017/9/30.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VersionUpdatingPopViewDelegate <NSObject>

-(void)lijigenxin;

@end

@interface VersionUpdatingPopView : UIView
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UIButton *guanbibtn;
@property (weak, nonatomic) IBOutlet UIButton *lijigenxinBtn;
@property (weak, nonatomic) IBOutlet UIButton *xiaochachaBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContstraints;

@property (nonatomic
           ,weak)id<VersionUpdatingPopViewDelegate> delegate;
@end
