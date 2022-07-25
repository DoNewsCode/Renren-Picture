# DNStatisticSDKLib

[![CI Status](https://img.shields.io/travis/540563689@qq.com/DNStatisticSDKLib.svg?style=flat)](https://travis-ci.org/540563689@qq.com/DNStatisticSDKLib)
[![Version](https://img.shields.io/cocoapods/v/DNStatisticSDKLib.svg?style=flat)](https://cocoapods.org/pods/DNStatisticSDKLib)
[![License](https://img.shields.io/cocoapods/l/DNStatisticSDKLib.svg?style=flat)](https://cocoapods.org/pods/DNStatisticSDKLib)
[![Platform](https://img.shields.io/cocoapods/p/DNStatisticSDKLib.svg?style=flat)](https://cocoapods.org/pods/DNStatisticSDKLib)

## Example


clone project到本地，CD到Example目录下执行`pod install`，然后 运行Exmaple示例。

## 大数据统计SDK静态库接入说明

### 一、静态库集成说明

#### 1.0 文档修订说明
| 文档版本| 修订日期| 修订说明|
| --- | --- | --- |
| v1.0 | 2019-2-19 | 创建文档，支持Event事件上报，Error事件上报|
| v1.3 | 2019-10-31 | 修改上报常驻线程冻屏 & 解决线程安全数组遍历同时删除Crash问题(__NSArrayM: XXXX> was mutated while being enumerated.)|

#### 1.1 集成方式

> DNStatisticSDKLib静态可以通过CocoaPods方式集成、也可以采用手动方式集成

#####  - 1.1.1  CocoaPods方式集成

在您的`Podfile`文件中添加 
	
	pod 'DNStatisticSDKLib'

和私有源索引库路径

	source 'https://github.com/CocoaPods/Specs.git'
	source 'https://github.com/DoNewsCode/DNSpecs.git'
接着执行`pod install`命令即可	

#####  - 1.1.2 手动导入framework

clone project到本地后，将`Frameworks文件夹`下的`DNStatisticSDKLib.framework` 和`Resources文件夹`下的 `DNStatisticSDK.bundle`文件直接拖入您的项目工程即可

#### 1.2 Xcode编译选项设置

#### 1.2.1 添加权限

+ 工程plist文件设置，点击右边的information Property List后边的 "+" 展开

添加 App Transport Security Settings，先点击左侧展开箭头，再点右侧加号，Allow Arbitrary Loads 选项自动加入，修改值为 YES。 SDK API 已经全部支持HTTPS，但是部分API存在非HTTPS情况。

```json
<key>NSAppTransportSecurity</key>
    <dict>
         <key>NSAllowsArbitraryLoads</key>
         <true/>
    </dict>
```

+ Build Settings中`Other Linker Flags` **增加参数-ObjC**

#### 1.2.2 运行环境配置

+ 支持系统 iOS 9.X 及以上;
+ 支持架构：i386, x86-64, armv7, armv7s, arm64


#### 1.2.3 添加依赖 （CocoaPods方式集成请忽略该操作）
因为统计的framework静态库依赖第三方库： `AFNetworking`和 `YYModel`

如果项目支持pod管理，只需要在项目的Podfile文件中添加

 + pod 'AFNetworking'
 + pod 'YYModel'

然后执行`pod install `

如果项目不支持pod管理，则[下载AFNetworking](https://github.com/AFNetworking/AFNetworking.git) 和 [YYModel](https://github.com/ibireme/YYModel.git) 拖入项目即可



### 二、使用说明

#### 2.0 注册SDK

一般在`appdelegate`里面注册

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [DNStatisticSDK setLogLevel:DNStatisticSDKLogLevelDebug];
    [DNStatisticSDK registSDKWithAppKey:@"apprenrenwang" channelId:nil policy:SEND_REALTIME];
    
    return YES;
}

```

* plicy为上报策略，`SEND_REALTIME`为实时上报，不论wifi还是非wifi下只要能上报就上报、`SEND_REALTIME_WIFI` 为wifi情况下有事件则实时上报 如果此时非wifi情况 则隔600秒上报一次

#### 2.1 设置用户信息 （可选）

如果要上报用户的信息可以通过下面的方法进行设置

```
[DNStatisticSDK setAccount:@"xxx"];
[DNStatisticSDK setUserId:@"xxx"];
[DNStatisticSDK setGender:0];
[DNStatisticSDK setAge:50];
[DNStatisticSDK setLocation:nil];
```

#### 2.2 上报Event事件

比如上报点击评论按钮的事件

```
[DNStatisticSDK eventWithBulider:^(DNStatisticEventBuilder * _Nonnull builder) {
        builder.eventName = @"comment";
        builder.extParams = @{@"dms1" : self.listModel.newsid,
                              @"dms2" : @"newsdetail",
                              @"dms3" :  [NSString stringWithFormat:@"%d",self.listModel.displaymode]
                              
        };
 }];
    
```

* eventName 设置事件名称
* extParams 设置事件相关的的参数

说明参数如果是字符串类型则 key按照dms1....往后排，到dms32；如果是数字类型则dmn1...dmn32

#### 2.3 上报Error事件

```
 [DNStatisticSDK errorWithBulider:^(DNStatisticErrorBuilder * _Nonnull builder) {
        builder.fileName = [NSString stringWithFormat:@"%s",__FILE__];
        builder.methodName = [NSString stringWithFormat:@"%s",__func__];
        builder.lineNum = [NSString stringWithFormat:@"%d",__LINE__];
        builder.errorDetail = error.localizedDescription;
 }];
```

* fileName 发送错误的文件名称
* methodName 发送错误的方法名称
* lineNum  发送错误的行号
* errorDetai 错误的详细信息

### 三、 上报数据BI查询

#### 3.1 登录&进入查询页面

点击[这里登录](http://bi2.tagtic.cn/d/WxYtDVBmk/ri-zhi-cha-xun?orgId=1) & 进入BI数据查询界面

![](./images/d1.png)

* 查询源选择要查询的APP的查询源
* query_type 选择suuid
* value 填写设备的suuid（IDFV）
	
		[[[UIDevice currentDevice] identifierForVendor] UUIDString]
* appkey不用填