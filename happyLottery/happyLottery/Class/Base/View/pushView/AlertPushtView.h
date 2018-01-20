//
//  AlertPushtView.h
// AlertPushtView
//
//  Created by Richard on 28/07/2013.
//  Copyright (c) 2015 zwl.
//
//  Lincesed under The MIT License (MIT)
//  http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

@protocol AlertPushtViewDelegate<NSObject>

- (void)DetailInfoBtnTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

//@interface AlertPushtView : UIView<AlertPushtViewDelegate>
@interface AlertPushtView : UIView
{
    
}
//@property (nonatomic , retain) NSString * resourcepushview;
@property (nonatomic , retain) NSString * winbonus;
@property (nonatomic , retain) NSString * winorderNumber;
@property (nonatomic, retain) NSString * winSchemeNumber;
@property (nonatomic, retain) NSString * cardCode;
@property (nonatomic, retain) NSString* gamename;
@property (nonatomic, retain) NSString* Strawardperiod;
@property (nonatomic, retain) NSString* Strballnums;
//@property (nonatomic, retain) NSString* StrUserAwardResult;
@property (nonatomic, retain) NSArray* UserAwardResultarry;
@property (nonatomic, retain) NSArray* Jczqarray;
@property (nonatomic, strong) NSArray        *order;

@property (nonatomic, retain) UIView *parentView;    // The parent view this 'dialog' is attached to
@property (nonatomic, retain) UIView *dialogView;    // Dialog's container view
@property (nonatomic, retain) UIView *containerView; // Container within the dialog (place your ui elements here)
@property (nonatomic, retain) UIView *buttonView;    // Buttons on the bottom of the dialog

//@property (nonatomic, assign) id<AlertPushtViewDelegate> delegate;

@property (nonatomic, assign) BOOL useMotionEffects;

@property (copy) void (^onButtonTouchUpInside)(AlertPushtView *alertView, int buttonIndex) ;

- (id)init;

/*!
 DEPRECATED: Use the [AlertPushtView init] method without passing a parent view.
 */
- (id)initWithParentView: (UIView *)_parentView __attribute__ ((deprecated));

- (void)show;
- (void)close;

- (IBAction)DetailInfoBtnTouchUpInside:(id)sender;

- (void)deviceOrientationDidChange: (NSNotification *)notification;
- (void)dealloc;

@end
