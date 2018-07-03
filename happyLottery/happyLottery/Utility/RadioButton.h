//
//  EIRadioButton.m
//  EInsure
//
//  Created by zwl on 15-7-22.
//  Copyright (c) 2015年
//

#import <UIKit/UIKit.h>

@protocol RadioButtonDelegate;

@interface RadioButton : UIButton {
    NSString                        *_groupId;
    BOOL                            _checked;
    id<RadioButtonDelegate>        delegate;
}

@property(nonatomic, assign)id<RadioButtonDelegate>   delegate;
@property(nonatomic, copy, readonly)NSString           *groupId;
@property(nonatomic, assign)BOOL checked;

- (id)initWithDelegate:(id)delegate groupId:(NSString*)groupId;

@end

@protocol RadioButtonDelegate <NSObject>

@optional

- (void)didSelectedRadioButton:(RadioButton *)radio groupId:(NSString *)groupId;

@end
