//
//  LotteryXHSection.h
//  Lottery
//
//  Created by AMP on 5/21/15.
//  Copyright (c) 2015 AMP. All rights reserved.
// data cell for each number section of lottery
//

#import "LotteryBaseView.h"
#import "XHSectionTitleView.h"
#import "LotteryNumber.h"

@interface LotteryXHSection : NSObject

@property (nonatomic, strong) NSString *sectionID;
@property (nonatomic, strong) NSNumber *numberCount;
@property (nonatomic, strong) NSNumber *needLabel;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *normalColor;
@property (nonatomic, strong) NSString *selectedColor;
@property (nonatomic, strong) NSString *normalBackground;
@property (nonatomic, strong) NSString *selectedBackground;
@property (nonatomic, strong) NSNumber *startIndex;
@property (nonatomic, strong) NSNumber *needDanHao;
@property (nonatomic, strong) NSNumber *danHaoCount;
@property (nonatomic, strong) NSNumber *forceTwoNumber;
@property (nonatomic, strong) NSNumber *minNumCount;
@property (nonatomic, strong) NSNumber *maxNumCount;
@property (nonatomic, strong) NSString *ruleDesc;


@property (nonatomic, strong) NSMutableArray *numbersDanHao;
@property (nonatomic, strong) NSMutableArray *numbersSelected;
@property (nonatomic, strong) XHSectionTitleView *titleView;

@property (nonatomic, strong) LotteryNumber *numberObjTemp;



- (BOOL) couldHaveMoreNumber;
- (BOOL) couldHaveMoreDanHao;
- (void) updateSelectedNumberDesc;
- (NSArray *) generateRandomNumber: (int) numberCount;
- (BOOL)isNumHasEquel:(NSArray *)numArray;
- (NSArray *) generateRandomNumber: (int) numberCount withOutRepeatArray:(NSArray *)numberArray;


@end
