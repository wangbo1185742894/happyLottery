//
//  Created by 王博 on 01/1/3.
//  Copyright (c) 2001年 王博. All rights reserved.
//

#import "WBButton.h"

@implementation WBButton

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        self.imageView.contentMode =UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{

    float imageX = self.mj_w - 45;
    float imageY = 7;
    float imageW = 35;
    float imageH = self.mj_h;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    float titleX = 0;
    float titleY = 0;
    float titleW = self.mj_w - 35;
    float titleH = self.mj_h;
    
    return CGRectMake(titleX, titleY,titleW, titleH);
}

@end
