//
//  HomeMenuItemView.m
//  Lottery
//
//  Created by 王博 on 17/2/14.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "HomeMenuItemView.h"

@interface HomeMenuItemView ()
@property (weak, nonatomic) IBOutlet UIImageView *imgItemIcon;
@property (weak, nonatomic) IBOutlet UILabel *labItemTitle;

@property (weak, nonatomic) IBOutlet UIButton *itemBack;


@end

@implementation HomeMenuItemView

-(id)initWithFrame:(CGRect)frame{

    if (self == [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HomeMenuItemView" owner:nil options:nil] lastObject];
        self.frame = frame;
    }
    return self;
}


-(void)setItemIcom:(UIImage*)image title:(NSString *)title setTag:(NSInteger)index{

    self.itemBack.tag = index;
    self.labItemTitle.text = title;
    self.imgItemIcon.image = image;
}
- (IBAction)itemClick:(UIButton *)sender {
    [self.delegate itemClick:sender.tag];
    
}

@end
