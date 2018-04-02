//
//  OrderBetsListView.h
//  Lottery
//
//  Created by Yang on 15/6/24.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderProfile.h"

@interface OrderBetsListView : UIView{

    UIView * contentV;
    

}
@property (nonatomic , strong) OrderProfile * orderProfile;
@property (nonatomic , strong) NSString * lotteryType;
@property (nonatomic) float betsLisHeight;
@property (nonatomic , strong) NSArray * betsArray;

// jingcai


//-(void)initSubView;
-(void)betListSpread;
-(void)betListCowered;

- (void)fillContentView:(NSArray *)betArray;

@end
