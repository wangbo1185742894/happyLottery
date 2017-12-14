//
//  UIImage+RandomSize.m
//  Lottery
//
//  Created by LC on 16/2/28.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "UIImage+RandomSize.h"

@implementation UIImage (RandomSize)
+ (UIImage*)reSizeImageName:(NSString *)imageName andMinWidth:(CGFloat)minWidth{
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [self reSizeImage:image andMinWidth:minWidth];
}

+ (UIImage*)reSizeImage:(UIImage *)image andMinWidth:(CGFloat)minWidth{
    CGSize size = image.size;
    CGSize newSize;
    //    if (size.height>size.width) {
    newSize.width = minWidth;
    newSize.height =  size.height * (newSize.width/size.width);
    //    }else{
    //        newSize.height = minWidth;
    //        newSize.width = size.width * (newSize.height/size.height);
    //    }
    UIGraphicsBeginImageContextWithOptions(newSize, NO,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, newSize.width, newSize.height);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
