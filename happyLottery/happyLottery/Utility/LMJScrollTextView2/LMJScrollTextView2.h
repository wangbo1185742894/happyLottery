//
//  LMJScrollTextView2.h
//  LMJScrollText
//
//  Created by MajorLi on 15/5/4.
//  Copyright (c) 2015年 iOS开发者公会. All rights reserved.
//
//  iOS开发者公会-技术1群 QQ群号：87440292
//  iOS开发者公会-技术2群 QQ群号：232702419
//  iOS开发者公会-议事区  QQ群号：413102158
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LMJScrollTextTypeDefealt,
    LMJScrollTextTypeSubTitle,
} LMJScrollTextType;

@interface LMJScrollTextView2 : UIView

@property (nonatomic,copy)   NSArray * textDataArr;
@property (nonatomic,copy)   NSArray * textDataSubTitle;
@property (nonatomic,copy)   UIFont  * textFont;
@property (nonatomic,copy)   UIColor * textColor;

@property (nonatomic,copy)   UIFont  * subTitleFont;
@property (nonatomic,copy)   UIColor * subTitleColor;

- (id)initWithType:(LMJScrollTextType)type;

- (void)startScrollBottomToTop;
- (void)startScrollTopToBottom;
- (void)startScrollLeftToRight;
- (void)startScrollRightToLeft;

-(void)btnScrollRightToLeft;

- (void)stop;

@end
