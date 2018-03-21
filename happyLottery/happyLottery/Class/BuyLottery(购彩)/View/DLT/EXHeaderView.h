//
//  EXHeaderView.h
//  Lottery
//
//  Created by Yang on 7/1/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lottery.h"

typedef enum {
    DltSectionTypeNotSet,
    DltSectionTypeFront,
    DltSectionTypeAfter,
}DltSectionType;

typedef enum {
    x115PlayTypeDefualt,
    x115PlayTypeQianYi,
    x115PlayTypeQianEr,
    x115PlayTypeQianSan,
    x115PlayTypeQianErZu,
    x115PlayTypeQianSanZu,
}X115PlayType;

typedef enum {
    X115SectionTypeWan,
    X115SectionTypeQian,
    X115SectionTypeBai,
}X115SectionType;

@interface EXHeaderView : UIView{

    int baseNumMaxValue;
    BOOL isPL;
}


-(CGSize)remakerViewFram:(int)baseNumMaxValue;
-(CGSize)remakerViewFram:(int)baseNumMaxValue_ isPL:(BOOL)isPL_;
@end
