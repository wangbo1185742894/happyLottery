//
//  AlertPushtView.m
//  AlertPushtView
//
//  Created by zwl on 28/07/2015.
//  Copyright (c) 2015 zwl.
//
//  Lincesed under The MIT License (MIT)
//  http://opensource.org/licenses/MIT
//

#import "AlertPushtView.h"
#import <QuartzCore/QuartzCore.h>

//const static CGFloat kAlertPushtViewDefaultButtonHeight       = 50;
//const static CGFloat kAlertPushtViewDefaultButtonSpacerHeight = 1;
const static CGFloat kAlertPushtViewCornerRadius              = 2;
const static CGFloat kCustomIOS7MotionEffectExtent                 = 10.0;

@implementation AlertPushtView

CGFloat buttonHeight = 0;
CGFloat buttonSpacerHeight = 1;

@synthesize parentView, containerView, dialogView, buttonView, onButtonTouchUpInside;
//@synthesize delegate;
@synthesize useMotionEffects;

- (id)initWithParentView: (UIView *)_parentView
{
    self = [self init];
    if (_parentView) {
        self.frame = _parentView.frame;
        self.parentView = _parentView;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
//        delegate = self;
        useMotionEffects = false;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

// Create the dialog view, and animate opening the dialog
- (void)show
{
    dialogView = [self createContainerView];
    
    dialogView.layer.shouldRasterize = YES;
    dialogView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
#if (defined(__IPHONE_7_0))
    if (useMotionEffects) {
        [self applyMotionEffects];
    }
#endif
    
    dialogView.layer.opacity = 0.5f;
    dialogView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [self addSubview:dialogView];
    
    // Can be attached to a view or to the top most window
    // Attached to a view:
    if (parentView != NULL) {
        [parentView addSubview:self];
        
        // Attached to the top most window (make sure we are using the right orientation):
    } else {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (interfaceOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
                self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
                break;
                
            case UIInterfaceOrientationLandscapeRight:
                self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
                break;
                
            case UIInterfaceOrientationPortraitUpsideDown:
                self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
                break;
                
            default:
                break;
        }
        
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         dialogView.layer.opacity = 1.0f;
                         dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:NULL
     ];
}

// Button has been touched
- (IBAction)DetailInfoBtnTouchUpInside:(id)sender
{
   
}

- (void)close
{
    
    CATransform3D currentTransform = dialogView.layer.transform;
    
    CGFloat startRotation = [[dialogView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
    
    dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    dialogView.layer.opacity = 1.0f;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         dialogView.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}

- (void)setSubView: (UIView *)subView
{
    containerView = subView;
}

// Creates the container view here: create the dialog, then add the custom content and buttons
-(CGRect) initContainerViewFrame
{
    CGRect rect = CGRectMake(0, 0, 320, 400);
    return rect;
}
- (UIView *)createContainerView
{
    CGRect rect = [self initContainerViewFrame];
    if (containerView == NULL) {
        containerView = [[UIView alloc] initWithFrame:rect];
    }
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    
    // For the black background
    [self setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    // This is the dialog's container; we attach the custom content and the buttons to this one
    UIView *dialogContainer = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height)];
    
    // First, we style the dialog to match the iOS7 UIAlertView >>>
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = dialogContainer.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0f] CGColor],
                       nil];
    
    CGFloat cornerRadius = kAlertPushtViewCornerRadius;
    gradient.cornerRadius = cornerRadius;
    dialogContainer.layer.cornerRadius = cornerRadius;
    dialogContainer.layer.borderColor = [[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f] CGColor];
    dialogContainer.layer.borderWidth = 0;
    dialogContainer.layer.shadowRadius = cornerRadius + 5;
    dialogContainer.layer.shadowOpacity = 0.1f;
    dialogContainer.layer.shadowOffset = CGSizeMake(0 - (cornerRadius+5)/2, 0 - (cornerRadius+5)/2);
    dialogContainer.layer.shadowColor = [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0f] CGColor];
    dialogContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:dialogContainer.bounds cornerRadius:dialogContainer.layer.cornerRadius].CGPath;
    
    [dialogContainer addSubview:containerView];
    // Add the buttons too
    [self addButtonsToView:dialogContainer];
    
    return dialogContainer;
}

// Helper function: add buttons to container
- (void)addButtonsToView: (UIView *)container
{
//    UIImageView *ImageViewTitle =
//    [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, container.bounds.size.width, 40)];
//    ImageViewTitle.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btl-01"]];
//    UIImageView *ImageViewTable = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, container.bounds.size.width,54)];
//    ImageViewTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tb"]];
//    [container addSubview:ImageViewTitle];
//    [container addSubview:ImageViewTable];
}
// Helper function: count and return the dialog's size
- (CGSize)countDialogSize
{
    CGFloat dialogWidth = containerView.frame.size.width;
    CGFloat dialogHeight = containerView.frame.size.height + buttonHeight + buttonSpacerHeight;
    
    return CGSizeMake(dialogWidth, dialogHeight);
}

// Helper function: count and return the screen's size
- (CGSize)countScreenSize
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGFloat tmp = screenWidth;
        screenWidth = screenHeight;
        screenHeight = tmp;
    }
    
    return CGSizeMake(screenWidth, screenHeight);
}

#if (defined(__IPHONE_7_0))
// Add motion effects
- (void)applyMotionEffects {
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return;
    }
    
    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-kCustomIOS7MotionEffectExtent);
    horizontalEffect.maximumRelativeValue = @( kCustomIOS7MotionEffectExtent);
    
    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-kCustomIOS7MotionEffectExtent);
    verticalEffect.maximumRelativeValue = @( kCustomIOS7MotionEffectExtent);
    
    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];
    
    [dialogView addMotionEffect:motionEffectGroup];
}
#endif

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

// Handle device orientation changes
- (void)deviceOrientationDidChange: (NSNotification *)notification
{
    // If dialog is attached to the parent view, it probably wants to handle the orientation change itself
    if (parentView != NULL) {
        return;
    }
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat startRotation = [[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CGAffineTransform rotation;
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 270.0 / 180.0);
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 90.0 / 180.0);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 180.0 / 180.0);
            break;
            
        default:
            rotation = CGAffineTransformMakeRotation(-startRotation + 0.0);
            break;
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         dialogView.transform = rotation;
                     }
                     completion:^(BOOL finished){
                         // fix errors caused by being rotated one too many times
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                             UIInterfaceOrientation endInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
                             if (interfaceOrientation != endInterfaceOrientation) {
                                 // TODO user moved phone again before than animation ended: rotation animation can introduce errors here
                             }
                         });
                     }
     ];
}
- (IBAction)CloseBtnTouchUpInside:(UIButton *)sender
{
    
    
}
@end
