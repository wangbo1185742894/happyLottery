//
//  EIRadioButton.m
//  EInsure
//
//  Created by zwl on 15-7-22.
//  Copyright (c) 2015年
//

#import "RadioButton.h"

#import "AppDelegate.h"

#define Q_RADIO_ICON_WH                     (16.0)
#define Q_ICON_TITLE_MARGIN                 (5.0)


static NSMutableDictionary *_groupRadioDic = nil;

@implementation RadioButton

@synthesize delegate = _delegate;
@synthesize checked  = _checked;

- (id)initWithDelegate:(id)mydelegate groupId:(NSString*)groupId {
    self = [super init];
    if (self) {
        _delegate = mydelegate;
        _groupId = [groupId copy];
        [self addToGroup];
        
        self.exclusiveTouch = NO;
        [self setImage:[UIImage imageNamed:@"radio_unselect.png"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"radio_selected.png"] forState:UIControlStateSelected];
        [self addTarget:self action:@selector(radioBtnChecked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)addToGroup {
    if(!_groupRadioDic){
        _groupRadioDic = [NSMutableDictionary dictionary];
    }
    
    NSMutableArray *_gRadios = [_groupRadioDic objectForKey:_groupId];
    if (!_gRadios) {
        _gRadios = [NSMutableArray array];
    }
    [_gRadios addObject:self];
    if(_gRadios.count)
    {
        [_groupRadioDic setObject:_gRadios forKey:_groupId];
    }
}

- (void)removeFromGroup {
    if (_groupRadioDic) {
        NSMutableArray *_gRadios = [_groupRadioDic objectForKey:_groupId];
        if (_gRadios) {
            [_gRadios removeObject:self];
            if (_gRadios.count == 0) {
                [_groupRadioDic removeObjectForKey:_groupId];
            }
        }
    }
}

- (void)uncheckOtherRadios {
    NSMutableArray *_gRadios = [_groupRadioDic objectForKey:_groupId];
    if (_gRadios.count > 0) {
        for (RadioButton *_radio in _gRadios) {
            if (_radio.checked && ![_radio isEqual:self]) {
                _radio.checked = NO;
            }
        }
    }
}

- (void)setChecked:(BOOL)checked{
    if (_checked == checked) {
        return;
    }
    
    _checked = checked;
    self.selected = checked;
    
    if (self.selected) {
        [self uncheckOtherRadios];
    }
    
    if (self.selected && _delegate && [_delegate respondsToSelector:@selector(didSelectedRadioButton:groupId:)]) {
        [_delegate didSelectedRadioButton:self groupId:_groupId];
    }
}

- (void)radioBtnChecked:(RadioButton*)RBtn{
    if (_checked) {
        return;
    }
    self.selected = !self.selected;
    _checked = self.selected;
    
    if (self.selected) {
        [self uncheckOtherRadios];
    }
    
    if(self.selected && _delegate )
    {
        [self didSelectedRadioBtn:self groupId:_groupId];
    }
}
//zwl
- (void)didSelectedRadioBtn:(RadioButton *)radio groupId:(NSString *)groupId
{
//    switch (radio.tag){
//        case 1:
//             break;
//        case 2:
//             break;
//        case 3:
//             break;
//        default:
//             break;
//    }
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, (CGRectGetHeight(contentRect) - Q_RADIO_ICON_WH)/2.0, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(Q_RADIO_ICON_WH + Q_ICON_TITLE_MARGIN, 0,
                      CGRectGetWidth(contentRect) - Q_RADIO_ICON_WH - Q_ICON_TITLE_MARGIN,
                      CGRectGetHeight(contentRect));
}

@end
