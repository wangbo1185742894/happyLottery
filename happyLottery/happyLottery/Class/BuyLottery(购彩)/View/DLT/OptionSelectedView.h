//
//  OptionSelectedView.h
//  OptionSelectedView
//
//  Created by LC on 16/2/17.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionSelectedViewDelegate;


@interface OptionSelectedView : UIView
@property (nonatomic,assign)BOOL isP3P5;
@property(nonatomic , weak)NSObject<OptionSelectedViewDelegate>* delegate;
- (instancetype)initWithFrame:(CGRect)frame andTitleArr:(NSArray<NSString *> *)titleArr;
@end

@protocol OptionSelectedViewDelegate <NSObject>

- (void)optionDidSelacted:(OptionSelectedView *)optionSelectedView andIndex:(NSInteger)index;



@end
