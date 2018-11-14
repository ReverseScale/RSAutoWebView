# RSAutoWebView

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg) ![](https://img.shields.io/badge/download-512K-brightgreen.svg
) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

![](http://ghexoblogimages.oss-cn-beijing.aliyuncs.com/18-11-14/42387706.jpg)

[EN](https://github.com/ReverseScale/RSAutoWebView) | [中文](https://github.com/ReverseScale/RSAutoWebView/blob/master/README_zh.md)


For different versions of iOS WebView fragmentation, sorting package, the main function is based on the system version automatically select UI / WK-WebView to load.

Package function:

* Block Method JavaScript <-> Objective-C Interaction.
* Swipe to the top function
* Extended script
* Cookies for WKWebView and UIWebView cache interoperability
* Content rendering interventions
* New Features: Join Tencent VAS · Sonic technology, a framework that claims WebView can be seconds off.

* No need to set up, without plug-ins, to create a base class Inheritance Management Global WebView page. *

## 🎨 What does the test UI look like?

![](https://user-gold-cdn.xitu.io/2018/3/15/16227c4b6be2f6ce?w=358&h=704&f=png&s=57294)
AutoWebView Load Page

![](https://user-gold-cdn.xitu.io/2018/3/15/16227c4b6c2d7ea0?w=358&h=704&f=png&s=37136)
Clear Cache Page

## 🚀 Advantage
* 1. Less documents, code concise
* 2. According to the system version automatically choose to use UI / WK WebView, enhance the user experience
* 3. Support both WebView Delegate system callbacks and WebView JavaScriptBridge library callbacks
* 4. The structure of the excellent structure, centralized management through the base class to load the page
* 5. Have a higher custom

## 🤖 Requirements 
* iOS 7+
* Xcode 8+

### 🎯 Installation
#### Install

1.1 Use RSAutoWebView alone

```
pod 'RSAutoWebView', '~> 0.1.0'
```

1.2 Run demo, please run in console

```
pod install --verbose --no-repo-update
```

## 🛠 Usage
### 1. RSAutoWebView wrapper method
#### 1.1 Foreign methods
```objc
//Use UIWebView
- (instancetype)initWithFrame:(CGRect)frame usingUIWebView:(BOOL)usingUIWebView;

//Will be transferred WKUIDelegate, WKNavigationDelegate unimplemented callback.
@property (weak, nonatomic) id<RSAutoWebViewDelegate> delegate;

//Internal use of webView
@property (nonatomic, readonly) id realWebView;
//Whether you are using UIWebView
@property (nonatomic, readonly) BOOL usingUIWebView;
//Estimate the progress of webpage loading
@property (nonatomic, readonly) double estimatedProgress;

@property (nonatomic, readonly) NSURLRequest* originRequest;

//Only ios7 above UIWebView can be obtained, WKWebView use the following method.
@property (nonatomic, readonly) JSContext* jsContext;
//WKWebView way to interact with the web page.
- (void)addScriptMessageHandler:(id<WKScriptMessageHandler>)scriptMessageHandler name:(NSString*)name;

//back layer
- (NSInteger)countOfHistory;
- (void)gobackWithStep:(NSInteger)step;

```
#### 1.2 internal methods

```objc
//---- UI or WK API
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
// Clean up the cache
- (void)clearCache;

- (void)evaluateJavaScript:(NSString*)javaScriptString completionHandler:(void (^)(id, NSError*))completionHandler;
// It is not recommended to use this method because it will wait for the execution of the webView internally
- (NSString*)stringByEvaluatingJavaScriptFromString:(NSString*)javaScriptString __deprecated_msg("Method deprecated. Use [evaluateJavaScript:completionHandler:]");

// Whether to scale the page by view size defaults to YES
@property (nonatomic) BOOL scalesPageToFit;

```
### 2. BaseWebViewController base class method
#### 2.1 The basic method

```objc
/ *
* url request address
* isOpen Whether to enable automatic selection of WebView features
* Is: usingUIWebView setting is invalid
* No: usingUIWebView set whether to use UIWebView
* /
- (void)loadWebViewWithURL:(NSString *)url autoChoose:(BOOL)isOpen ifCloseAutoChooseUsingUIWebView:(BOOL)usingUIWebView;
```

#### 2.2 Enhance the method

```objc
#pragma mark - Parameters, methods
// URL address
@property (nonatomic,copy) NSString *url;

// Load URL method
- (void)reloadRequest:(NSString *)url;

// Back to top
- (void)scrollToTop;

// Image adapted to JavaScript injection
- (void)imgAutoFit;

// Collapse the keyboard method in WebView
- (void)packupKeyboard;

// Return method
- (void)webViewBackAction:(UIBarButtonItem *)sender;

// Clean up the cache
- (void)clearCache;


#pragma mark - Proxy method
/**
*  Unified wk ui loading state proxy method, combo
*/
@property (nonatomic,copy) void(^startLoadBlock)(id webView);
@property (nonatomic,copy) void(^finishLoadBlock)(id webView);
@property (nonatomic,copy) void(^failLoadBlock)(id webView, NSError *error);

#pragma mark - WebViewJavascriptBridge JS interaction method
// callHandler [OC news to JS]
- (void)JSCallHandlerWithFuncName:(NSString *)name Data:(NSDictionary *)dicData;
@property (nonatomic,copy) void(^javaScriptCallReturnBlock)(id response);

// registerHandler [OC receive JS news]
- (void)JSRegisterHandlerWithFuncName:(NSString *)name;
@property (nonatomic,copy) void(^javaScriptRegisterReturnBlock)(id response, WVJBResponseCallback responseCallback);
```

### 3. Tencent VAS · Sonic seconds to open the WebView framework
#### 3.1 Introduction
VasSonic named after the Sony animated image sound speed kid, is Tencent QQ membership VAS team developed a lightweight high-performance Hybrid framework, focusing on improving the first page of the page loading speed, the perfect support for static straight out of the page and the dynamic straight out of the page, Compatible with offline packages and other programs. Currently QQ members, QQ shopping, QQ wallet, penguins and other businesses have been using e-sports, the average daily PV in more than 120 million, and this number is still rapidly growing.

![](http://og1yl0w9z.bkt.clouddn.com/17-8-22/37643772.jpg)

The first time you access VasSonic, you can request the page resources in parallel while initializing your app and have the ability to load side-edges. When not opening for the first time, the app can quickly load the last time the page resource was dynamically cached in the local page, and then dynamically refresh the page. Tencent mobile QQ through the VasSonic framework makes the first page of the screen consumes less than 1S average time below.

Official open source address: https://github.com/Tencent/vassonic

#### 3.2 The basic method

Quote the header file

```
// Tencent VAS framework
#import "Sonic.h"
#import "SonicWebViewController.h"
#import "SonicOfflineCacheConnection.h"
```

Use the jump method

```
SonicWebViewController *webVC = [[SonicWebViewController alloc]initWithUrl:testTencentURL useSonicMode:YES];
webVC.title = @"VAS·Sonic";
[self.navigationController pushViewController:webVC animated:YES];
```

Simple to use, efficient, process-safe ~~~ If you have better suggestions, I hope have enlighten me!

### Your star is my motivation to keep updating!

## 📝 CocoaPods update log
* ** 2017.10.11 (tag: 1.0.0): 

Remove the VasSonic functional component. 

* ** 2017.08.22 (tag: 0.9.0): 

1. Sort open base class method, optimize the realization of the function; 

2. Join Tencent open source VasSonic second open WebView framework. 

* ** 2017.04.10 (tag: 0.8.0): 

1. Add WebViewJavascriptBridge support, add JavaScript <-> Objective-C interaction; 

2.Block callback package; 

3.Cookie cache synchronization mechanism. 

* ** 2016.09.18 (tag: 0.2.5): 

1.Automatically switch WK / UI-WebView by system version, 

2.functional package.

* ** 2016.08.26 (tag: 0.1.0): 

1.Create a manual WebView switch tool. 

## ⚖ License License
RSAutoWebView uses a MIT license, as detailed in the LICENSE file.


## 😬 Contact :
* WeChat : WhatsXie
* Email : ReverseScale@iCloud.com
* Blog : https://reversescale.github.io



