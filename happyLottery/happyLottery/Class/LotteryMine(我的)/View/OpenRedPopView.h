//
//  OpenRedPopView.h
//  Lottery
//
//  Created by 王博 on 2017/7/13.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OpenRedPopViewDelegate <NSObject>

-(void)openPopToBuy;
-(void)openPopToLook;

@end


@interface OpenRedPopView : UIView
@property (weak, nonatomic) IBOutlet UILabel *labJiangjin;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property(weak,nonatomic)id <OpenRedPopViewDelegate>delegate;
@end
