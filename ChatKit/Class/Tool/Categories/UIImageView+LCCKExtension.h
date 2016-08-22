//
//  UIImageView+LCCKExtension.h
//  LeanCloudChatKit-iOS
//
//  v0.6.1 Created by ElonChan (微信向我报BUG:chenyilong1010) on 16/5/16.
//  Copyright © 2016年 LeanCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LCCKExtension)

- (instancetype)initWithCornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

- (void)lcck_cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

- (instancetype)initWithRoundingRectImageView;

- (void)lcck_cornerRadiusRoundingRect;

- (void)lcck_attachBorderWidth:(CGFloat)width color:(UIColor *)color;

@end
