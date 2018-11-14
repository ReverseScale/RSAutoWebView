![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg) ![](https://img.shields.io/badge/download-512K-brightgreen.svg
) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

![](http://ghexoblogimages.oss-cn-beijing.aliyuncs.com/18-11-14/42387706.jpg)

[EN](https://github.com/ReverseScale/RSAutoWebView) | [中文](https://github.com/ReverseScale/RSAutoWebView/blob/master/README_zh.md)

针对 iOS 不同版本下 WebView 的碎片化，进行整理封装，主要功能是根据系统版本自动选择 UI/WK-WebView 进行加载。

封装功能：

* Block 方式 JavaScript <-> Objective-C 的交互。
* 滑动至顶部功能
* 扩展脚本
* 针对 WKWebView 和 UIWebView 的 Cookie 等缓存互通
* 内容渲染干预等
* 新增特征：加入腾讯 VAS·Sonic 技术，一种声称可以秒开 WebView 的框架。

*无需设置,无需插件,可创建基类继承管理全局WebView页面。*

## 🎨 测试 UI 样式

|功能列表页 |AutoWebView 加载页 |VAS·Sonic 加载页|清除缓存页|
| ------------- | ------------- | ------------- | ------------- | ------------- |
| ![](http://ghexoblogimages.oss-cn-beijing.aliyuncs.com/18-11-14/42013978.jpg) | ![](http://ghexoblogimages.oss-cn-beijing.aliyuncs.com/18-11-14/19238244.jpg) | ![](http://ghexoblogimages.oss-cn-beijing.aliyuncs.com/18-11-14/91374628.jpg) | ![](http://ghexoblogimages.oss-cn-beijing.aliyuncs.com/18-11-14/10682727.jpg) |
| 通过 Main.storyboard 创建 | 自动适配的 AutoWebView 框架 | 腾讯的秒开 WebView 框架 | 清除缓存操作 |

## 🚀 框架的优势
* 1.文件少，代码简洁
* 2.根据系统版本自动选择使用 UI/WK WebView，提升用户体验
* 3.同时支持 WebView Delegate 系统回调和 WebViewJavascriptBridge 库回调
* 4.结构架构优良，可通过基类集中管理加载页面
* 5.具备较高自定义性

## 🤖 要求
* iOS 7+
* Xcode 8+

### 🎯 安装方法
#### 安装

1.1 单独使用 RSAutoWebView
```
pod 'RSAutoWebView', '~> 0.1.0'
```

1.2 运行项目，请在控制台运行
```
pod install --verbose --no-repo-update
```

## 🛠 使用方法
### 1. RSAutoWebView 封装方法
#### 1.1 对外方法 
```objc
//使用UIWebView
- (instancetype)initWithFrame:(CGRect)frame usingUIWebView:(BOOL)usingUIWebView;

//会转接 WKUIDelegate，WKNavigationDelegate 内部未实现的回调。
@property (weak, nonatomic) id<RSAutoWebViewDelegate> delegate;

//内部使用的webView
@property (nonatomic, readonly) id realWebView;
//是否正在使用 UIWebView
@property (nonatomic, readonly) BOOL usingUIWebView;
//预估网页加载进度
@property (nonatomic, readonly) double estimatedProgress;

@property (nonatomic, readonly) NSURLRequest* originRequest;

//只有ios7以上的UIWebView才能获取到，WKWebView 请使用下面的方法.
@property (nonatomic, readonly) JSContext* jsContext;
//WKWebView 跟网页进行交互的方法。
- (void)addScriptMessageHandler:(id<WKScriptMessageHandler>)scriptMessageHandler name:(NSString*)name;

//back 层数
- (NSInteger)countOfHistory;
- (void)gobackWithStep:(NSInteger)step;

```
#### 1.2 内部方法

```objc
//---- UI 或者 WK 的API
@property (nonatomic, readonly) UIScrollView* scrollView;

- (id)loadRequest:(NSURLRequest*)request;
- (id)loadHTMLString:(NSString*)string baseURL:(NSURL*)baseURL;

@property (nonatomic, readonly, copy) NSString* title;
@property (nonatomic, readonly) NSURLRequest* currentRequest;
@property (nonatomic, readonly) NSURL* URL;

@property (nonatomic, readonly, getter=isLoading) BOOL loading;
@property (nonatomic, readonly) BOOL canGoBack;
@property (nonatomic, readonly) BOOL canGoForward;

- (id)goBack;
- (id)goForward;
- (id)reload;
- (id)reloadFromOrigin;
- (void)stopLoading;
// 清理缓存
- (void)clearCache;

- (void)evaluateJavaScript:(NSString*)javaScriptString completionHandler:(void (^)(id, NSError*))completionHandler;
// 不建议使用这个办法  因为会在内部等待webView 的执行结果
- (NSString*)stringByEvaluatingJavaScriptFromString:(NSString*)javaScriptString __deprecated_msg("Method deprecated. Use [evaluateJavaScript:completionHandler:]");

// 是否根据视图大小来缩放页面  默认为YES
@property (nonatomic) BOOL scalesPageToFit;

```
### 2. BaseWebViewController 基类方法
#### 2.1 基本方法
```objc
/* 
* url    请求地址
* isOpen 是否开启自动选择WebView功能
*        是: usingUIWebView 设置无效
*        否: usingUIWebView 设定是否使用 UIWebView
*/
- (void)loadWebViewWithURL:(NSString *)url autoChoose:(BOOL)isOpen ifCloseAutoChooseUsingUIWebView:(BOOL)usingUIWebView;
```
#### 2.2 增强方法
```objc
#pragma mark - 参数、方法
// URL地址
@property (nonatomic,copy) NSString *url;

// 加载URL方法
- (void)reloadRequest:(NSString *)url;

// 返回顶端
- (void)scrollToTop;

// 图片适应 JavaScript 注入
- (void)imgAutoFit;

// WebView中收起键盘方法
- (void)packupKeyboard;

// 返回方法
- (void)webViewBackAction:(UIBarButtonItem *)sender;

// 清理缓存
- (void)clearCache;


#pragma mark - 代理方法
/**
*  统一wk ui加载状态代理方法，二合一
*/
@property (nonatomic,copy) void(^startLoadBlock)(id webView);
@property (nonatomic,copy) void(^finishLoadBlock)(id webView);
@property (nonatomic,copy) void(^failLoadBlock)(id webView, NSError *error);

#pragma mark - WebViewJavascriptBridge JS交互方法
//callHandler【OC向JS发生消息】
- (void)JSCallHandlerWithFuncName:(NSString *)name Data:(NSDictionary *)dicData;
@property (nonatomic,copy) void(^javaScriptCallReturnBlock)(id response);

//registerHandler 【OC接收JS的消息】
- (void)JSRegisterHandlerWithFuncName:(NSString *)name;
@property (nonatomic,copy) void(^javaScriptRegisterReturnBlock)(id response, WVJBResponseCallback responseCallback);
```

### 3. 腾讯 VAS·Sonic 秒开 WebView框架
#### 3.1 简介
VasSonic 取名于索尼动画形象音速小子，是腾讯 QQ 会员 VAS 团队研发的一个轻量级的高性能的 Hybrid 框架，专注于提升页面首屏加载速度，完美支持静态直出页面和动态直出页面，兼容离线包等方案。目前 QQ 会员、QQ 购物、QQ 钱包、企鹅电竞等业务已经在使用，平均日均 PV 在 1.2 亿以上，并且这个数字还在快速增长。

![](http://og1yl0w9z.bkt.clouddn.com/17-8-22/37643772.jpg)

接入 VasSonic 后首次打开可以在初始化 APP 的时候并行请求页面资源，并且具备边加载边渲染的能力。非首次打开时，APP 可以快速加载上次打开动态缓存在本地的页面资源，然后动态刷新页面。腾讯手机 QQ 通过 VasSonic 框架使得页面首屏耗时平均低于 1S 以下。

官方开源地址：https://github.com/Tencent/vassonic

#### 3.2 基本方法
引用头文件

```
// 腾讯VAS框架
#import "Sonic.h"
#import "SonicWebViewController.h"
#import "SonicOfflineCacheConnection.h"
```

使用跳转方法
```
SonicWebViewController *webVC = [[SonicWebViewController alloc]initWithUrl:testTencentURL useSonicMode:YES];
webVC.title = @"VAS·Sonic";
[self.navigationController pushViewController:webVC animated:YES];
```

使用简单、效率高效、进程安全~~~如果你有更好的建议,希望不吝赐教!
### 你的star是我持续更新的动力!

## 📝 CocoaPods更新日志
* **2018.10.11(tag:1.0.0):** </br>
	 移除 VasSonic 功能组件。</br>
* **2017.08.22(tag:0.9.0):** </br>
	 1.整理基类开放方法，优化实现功能;</br>
	 2.加入腾讯开源的 VasSonic 秒开 WebView 框架。</br>
* **2017.04.10(tag:0.8.0):** </br>
	 1.增加 WebViewJavascriptBridge 支持，增加JavaScript <-> Objective-C 交互;</br>
	 2.Block 方式回调封装;</br>
	 3.Cookie 缓存同步机制等。</br>
* **2016.09.18(tag:0.2.5):**</br>
  1.根据系统版本自动切换WK/UI-WebView,</br>
  2.功能性封装。</br>
* **2016.08.26(tag:0.1.0):**</br>
  1.创建手动的 WebView 切换工具。</br>

## ⚖ 许可证
RSAutoWebView 使用 MIT 许可证，详情见 LICENSE 文件。


## 😬 联系方式:
* WeChat : WhatsXie
* Email : ReverseScale@iCloud.com
* Blog : https://reversescale.github.io
