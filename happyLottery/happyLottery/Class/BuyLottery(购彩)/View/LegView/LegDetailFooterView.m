//
//  LegDetailFooterView.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "LegDetailFooterView.h"

@interface LegDetailFooterView()

@property (weak, nonatomic) IBOutlet UILabel *cornorView;


@end


@implementation LegDetailFooterView

-(id)initWithFrame:(CGRect)frame{
    if(self  = [super initWithFrame:frame]){
        self  = [[[NSBundle mainBundle] loadNibNamed:@"LegDetailFooterView" owner:nil options:nil] lastObject];
    }
    [self loadUI];
    return self;
}

- (void)loadUI {
    self.cornorView.layer.masksToBounds = YES;
    self.cornorView.layer.cornerRadius = 8;
    self.refreshBtn.layer.masksToBounds = YES;
    self.refreshBtn.layer.cornerRadius = 14;
    self.refreshBtn.layer.borderColor = SystemGreen.CGColor;
    self.refreshBtn.layer.borderWidth = 1;
    
}

- (IBAction)actionToRefresh:(id)sender {
    [self.delegate refreshDetail];
}

- (IBAction)actionToDelegate:(id)sender {
    [self.delegate lookLegDelegate];
}
@end
