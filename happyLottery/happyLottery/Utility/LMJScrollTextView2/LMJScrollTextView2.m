//
//  LMJScrollTextView2.m
//  LMJScrollText
//
//  Created by MajorLi on 15/5/4.
//  Copyright (c) 2015年 iOS开发者公会. All rights reserved.
//
//  iOS开发者公会-技术1群 QQ群号：87440292
//  iOS开发者公会-技术2群 QQ群号：232702419
//  iOS开发者公会-议事区  QQ群号：413102158
//


#import "LMJScrollTextView2.h"

#define ScrollTime 0.5

@implementation LMJScrollTextView2
{
    NSTimer * _timer;
    
    UILabel * _scrollLabel;
    UILabel * _scrolcontent;
    
    NSInteger _index;
}

- (id)initWithType:(LMJScrollTextType)type{
    self = [super init];
    if (self) {
        
        if (type == LMJScrollTextTypeDefealt) {
            self.clipsToBounds = YES;
            _index = 0;
            _textDataArr = @[@""];
            _textFont    = [UIFont systemFontOfSize:12];
            _textColor   = RGBCOLOR(72,72, 72);
            _scrollLabel = nil;
            _scrollLabel.numberOfLines = 0;
            self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20);
        }
        
        if (type == LMJScrollTextTypeSubTitle) {
            self.clipsToBounds = YES;
            _index = 0;
            _textDataArr = @[@""];
            _textDataSubTitle = @[@""];
            _textFont    = [UIFont systemFontOfSize:13];
            _textColor   = [UIColor blackColor];
            _scrollLabel = nil;
            _scrolcontent = nil;
            self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20);
        }
       
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        self.clipsToBounds = YES;
        _index = 0;
        _textDataArr = @[@""];
        _textDataSubTitle = @[@""];
        _textFont    = [UIFont systemFontOfSize:14];
        _textColor   = RGBCOLOR(100, 100, 100);
        _scrollLabel = nil;
        _scrolcontent = nil;
    }
    return self;
}

- (void)setTextFont:(UIFont *)textFont{
    _textFont = textFont;
    _scrollLabel.font = textFont;
}
- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    _scrollLabel.textColor = textColor;
}

- (void)setSubTitleFont:(UIFont *)textFont{
    _subTitleFont = textFont;
    _scrolcontent.font = textFont;
}
- (void)setSubTitleColor:(UIColor *)textColor{
    _subTitleColor = textColor;
    _scrolcontent.textColor = textColor;
}


- (void)createScrollLabel{
    _scrollLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width - 15, 40)];
    _scrollLabel.text          = @"";
    _scrollLabel.numberOfLines = 1;
    _scrollLabel.textAlignment = NSTextAlignmentLeft;
    _scrollLabel.textColor     = _textColor;
    _scrollLabel.font          = _textFont;
    [self addSubview:_scrollLabel];
}

- (void)createScrolContent{
    _scrolcontent = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.frame.size.width , self.mj_h - 30)];
    _scrolcontent.text          = @"";
    _scrolcontent.numberOfLines = 0;
    _scrolcontent.textAlignment = NSTextAlignmentLeft;
    _scrolcontent.textColor     = _subTitleColor;
    _scrolcontent.font          = _subTitleFont;
    [self addSubview:_scrolcontent];
}
- (void)startScrollBottomToTop{
    
    if (_scrollLabel == nil) {
        [self createScrollLabel];
    }
    
    _index = 0;
    _timer = [NSTimer timerWithTimeInterval:ScrollTime*6 target:self selector:@selector(scrollBottomToTop) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer fire];
}

- (void)startScrollTopToBottom{
    
    if (_scrollLabel == nil) {
        [self createScrollLabel];
    }
    
    _index = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:ScrollTime*6 target:self selector:@selector(scrollTopToBottom) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)startScrollLeftToRight{
    
    if (_scrollLabel == nil) {
        [self createScrollLabel];
    }
    
    _index = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:ScrollTime*6 target:self selector:@selector(scrollLeftToRight) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)startScrollRightToLeft{
    
    if (_scrollLabel == nil) {
        [self createScrollLabel];
    }
    
    _index = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:ScrollTime*6 target:self selector:@selector(scrollRightToLeft) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)stop{
    [_timer invalidate];
}


-(void)btnScrollRightToLeft{

    if (_scrollLabel == nil) {
        [self createScrollLabel];
    }
    if (_scrolcontent == nil) {
        [self createScrolContent];
    }
    
   
    [self scrollRightToLeft];
}


- (void)scrollBottomToTop{
    
    _scrollLabel.frame = CGRectMake(0, self.frame.size.height, _scrollLabel.frame.size.width, _scrollLabel.frame.size.height);
    _scrollLabel.text  = _textDataArr[_index];
    
    
    
    [UIView animateWithDuration:ScrollTime animations:^{
        
        _scrollLabel.frame = CGRectMake(0, 0, _scrollLabel.frame.size.width, _scrollLabel.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:ScrollTime delay:4*ScrollTime options:0 animations:^{
            
            _scrollLabel.frame = CGRectMake(0, -self.frame.size.height, _scrollLabel.frame.size.width, _scrollLabel.frame.size.height);
            
        } completion:^(BOOL finished) {
            _index ++;
            if (_index == _textDataArr.count) {
                _index = 0;
            }
        }];
    }];
}

- (void)scrollTopToBottom{
    
    _scrollLabel.frame = CGRectMake(0, -self.frame.size.height, _scrollLabel.frame.size.width, _scrollLabel.frame.size.height);
    if (_textDataArr.count !=0) {
        _scrollLabel.text  = _textDataArr[_index%_textDataArr.count];
    }
    
    
    
    [UIView animateWithDuration:ScrollTime animations:^{
        
        _scrollLabel.frame = CGRectMake(0, 0, _scrollLabel.frame.size.width, _scrollLabel.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:ScrollTime delay:4*ScrollTime options:0 animations:^{
            
            _scrollLabel.frame = CGRectMake(0, self.frame.size.height, _scrollLabel.frame.size.width, _scrollLabel.frame.size.height);
            
        } completion:^(BOOL finished) {
            _index ++;
            if (_index == _textDataArr.count) {
                _index = 0;
            }
        }];
    }];
    
}

- (void)scrollLeftToRight{
    
    _scrollLabel.frame = CGRectMake(-self.frame.size.width, 0, _scrollLabel.frame.size.width, _scrollLabel.frame.size.height);
    _scrollLabel.text  = _textDataArr[_index];
    
    
    [UIView animateWithDuration:ScrollTime animations:^{
        
        _scrollLabel.frame = CGRectMake(0, 0, _scrollLabel.frame.size.width, _scrollLabel.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:ScrollTime delay:4*ScrollTime options:0 animations:^{
            
            _scrollLabel.frame = CGRectMake(self.frame.size.width, 0, _scrollLabel.frame.size.width, _scrollLabel.frame.size.height);
            
        } completion:^(BOOL finished) {
            _index ++;
            if (_index == _textDataArr.count) {
                _index = 0;
            }
        }];
    }];
    
}

- (void)scrollRightToLeft{
    
    _scrollLabel.frame = CGRectMake(self.frame.size.width,_scrollLabel.mj_y , _scrollLabel.frame.size.width, _scrollLabel.frame.size.height);
    _scrolcontent.frame = CGRectMake(self.frame.size.width, _scrolcontent.mj_y, _scrolcontent.frame.size.width, _scrolcontent.frame.size.height);
    
    _scrollLabel.text  = _textDataArr[_index];
    _scrolcontent.text = _textDataSubTitle[_index];
    
    [UIView animateWithDuration:ScrollTime animations:^{
        
        _scrollLabel.frame = CGRectMake(0, _scrollLabel.mj_y, _scrollLabel.frame.size.width, _scrollLabel.frame.size.height);
         _scrolcontent.frame = CGRectMake(0, _scrolcontent.mj_y, _scrolcontent.frame.size.width, _scrolcontent.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        _index ++;
        if (_index == _textDataArr.count) {
            _index = 0;
        }
    }];
    
}

@end
