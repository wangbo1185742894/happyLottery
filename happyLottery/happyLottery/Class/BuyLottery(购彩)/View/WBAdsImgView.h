//
//  WBAdsImgView.h
//  happyLottery
//
//  Created by 王博 on 2017/12/6.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ADSModel.h"
@protocol WBAdsImgViewDelegate

-(void)adsImgViewClick:(ADSModel *)itemIndex navigation:(UINavigationController *)navgC;

@end


@interface WBAdsImgView : UIView


@property(nonatomic,weak)id<WBAdsImgViewDelegate>delegate;
-(void)setImageUrlArray:(NSArray<ADSModel *> *)imgUrls;

- (void)setImageUrlArray:(NSArray<ADSModel *> *)imgUrls placeImageName:(NSString *)imageName;

- (void)stopTimer;

- (void)openTimer;

@end
