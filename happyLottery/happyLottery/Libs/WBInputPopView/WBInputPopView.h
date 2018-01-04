//
//  WBInputPopView.h
//  ceshi
//
//  Created by 王博 on 16/1/15.
//  Copyright © 2016年 aoli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PasswordBlock)(NSString*pass);

@protocol WBInputPopViewDelegate <NSObject>

-(void)findPayPwd;

@end
@interface WBInputPopView : UIView


@property (weak, nonatomic) IBOutlet UILabel *labTitle;//标题
@property (strong, nonatomic) IBOutlet UITextField *txtInput;//输入框

@property(copy,nonatomic) PasswordBlock passBlock;

@property(nonatomic,assign)id <WBInputPopViewDelegate>delegate;
-(void)createBlock:(PasswordBlock)pass;

- (void)show;
@end
