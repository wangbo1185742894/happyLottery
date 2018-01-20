//
//  ZhuiHaoStopPushVIew.h
//  Lottery
//
//  Created by 王博 on 2017/7/4.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "AlertPushtView.h"

@interface ZhuiHaoStopPushVIew : AlertPushtView
@property (weak, nonatomic) IBOutlet UILabel *labContent;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;
-(void)refreshInfo:(NSString  *)title andContent:(NSString *)content;
@end
