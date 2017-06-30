//
//  RSWKCookieSyncManager.h
//  RSAutoWebView
//
//  Created by WhatsXie on 2017/6/16.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface RSWKCookieSyncManager : NSObject

@property (nonatomic, strong) WKProcessPool *processPool;

@property (nonatomic, strong) NSURL *url;

- (void)setCookie;

+ (instancetype)sharedWKCookieSyncManager;


@end
