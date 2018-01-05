//
//  ZLAlertView.h
//  UIAlertView&UIAlertController
//
//  Created by long on 15/10/29.
//  Copyright © 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ClickAction)();

@interface ZLAlertView : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

/**
 * @param title    标题
 * @param message  提示内容
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)setTitle:(NSString *)title message:(NSString *)message;

/**
 * @brief 添加按钮及事件，多个按钮便多次调用，按钮按照添加顺序显示
 */
- (void)addBtnTitle:(NSString *)title action:(ClickAction)action;

/**
 * @brief 显示提示框
 */
- (void)showAlertWithSender:(UIViewController *)sender;

NS_ASSUME_NONNULL_END

@end
