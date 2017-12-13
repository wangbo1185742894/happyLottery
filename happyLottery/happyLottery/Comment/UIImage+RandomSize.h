//
//  UIImage+RandomSize.h
//  Lottery
//
//  Created by LC on 16/2/28.
//  Copyright © 2016年 AMP. All rights reserved.
//
//用于图片自由缩放大小，按宽度成比例。
#import <UIKit/UIKit.h>

@interface UIImage (RandomSize)
+ (UIImage*)reSizeImageName:(NSString *)imageName andMinWidth:(CGFloat)minWidth;
+ (UIImage*)reSizeImage:(UIImage *)image andMinWidth:(CGFloat)minWidth;

@end
