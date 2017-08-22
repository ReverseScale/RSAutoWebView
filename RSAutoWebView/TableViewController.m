//
//  TableViewController.m
//  RSAutoWebView
//
//  Created by WhatsXie on 2017/7/6.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import "TableViewController.h"
#import "QZBaseWebViewController.h"
#import "RSWKCookieSyncManager.h"

#import <SVProgressHUD.h>

// 腾讯VAS框架
#import "Sonic.h"
#import "SonicWebViewController.h"
#import "SonicOfflineCacheConnection.h"

static NSString *testAliYunURL = @"https://pan.baidu.com";
static NSString *testTencentURL = @"http://mc.vip.qq.com/demo/indexv3?offline=1";


@interface TableViewController ()
@property (nonatomic, strong)QZBaseWebViewController *webView;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 预加载 
    [self sonicPreload];
}
// 跳转 AutoWebView 页面
- (void)openAutoWebView {
    self.webView = [self createAutoWebViewWithURL:testAliYunURL isAutoChoose:YES];
    self.webView.title = @"WebView";
    [self.navigationController pushViewController:self.webView animated:YES];
}
// 跳转 SonicWebView 页面
- (void)openSonicWebView {
    SonicWebViewController *webVC = [[SonicWebViewController alloc]initWithUrl:testTencentURL useSonicMode:YES];
    [self.navigationController pushViewController:webVC animated:YES];
}

// 清理缓存
- (void)clearCache {
    [self.webView clearCache];
    [[SonicClient sharedClient] clearAllCache];
    [SVProgressHUD showSuccessWithStatus:@"清理缓存成功"];
}

// 可选：作缓存预加载
- (void)sonicPreload {
    [[SonicClient sharedClient] createSessionWithUrl:testTencentURL withWebDelegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self openAutoWebView];
            break;
        case 1:
            [self openSonicWebView];
            break;
        default:
            [self clearCache];
            break;
    }
}

#pragma mark - create AutoWebView & Delegate
- (QZBaseWebViewController *)createAutoWebViewWithURL:(NSString *)url isAutoChoose:(BOOL)isAuto {
    QZBaseWebViewController *webView = [QZBaseWebViewController new];
    [webView loadWebViewWithURL:url];
    self.webView.finishLoadBlock = ^(id webView) {
        NSLog(@"finishLoadBlock");
        //创建设置cookie单例
        RSWKCookieSyncManager *cookiesManager = [RSWKCookieSyncManager sharedWKCookieSyncManager];
        //搬移cookies
        [cookiesManager setCookie];
        NSLog(@"cookiesManager:%@ \n", cookiesManager.processPool);
    };
    [self.webView JSCallHandlerWithFuncName:@"testJavascriptHandler" Data:@{ @"greetingFromObjC": @"Hi there, JS!" }];
    self.webView.javaScriptCallReturnBlock = ^(id response) {
        NSLog(@"response:%@", response);
    };
    
    return webView;
}
@end
