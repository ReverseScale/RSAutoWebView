//
//  ViewController.m
//  RSAutoWebView
//
//  Created by WhatsXie on 2017/6/9.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import "ViewController.h"
#import "QZBaseWebViewController.h"
#import "RSWKCookieSyncManager.h"


@interface ViewController ()
@property (nonatomic, strong)QZBaseWebViewController *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 150, self.view.frame.size.width, 50);
    [btn setTitle:@"跳转Web" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(gotoWebView) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn3.frame = CGRectMake(0, 250, self.view.frame.size.width, 50);
    [btn3 setTitle:@"清理缓存" forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    [btn3 addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];

}
// 跳转WebView
- (void)gotoWebView {
    self.webView = [QZBaseWebViewController new];
    
    [self.webView loadWebViewWithURL:@"https://pan.baidu.com" autoChoose:NO ifCloseAutoChooseUsingUIWebView:YES];
    
    // 1.WebView代理
    self.webView.finishLoadBlock = ^(id webView) {
        NSLog(@"finishLoadBlock");
        //创建设置cookie单例
        RSWKCookieSyncManager *cookiesManager = [RSWKCookieSyncManager sharedWKCookieSyncManager];
        //搬移cookies
        [cookiesManager setCookie];
        
        NSLog(@"cookiesManager:%@ \n", cookiesManager.processPool);
    };
    
    // 2.JS交互
    [self.webView JSCallHandlerWithFuncName:@"testJavascriptHandler" Data:@{ @"greetingFromObjC": @"Hi there, JS!" }];
    self.webView.javaScriptCallReturnBlock = ^(id response) {
        NSLog(@"response:%@", response);
    };
    
    [self.navigationController pushViewController:self.webView animated:YES];
}
// 清理缓存
- (void)clear {
    [self.webView clearCache];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
