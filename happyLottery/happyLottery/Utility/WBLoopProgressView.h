//
//  LoopProgressView.h
//  头像蒙板
//
//  Created by CUG on 16/1/29.
//  Copyright © 2016年 CUG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBLoopProgressView : UIView

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) UIColor *color1; // 百分比

@property (nonatomic, strong) UIColor *color2; // 下面文字
/*
 带动画环形进度条
 */
@end

