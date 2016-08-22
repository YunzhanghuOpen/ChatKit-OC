//
//  RedpacketDemoViewController.m
//  RCloudMessage
//
//  Created by YANG HONGBO on 2016-4-22.
//  Copyright © 2016年 云帐户. All rights reserved.
//

#import "RedpacketDemoViewController.h"
#import <ChatKit/LCChatKit.h>
//
//#pragma mark - 红包相关头文件
#import "RedpacketViewControl.h"
#import "YZHRedpacketBridge.h"
#import "LCCKChatBar.h"
#import "RedpacketConfig.h"
#import "AVIMTypedMessageRedPacket.h"
//#import "RedpacketMessage.h"
//#import "RedpacketMessageCell.h"
//#import "RedpacketTakenMessage.h"
//#import "RedpacketTakenOutgoingMessage.h"
//#import "RedpacketTakenMessageTipCell.h"
//#import "RedpacketConfig.h"
//#import "RCDHttpTool.h"
//#pragma mark -
//
// 用于获取
#pragma mark - 红包相关的宏定义
#define REDPACKET_BUNDLE(name) @"RedpacketCellResource.bundle/" name
#define REDPACKET_TAG 2016
#pragma mark -

@interface RedpacketDemoViewController ()<RedpacketViewControlDelegate,LCCKConversationViewModelDelegate>
@property (nonatomic, strong)LCCKConversationViewModel * chatViewModel;
@property (nonatomic, strong) RedpacketViewControl *redpacketControl;
@property (nonatomic, strong)NSMutableArray * usersArray;
@property (nonatomic, strong)id<LCCKUserDelegate> user;
@end

@implementation RedpacketDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usersArray = [NSMutableArray array];
    // 注册消息显示 Cell
//    [self registerClass:[RedpacketMessageCell class] forCellWithReuseIdentifier:YZHRedpacketMessageTypeIdentifier];
//    [self registerClass:[RedpacketTakenMessageTipCell class] forCellWithReuseIdentifier:YZHRedpacketTakenMessageTypeIdentifier];
//    [self registerClass:[RCTextMessageCell class] forCellWithReuseIdentifier:@"Message"];
    
    __weak typeof(self) weakSelf = self;
    [[LCCKUserSystemService sharedInstance] fetchCurrentUserInBackground:^(id<LCCKUserDelegate> user, NSError *error) {
        weakSelf.user = user;
    }];
    
    self.redpacketControl = [[RedpacketViewControl alloc] init];
    self.redpacketControl.delegate = self;
    self.redpacketControl.conversationController = self;

    self.redpacketControl.converstationInfo = [RedpacketConfig sharedConfig].redpacketUserInfo;
    
    // 设置红包 SDK 功能回调
    [self.redpacketControl setRedpacketGrabBlock:^(RedpacketMessageModel *redpacket) {
        // 用户发出的红包收到被抢的通知
//            [weakSelf onRedpacketTakenMessage:redpacket];
    } andRedpacketBlock:^(RedpacketMessageModel *redpacket) {
        // 用户发红包的通知
        // SDK 默认的消息需要改变
        redpacket.redpacket.redpacketOrgName = @"LeacCLoud红包";
        [weakSelf sendRedpacketMessage:redpacket];
    }];
    
    // 通知 红包 SDK 刷新 Token
    [[YZHRedpacketBridge sharedBridge] reRequestRedpacketUserToken:^(NSInteger code, NSString *msg) {
        //to do token失效重请求策略
    }];
}
- (void)chatBarWillSendRedPacket{
    if (self.peerId) {
        [self.redpacketControl presentRedPacketViewController];
    }else if(self.conversationId){
        [self.redpacketControl presentRedPacketMoreViewControllerWithGroupMembers:@[]];
    }
    [self sendRedpacketMessage:nil];
}

- (LCCKConversationViewModel *)chatViewModel {
    if (_chatViewModel == nil) {
        LCCKConversationViewModel *chatViewModel = [[LCCKConversationViewModel alloc] initWithParentViewController:self];
        chatViewModel.delegate = self;
        _chatViewModel = chatViewModel;
    }
    return _chatViewModel;
}

- (void)messageCellTappedMessage:(LCCKChatMessageCell *)messageCell{
    [super messageCellTappedMessage:messageCell];

}
#pragma mark - 融云消息与红包插件消息转换与处理
// 发送融云红包消息
- (void)sendRedpacketMessage:(RedpacketMessageModel *)redpacket
{
    AVIMTypedMessageRedPacket * message = [AVIMTypedMessageRedPacket messageWithText:@"这是一个红包消息" file:nil attributes:redpacket.redpacketMessageModelToDic];
    [self.chatViewModel sendCustomMessage:message];
}
//
//// 红包被抢消息处理
//- (void)onRedpacketTakenMessage:(RedpacketMessageModel *)redpacket
//{
//    RedpacketTakenMessage *message = [RedpacketTakenMessage messageWithRedpacket:redpacket];
//    // 抢自己的红包不发消息，只自己显示抢红包消息
//    if ([redpacket.currentUser.userId isEqualToString:redpacket.redpacketSender.userId]) {//如果发送者是自己
//
//        RCMessage *m = [[RCIMClient sharedRCIMClient] insertMessage:self.conversationType
//                                                           targetId:self.targetId
//                                                       senderUserId:self.conversation.senderUserId
//                                                         sendStatus:SentStatus_SENT
//                                                            content:message];
//        [self appendAndDisplayMessage:m];
//    }
//    else {
//        if (NO == self.redpacketControl.converstationInfo.isGroup) {//如果不是群红包
//            [self sendMessage:message pushContent:nil];
//        }
//        else {
//            RCMessage *m = [[RCIMClient sharedRCIMClient] insertMessage:self.conversationType
//                                                               targetId:self.targetId
//                                                           senderUserId:self.conversation.senderUserId
//                                                             sendStatus:SentStatus_SENT
//                                                                content:message];
//            [self appendAndDisplayMessage:m];
//            
//            // 按照 android 的需求修改发送红包的功能
//            RedpacketTakenOutgoingMessage *m2 = [RedpacketTakenOutgoingMessage messageWithRedpacket:redpacket];
//            [self sendMessage:m2 pushContent:nil];
//        }
//    }
//}
//- (RCMessage *)willAppendAndDisplayMessage:(RCMessage *)message
//{
//    RCMessageContent *messageContent = message.content;
//    if ([messageContent isKindOfClass:[RedpacketMessage class]]) {
//        RedpacketMessage *redpacketMessage = (RedpacketMessage *)messageContent;
//        RedpacketMessageModel *redpacket = redpacketMessage.redpacket;
//        if(RedpacketMessageTypeTedpacketTakenMessage == redpacket.messageType ){            
//            
//                // 发红包的人可以显示所有被抢红包的消息
//                // 抢红包的人显示自己的消息
//                // 过滤掉空消息显示
//            
//           if (![redpacket.currentUser.userId isEqualToString:redpacket.redpacketSender.userId]
//                && ![redpacket.currentUser.userId isEqualToString:redpacket.redpacketReceiver.userId]) {
//             
//               return nil;
//           }else if ([redpacket.currentUser.userId isEqualToString:redpacket.redpacketSender.userId]){
//               
//               RedpacketTakenMessage *takenMessage = [RedpacketTakenMessage messageWithRedpacket:redpacket];
//               RCMessage *m = [[RCIMClient sharedRCIMClient] insertMessage:message.conversationType
//                                                                  targetId:message.targetId
//                                                              senderUserId:redpacket.redpacketSender.userId
//                                                                sendStatus:SentStatus_SENT
//                                                                   content:takenMessage];
//               [self appendAndDisplayMessage:m];
//               return nil;
//           
//           }
//        }
//    } 
//    return message;
//}

- (NSArray *)groupMemberList{

    return self.usersArray;
}
@end
