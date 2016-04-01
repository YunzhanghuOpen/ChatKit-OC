//
//  LCIMChatMoreCell.m
//  LCIMChatBarExample
//
//  Created by ElonChan ( https://github.com/leancloud/LeanCloudIMKit-iOS ) on 15/8/18.
//  Copyright (c) 2015年 https://LeanCloud.cn . All rights reserved.
//

#import "LCIMChatMoreItem.h"

#import "Masonry.h"

@interface LCIMChatMoreItem   ()

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation LCIMChatMoreItem

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    [self setup];
}

- (void)updateConstraints{
    [super updateConstraints];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(4);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button.mas_bottom).with.offset(3);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

#pragma mark - Public Methods

- (void)fillViewWithTitle:(NSString *)title imageName:(NSString *)imageName{
    self.titleLabel.text = title;
    [self.button setBackgroundImage:[self imageInBundlePathForImageName:imageName] forState:UIControlStateNormal];
    [self updateConstraintsIfNeeded];
}

- (UIImage *)imageInBundlePathForImageName:(NSString *)imageName {
    NSString *imageNameWithBundlePath = [NSString stringWithFormat:@"ChatKeyboard.bundle/%@", imageName];
    UIImage *image = [UIImage imageNamed:imageNameWithBundlePath];
    return image;
}

#pragma mark - Private Methods

- (void)setup{
    
    [self addSubview:self.button];
    [self addSubview:self.titleLabel];
    
    [self updateConstraintsIfNeeded];
    
}

- (void)buttonAction{
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.button setHighlighted:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self.button setHighlighted:NO];
}

#pragma mark - Getters
- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _titleLabel.textColor = [UIColor darkTextColor];
    }
    return _titleLabel;
}
@end
