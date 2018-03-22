//
//  EXQiHaoView.h
//  Test
//
//  Created by Yang on 7/1/15.
//  Copyright (c) 2015 Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXQiHaoView : UIView{
    float Frame_height;
    float qihao_width;
    
    CGRect highLightFram;
}

@property (nonatomic, strong) NSArray * source;
-(CGSize)remakerViewFram:(NSArray *)source;
- (void)cellChoose:(int)index;
@end