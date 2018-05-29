//
//  ZhuiHaoStopPushVIew.m
//  Lottery
//
//  Created by 王博 on 2017/7/4.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "ZhuiHaoStopPushVIew.h"
#import "AppDelegate.h"

@implementation ZhuiHaoStopPushVIew

-(id)initWithFrame:(CGRect)frame{
    
    if (self = [ super initWithFrame: frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ZhuiHaoStopPushVIew" owner:nil options:nil] lastObject];
        self.frame = frame;
    }
    return self;
}

//        // 中奖停追
//        WIN_STOP("中奖停追"),
//        // 到期停追
//        END_STOP("到期停追"),
//        // 失败停追
//        FAILURE_STOP("失败停追");
-(void)refreshInfo:(NSString  *)title andContent:(NSString *)content{
    self.labTitle.text = title;
    self.labContent.text = content;
}

- (IBAction)actionColse:(UIButton *)sender {
    [self close];
}
- (IBAction)actionToDetail:(UIButton *)sender {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([self.pageCode isEqualToString:@"A204"]) {
          [app showZhuihaoDetail:nil];
    }else{
        [app goToYunshiWithInfo:self.pageCode];
    }
  
    [self close];
}

@end
