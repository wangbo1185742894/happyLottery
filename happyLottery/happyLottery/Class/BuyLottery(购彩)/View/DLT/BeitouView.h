//
//  BeitouView.h
//  Lottery
//
//  Created by Yang on 6/30/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lottery.h"
#import "LotteryTransaction.h"

@protocol BeitouViewDelegate <NSObject>
@required
- (void) betZhuijia:(BOOL)isZhuijia;
- (void) betBeiTou;
- (void) betzhuihao;
@end

@interface BeitouView : UIView

@property (nonatomic , weak) id<BeitouViewDelegate>delegate;
// dlt  x115
@property (nonatomic, strong) LotteryTransaction *transaction;

-(void)setUp:(Lottery *)lottery;

@end
