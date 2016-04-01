//
//  UIView+XHBadgeView.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-28.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "UIView+XHBadgeView.h"

#import <objc/runtime.h>

@implementation XHCircleView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect)));
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.829 green:0.194 blue:0.257 alpha:1.000].CGColor);
    
    CGContextFillPath(context);
}

@end


static NSString const * XHBadgeViewKey = @"XHBadgeViewKey";
static NSString const * XHBadgeViewFrameKey = @"XHBadgeViewFrameKey";

static NSString const * XHCircleBadgeViewKey = @"XHCircleBadgeViewKey";

@implementation UIView (XHBadgeView)

- (CGRect)lcim_badgeViewFrame {
    return CGRectFromString(objc_getAssociatedObject(self, @selector(lcim_badgeViewFrame)));
}

- (void)setLcim_badgeViewFrame:(CGRect)lcim_badgeViewFrame {
    objc_setAssociatedObject(self, @selector(lcim_badgeViewFrame), NSStringFromCGRect(lcim_badgeViewFrame), OBJC_ASSOCIATION_ASSIGN);
}

- (LKBadgeView *)lcim_badgeView {
    LKBadgeView *badgeView = objc_getAssociatedObject(self, @selector(lcim_badgeView));
    if (badgeView)
        return badgeView;
    
    badgeView = [[LKBadgeView alloc] initWithFrame:self.lcim_badgeViewFrame];
    [self addSubview:badgeView];
    
    self.lcim_badgeView = badgeView;
    
    return badgeView;
}



- (void)setLcim_badgeView:(LKBadgeView *)lcim_badgeView {
    objc_setAssociatedObject(self, @selector(lcim_badgeView), lcim_badgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (XHCircleView *)lcim_setupCircleBadge {
    self.opaque = NO;
    self.clipsToBounds = NO;
    XHCircleView *circleView = objc_getAssociatedObject(self, &XHCircleBadgeViewKey);
    if (circleView)
        return circleView;
    
    if (!circleView) {
        circleView = [[XHCircleView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds), 0, 8, 8)];
        [self addSubview:circleView];
        objc_setAssociatedObject(self, &XHCircleBadgeViewKey, circleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return circleView;
}

@end
