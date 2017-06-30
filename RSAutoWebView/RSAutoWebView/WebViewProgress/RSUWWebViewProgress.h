//
//  RSUWWebViewProgress.h
//  RSAutoWebView
//
//  Created by WhatsXie on 2017/6/9.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import <UIKit/UIKit.h>

#undef RS_NJK_weak
#if __has_feature(objc_arc_weak)
#define RS_NJK_weak weak
#else
#define RS_NJK_weak unsafe_unretained
#endif

typedef void (^RS_NJKWebViewProgressBlock)(CGFloat progress);

@protocol RS_NJKWebViewProgressDelegate;

@interface RSUWWebViewProgress : NSObject<UIWebViewDelegate>

@property (nonatomic, RS_NJK_weak) id<RS_NJKWebViewProgressDelegate> progressDelegate;
@property (nonatomic, RS_NJK_weak) id<UIWebViewDelegate> webViewProxyDelegate;
@property (nonatomic, copy) RS_NJKWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) CGFloat progress; // 0.0..1.0

- (void)reset;
@end

@protocol RS_NJKWebViewProgressDelegate <NSObject>
- (void)webViewProgress:(RSUWWebViewProgress *)webViewProgress updateProgress:(CGFloat)progress;
@end
