//
//  ChongZhiRulePopView.h
//  Lottery
//
//  Created by onlymac on 2017/9/27.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChongZhiRulePopViewDelegate <NSObject>

- (void)showRuleBtnPage;
@end
@interface ChongZhiRulePopView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btnTitle;

@property (weak, nonatomic) IBOutlet UITextView *tvContent;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContentView;
@property (weak, nonatomic) IBOutlet UIButton *telBtn;
@property (weak, nonatomic) IBOutlet UIButton *showRuleBtn;

@property (nonatomic,assign)id<ChongZhiRulePopViewDelegate> delegate;
@end
