###云账户红包SDK接入指南(iOS)
- SDK版本号：`1.1.0`
- [集成Demo](https://github.com/YunzhanghuOpen/Redpacket-Demo-iOS)
- [官网](https://www.yunzhanghu.com)

### Step1. 实现Token注册代理(建议单例做代理)
回调时机：

* 使用红包服务，且Token不存在
* 使用红包服务，但是Token已经过期
* 使用红包服务，但是Token注册失败

```
@interface YZHRedpacketBridge : NSObject
@property (nonatomic, weak) id <YZHRedpacketBridgeDelegate> delegate;

- (void)redpacketFetchRegisitParam:(FetchRegisitParamBlock)fetchBlock withError:(NSError *)error;

将一下方式的任一实体通过typedef void (^FetchRegisitParamBlock)(RedpacketRegisitModel *model); 传入SDK

```
**Token注册方式（共三种）**

**1. 签名方式（任何App都可以基于此方式实现红包功能）**
注册商户：[注册地址](https://bv2.yunzhanghu.com/app/register)
 签名方法见：[云账户REST API文档](http://yunzhanghu-com.oss-cn-qdjbp-a.aliyuncs.com/%E4%BA%91%E8%B4%A6%E6%88%B7%E7%BA%A2%E5%8C%85%E6%8E%A5%E5%8F%A3%E6%96%87%E6%A1%A3-v3_0_1.pdf)

```
+ (RedpacketRegisitModel *)signModelWithAppUserId:(NSString *)appUserId     //  App的用户ID
                                       signString:(NSString *)sign          //  当前用户的签名（签名方法获取）
                                          partner:(NSString *)partner       //  在云账户注册的合作者（网站注册后可得到）
                                     andTimeStamp:(NSString *)timeStamp;    //  签名的时间戳（签名方法获取）
```
**2. 环信方式**

```
+ (RedpacketRegisitModel *)easeModelWithAppKey:(NSString *)appkey           //  环信的注册商户Key
                                      appToken:(NSString *)appToken         //  环信IM的Token
                                  andAppUserId:(NSString *)appUserId;       //  环信IM的用户ID
                                  
```
**3. 容联云方式**

```
+ (RedpacketRegisitModel *)rongCloudModelWithAppId:(NSString *)appId        //  容联云的AppId
                                         appUserId:(NSString *)appUserId;   //  容联云的用户ID
                                         
```

### Step2. 实现当前用户信息获取代理

```
@interface YZHRedpacketBridge : NSObject
@property (nonatomic, weak) id <YZHRedpacketBridgeDataSource>dataSource;

@protocol YZHRedpacketBridgeDataSource <NSObject>

- (RedpacketUserInfo *)redpacketUserInfo;
- 
@end

```

### Step3. 发红包
**单聊红包（限单聊）**

```
+ (void)presentRedpacketViewController:RPRedpacketControllerTypeSingle
                       fromeController:#CurrentController#
                      groupMemberCount:0
                 withRedpacketReceiver:#接收者信息#
                       andSuccessBlock:#发送成功后的回调#
         withFetchGroupMemberListBlock:nil
         andGenerateRedpacketIDBlock:nil
         
```

**小额随机红包（限单聊）**

```
+ (void)presentRedpacketViewController:RPRedpacketControllerTypeRand
                       fromeController:#CurrentController#
                      groupMemberCount:0
                 withRedpacketReceiver:#接收者信息#
                       andSuccessBlock:#发送成功后的回调#
         withFetchGroupMemberListBlock:nil
         andGenerateRedpacketIDBlock:nil
```

**普通群聊红包（限群聊）**

```
+ (void)presentRedpacketViewController:RPRedpacketControllerTypeGroup
                       fromeController:#CurrentController#
                      groupMemberCount:0
                 withRedpacketReceiver:#接收者信息#
                       andSuccessBlock:#发送成功后的回调#
         withFetchGroupMemberListBlock:nil
         andGenerateRedpacketIDBlock:nil
         
```

**专属红包（限群聊）**

* 可以指定群里某一个接收者
* 包含普通群组功能

```
+ (void)presentRedpacketViewController:RPRedpacketControllerTypeGroup
                       fromeController:#CurrentController#
                      groupMemberCount:0
                 withRedpacketReceiver:#接收者信息#
                       andSuccessBlock:#发送成功后的回调#
         withFetchGroupMemberListBlock:#获取群成员列表的回调#
         andGenerateRedpacketIDBlock:nil
```

* 红包发送成功后，调用`RedpacketMessageModel`中的`redpacketMessageModelToDic`生成需要在消息通道中传递的数据


### Step4. 抢红包

* 他人收到红包消息后，将消息体中的字典通过`RedpacketMessageModel`中的`redpacketMessageModelWithDic`转换成`MessageModel`然后调用下列方法

```
+ (void)redpacketTouchedWithMessageModel:#上文中生成的MessageModel#
                     fromViewController:#CurrentController#
                      redpacketGrabBlock:#抢红包成功后的回调#
                     advertisementAction:nil
```

**营销红包(原广告红包)**

```
+ (void)redpacketTouchedWithMessageModel:#上文中生成的MessageModel#
                     fromViewController:#CurrentController#
                      redpacketGrabBlock:#抢红包成功后的回调#
                     advertisementAction:#广告红包抢红包成功后的行为回调(查看详情，分享)#

```

### Step5. 关于GenerateRedpacketIDBlock （可选策略）
 在发红包页面可以拿到红包ID， 通过红包详情查询方法，可以查询红包详情。此方案为在极端情况下，红包SDK发红包一直超时时，红包发送成功，但是开发者没有收到回调。开发者可以通过此ID，重新查询红包是否发送成功。此方案为可选策略，开发者可以忽略。

### Step6. 其它事项

**相关UI（红包样式）**
[集成Demo](https://github.com/YunzhanghuOpen/Redpacket-Demo-iOS)中已经提供开源代码，请在Demo中查找
其它IM，请在不同的IM开源Demo中查找即可。

**三方支付回调**
请在[集成Demo](https://github.com/YunzhanghuOpen/Redpacket-Demo-iOS) 中查找`AppDelegate+Redpacket`，在工程中引入即可

**回调地址(默认为`Bundle Identifier`)**
请在工程中的Info.plist中添加此回调地址

**Other Link Flag（引入类别）**
请在工程中的BuildSetting中搜索`OtherLinkFlag`并添加`-ObjC`标记

**三方集成文档（如果遇到了集成困难可以查询此文档）**
[支付宝集成链接](https://doc.open.alipay.com/doc2/detail.htm?spm=a219a.7629140.0.0.UccR9D&treeId=59&articleId=103676&docType=1)

**集成帮助**
[集成Demo](https://github.com/YunzhanghuOpen/Redpacket-Demo-iOS)

**cocoapods支持**
红包SDK京东版本：[RedpacketLib](https://cocoapods.org/?q=Redpacket)
红包SDK支付宝版本：[RedpacketAliAuthLib](https://cocoapods.org/?q=RedpacketAliAuthLib)

红包SDK会关联支付宝SDK，无需重新集成支付宝。

---


> 联系我们:

 客服热线: **400-6565-739**
 业务咨询: **bd@yunzhanghu.com**
 客服 QQ :  **4006565739**
 技术QQ群: **366135448**


