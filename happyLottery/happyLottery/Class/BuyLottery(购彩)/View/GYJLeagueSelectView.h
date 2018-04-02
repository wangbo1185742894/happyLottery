//
//  MatchLeagueSelectView.h
//  happyLottery
//
//  Created by 王博 on 2017/12/19.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GYJLeagueSelectViewDelegate

-(void)selectedLeagueItem:(NSArray *)leaTitleArray;

@end

@interface GYJLeagueSelectView : UIView
@property(weak,nonatomic)id<GYJLeagueSelectViewDelegate> delegate;
-(void)refreshItemState;
@end
