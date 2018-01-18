//
//  LYJHeaderView.m
//  happyLottery
//
//  Created by LYJ on 2018/1/15.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "LYJHeaderView.h"

@implementation LYJHeaderView
{
    BOOL _created;/**< 是否创建过 */
    UILabel *_titleLabel;/**< 标题 */
    UIButton *_btn;/**< 收起按钮 */
     UIImageView *_imageView;/**< 图标 */
    BOOL _canFold;/**< 是否可展开 */
    
}

- (void)setFoldSectionHeaderViewWithTitle:(NSString *)title  type:(HerderStyle)type section:(NSInteger)section canFold:(BOOL)canFold {
    if (!_created) {
        [self creatUI];
    }
    _titleLabel.text = title;
    _section = section;
    _canFold = canFold;
    if (canFold) {
        _imageView.hidden = NO;
    } else {
        _imageView.hidden = YES;
    }
}



- (void)creatUI {
    _created = YES;
    
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, 40)];
   // _titleLabel.backgroundColor = [UIColor grayColor];
   _titleLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_titleLabel];
    
    //按钮
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(0, 0, KscreenWidth,43);
    [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_btn];
    
    //图片
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(KscreenWidth - 30, 15, 15, 8)];
    _imageView.image = [UIImage imageNamed:@"arrowdown.png"];
    [self.contentView addSubview:_imageView];
    
    //线
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 44, KscreenWidth-20, 1)];
    line.image = [UIImage imageNamed:@"dotted.png"];
    [self.contentView addSubview:line];
    self.contentView.backgroundColor=[UIColor whiteColor];
}

- (void)setFold:(BOOL)fold {
    _fold = fold;
    if (fold) {
        _imageView.image = [UIImage imageNamed:@"arrowdown.png"];
    } else {
        _imageView.image = [UIImage imageNamed:@"arrowup.png"];
    }
}

#pragma mark = 按钮点击事件
- (void)btnClick:(UIButton *)btn {
    if (_canFold) {
        if ([self.delegate respondsToSelector:@selector(foldHeaderInSection:)]) {
            [self.delegate foldHeaderInSection:_section];
        }
    }
}


@end
