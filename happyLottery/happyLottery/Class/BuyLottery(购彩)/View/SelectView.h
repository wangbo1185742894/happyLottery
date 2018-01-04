//
//  SelectView.h
//  Lottery
//
//  Created by 王博 on 16/1/18.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectViewDelegate <NSObject>

-(void)update;

@end

@interface SelectView : UIView

@property (weak, nonatomic) IBOutlet UITextField *labContent;
@property (assign , nonatomic)NSInteger beiShuLimit;

@property(strong,nonatomic)id<SelectViewDelegate>delegate;

-(id)initWithFrame:(CGRect)frame andRightTitle:(NSString*)rightTitle andLeftTitle:(NSString *)leftTitle;

-(void)setRightTitle:(NSString*)rightTitle andLeftTitle:(NSString *)leftTitle;

-(void)setTarget:(id)target rightAction:(SEL)rAction leftAction:(SEL)lAction;


@end
