//
//  ExNumContainerView.h
//  Lottery
//
//  Created by Yang on 7/1/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXHeaderView.h"
#import "Lottery.h"

@protocol ExNumContainerViewDelegate <NSObject>

- (void)nowPingceResultWithAppearTime:(NSDictionary *)appearTimeDic Lianxu:(NSDictionary *)maxLianxu yilou:(NSDictionary *)maxYilou appearPropertion:(NSDictionary *)appearPropertion;
- (void)cellChoosed:(int)sourIndex;
@end

@interface ExNumContainerView : UIView{

    float Frame_height;
    float Frame_width;
    
    CGRect highLightfram;
}

@property (nonatomic,assign)NSInteger index;
@property (nonatomic, strong) NSArray * source;
@property (nonatomic, strong) NSMutableArray * sourceToDraw;
@property (nonatomic, weak) id<ExNumContainerViewDelegate>delegate;
@property (nonatomic , strong) Lottery * lottery;
@property (nonatomic,strong) NSArray *numArr;
@property (nonatomic) int baseNumMaxValue;


//大乐透
@property (nonatomic) DltSectionType dltSectionType;

//11 选5
@property (nonatomic) X115PlayType  x115PlayType;
@property (nonatomic) X115SectionType  x115SectionType;


-(CGSize)remakerViewFram:(NSArray *)source;


@end
