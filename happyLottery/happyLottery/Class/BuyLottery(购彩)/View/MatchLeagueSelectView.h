//
//  MatchLeagueSelectView.h
//  happyLottery
//
//  Created by 王博 on 2017/12/19.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCZQLeaModel.h"

@protocol MatchLeagueSelectViewDelegate

-(void)selectedLeagueItem:(NSArray *)leaTitleArray;

@end

@interface MatchLeagueSelectView : UIView
@property(weak,nonatomic)id<MatchLeagueSelectViewDelegate> delegate;
-(void)loadMatchLeagueInfo:(NSArray <JCZQLeaModel *> *) leaArray;

@end
