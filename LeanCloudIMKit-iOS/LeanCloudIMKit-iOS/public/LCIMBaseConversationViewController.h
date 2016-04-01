//
//  LCIMBaseConversationViewController.h
//  LeanCloudIMKit-iOS
//
//  Created by 陈宜龙 on 16/3/21.
//  Copyright © 2016年 ElonChan. All rights reserved.
//

#import "LCIMBaseViewController.h"
#import "LCIMChatBar.h"
#import "LCIMChatViewModel.h"
#import "LCIMBaseTableViewController.h"

@interface LCIMBaseConversationViewController : LCIMBaseTableViewController

/**
 *  是否正在加载更多旧的消息数据
 */
@property (nonatomic, assign) BOOL loadingMoreMessage;
@property (nonatomic, weak) LCIMChatBar *chatBar;

/**
 *  判断是否支持下拉加载更多消息, 如果已经加载完所有消息，那么就可以设为NO。
 *
 *  @return 返回BOOL值，判定是否拥有这个功能
 */
@property (nonatomic, assign) BOOL shouldLoadMoreMessagesScrollToTop;

/**
 *  是否滚动到底部
 *
 *  @param animated YES Or NO
 */
- (void)scrollToBottomAnimated:(BOOL)animated;

- (void)loadMoreMessagesScrollTotop;

@end
