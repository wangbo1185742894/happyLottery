//
//  CTZQHomeCell.h
//  Lottery
//
//  Created by 王博 on 16/3/24.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTZQHomeCell : UIView
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIImageView *imgTitleIcon;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labTitleDes;
@property (weak, nonatomic) IBOutlet UIImageView *lexuanhotImage;

-(void)setTaget:(id)target action:(SEL)action;
@end
