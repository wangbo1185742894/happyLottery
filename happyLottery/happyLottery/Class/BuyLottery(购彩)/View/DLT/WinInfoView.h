//
//  WinInfoView.h
//  Lottery
//
//  Created by Yang on 15/7/8.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderProfile.h"
#import "LotteryBetObj.h"

@interface WinInfoView : UIView{


}

@property (nonatomic , strong) NSString * playtypename;
@property (nonatomic , strong) OrderProfile * orderProfile;
- (void)setUpWithInfoArray:(NSArray *)infoArray BetType:(NSString*)BetType;

@end
