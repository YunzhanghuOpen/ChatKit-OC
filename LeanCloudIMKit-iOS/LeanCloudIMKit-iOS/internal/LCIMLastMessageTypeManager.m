//
//  LCIMLastMessageTypeManager.m
//  LeanCloudIMKit-iOS
//
//  Created by 陈宜龙 on 16/3/22.
//  Copyright © 2016年 ElonChan. All rights reserved.
//

#import "LCIMLastMessageTypeManager.h"
#import "AVIMTypedMessage.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "LCIMUserSystemService.h"
#import "AVIMConversation+LCIMAddition.h"

static NSMutableDictionary *attributedStringCache = nil;

@implementation LCIMLastMessageTypeManager

+ (NSString *)getMessageTitle:(AVIMTypedMessage *)message {
    NSString *title;
    AVIMLocationMessage *locationMessage;
    switch (message.mediaType) {
        case kAVIMMessageMediaTypeText:
            title = message.text;
            break;
            
        case kAVIMMessageMediaTypeAudio:
            title = NSLocalizedStringFromTable(@"Voice", @"LCIMKitString", @"声音");
            title = [NSString stringWithFormat:@"[%@]",title];
            break;
            
        case kAVIMMessageMediaTypeImage:
            title = NSLocalizedStringFromTable(@"Photo", @"LCIMKitString", @"图片");
            title = [NSString stringWithFormat:@"[%@]",title];
            break;
            
        case kAVIMMessageMediaTypeLocation:
            title = NSLocalizedStringFromTable(@"Location", @"LCIMKitString", @"位置");
            title = [NSString stringWithFormat:@"[%@]",title];
            break;
//        case kAVIMMessageMediaTypeEmotion:
//            title = NSLocalizedStringFromTable(@"Sight", @"LCIMKitString", @"表情");
//            title = [NSString stringWithFormat:@"[%@]",title];

//            break;
        case kAVIMMessageMediaTypeVideo:
            title = NSLocalizedStringFromTable(@"Video", @"LCIMKitString", @"视频");
            title = [NSString stringWithFormat:@"[%@]",title];

//TODO:
    }
    return title;
}

+ (NSAttributedString *)attributedStringWithMessage:(AVIMTypedMessage *)message conversation:(AVIMConversation *)conversation userName:(NSString *)userName{
    NSString *title = [self getMessageTitle:message];
    if (conversation.lcim_type == LCIMConversationTypeGroup) {
        title = [NSString stringWithFormat:@"%@: %@", userName, title];
    }
    if (conversation.muted && conversation.lcim_unreadCount > 0) {
        title = [NSString stringWithFormat:@"[%ld条] %@", conversation.lcim_unreadCount, title];
    }
    NSString *mentionText = @"[有人@你] ";
    NSString *finalText;
    if (conversation.lcim_mentioned) {
        finalText = [NSString stringWithFormat:@"%@%@", mentionText, title];
    } else {
        finalText = title;
    }
    if (finalText == nil) {
        finalText = @"";
    }
    if ([attributedStringCache objectForKey:finalText]) {
        return [attributedStringCache objectForKey:finalText];
    }
    UIFont *font = [UIFont systemFontOfSize:13];
    NSDictionary *attributes = @{ NSForegroundColorAttributeName: [UIColor grayColor], (id)NSFontAttributeName:font};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:finalText attributes:attributes];
    
    if (conversation.lcim_mentioned) {
        NSRange range = [finalText rangeOfString:mentionText];
        [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:183/255.0 green:20/255.0 blue:20/255.0 alpha:1], NSFontAttributeName : font} range:range];
    }
    
    [attributedStringCache setObject:attributedString forKey:finalText];
    
    return attributedString;
}

@end
