//
//  LCCKVCardMessage.m
//  ChatKit-OC
//
//  v0.5.3 Created by 陈宜龙 on 16/8/10.
//  Copyright © 2016年 ElonChan. All rights reserved.
//

#import "LCCKVCardMessage.h"

@implementation LCCKVCardMessage

#pragma mark -
#pragma mark - initialize Method

/*!
 * 有几个必须添加的字段：
 *  - degrade 用来定义如何展示老版本未支持的自定义消息类型
 *  - typeTitle 最近对话列表中最近一条消息的title，比如：最近一条消息是图片，可设置该字段内容为：`@"图片"`，相应会展示：`[图片]`。
 *  - summary 会显示在 push 提示中
 * @attention 务必添加这三个字段，ChatKit 内部会使用到。
 */
- (instancetype)initWithClientId:(NSString *)clientId {
    self = [super init];
    if (!self) {
        return nil;
    }
    [self lcck_setObject:@"名片" forKey:LCCKCustomMessageTypeTitleKey];
    [self lcck_setObject:@"这是一条名片消息，当前版本过低无法显示，请尝试升级APP查看" forKey:LCCKCustomMessageDegradeKey];
    [self lcck_setObject:@"有人向您发送了一条名片消息，请打开APP查看" forKey:LCCKCustomMessageSummaryKey];
    [self lcck_setObject:clientId forKey:@"clientId"];
    return self;
}

+ (instancetype)vCardMessageWithClientId:(NSString *)clientId {
    return [[self alloc] initWithClientId:clientId];
}

#pragma mark -
#pragma mark - Override Methods

#pragma mark -
#pragma mark - AVIMTypedMessageSubclassing Method

+ (void)load {
    [self registerSubclass];
}

+ (AVIMMessageMediaType)classMediaType {
    return kAVIMMessageMediaTypeVCard;
}

@end
