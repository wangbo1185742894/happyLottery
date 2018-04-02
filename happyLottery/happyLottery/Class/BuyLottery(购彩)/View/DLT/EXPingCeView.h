//
//  EXPingCeView.h
//  Test
//
//  Created by Yang on 7/1/15.
//  Copyright (c) 2015 Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXPingCeView : UIView{

    int num_w_h;
    int baseNumMaxValue;
}

//@property (nonatomic , strong)

@property (nonatomic , strong) NSDictionary * appearTimeDic;
@property (nonatomic , strong) NSDictionary * maxLianchuDic;
@property (nonatomic , strong) NSDictionary * maxYilouDic;
@property (nonatomic , strong) NSDictionary * appearPositinDic;



-(CGSize)remakeFram:(int)baseNumMaxValue_;
-(CGSize)remakeFramPl:(int)baseNumMaxValue_;

@end
