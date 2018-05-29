//
//  FollowHeaderView.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FollowHeaderView.h"

@interface FollowHeaderView()
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

@end

@implementation FollowHeaderView

-(id)initWithFrame:(CGRect)frame{
    if(self  = [super initWithFrame:frame]){
        self  = [[[NSBundle mainBundle] loadNibNamed:@"FollowHeaderView" owner:nil options:nil] lastObject];
    }
    self.btnSearch.layer.cornerRadius = 5;
    return  self;
}

- (void)setFrame:(CGRect)frame{
    frame.size.height -= 1;
    [super setFrame:frame];
}

- (IBAction)actionSearch:(id)sender {
    [self.delegate search];
}



@end
