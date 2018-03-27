//
//  SonicCacheItem.m
//  sonic
//
//  Tencent is pleased to support the open source community by making VasSonic available.
//  Copyright (C) 2017 THL A29 Limited, a Tencent company. All rights reserved.
//  Licensed under the BSD 3-Clause License (the "License"); you may not use this file except
//  in compliance with the License. You may obtain a copy of the License at
//
//  https://opensource.org/licenses/BSD-3-Clause
//
//  Unless required by applicable law or agreed to in writing, software distributed under the
//  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
//  either express or implied. See the License for the specific language governing permissions
//  and limitations under the License.
//
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "SonicCacheItem.h"
#import "SonicCache.h"
#import "SonicConstants.h"
#import "SonicUitil.h"


@implementation SonicCacheItem

- (instancetype)init NS_UNAVAILABLE
{
    return nil;
}

- (instancetype)initWithSessionID:(NSString *)aSessionID
{
    if (self = [super init]) {
        
        _sessionID = aSessionID;
                
    }
    return self;
}

- (void)dealloc
{
    if (_cacheResponseHeaders) {
        _cacheResponseHeaders = nil;
    }
    if (self.config) {
        self.config = nil;
    }
    if (self.htmlData) {
        self.htmlData = nil;
    }
    if (self.templateString) {
        self.templateString = nil;
    }
    if (self.diffData) {
        self.diffData = nil;
    }
    if (self.dynamicData) {
        self.dynamicData = nil;
    }
}

- (BOOL)hasLocalCache
{
    return self.htmlData.length > 0? NO:YES;
}

- (void)setConfig:(NSDictionary *)config
{
    if (_config) {
        _config = nil;
    }
    _config = config;
    
    NSString *csp = _config[kSonicCSP];
    if (csp.length > 0) {
        if (_cacheResponseHeaders) {
            _cacheResponseHeaders = nil;
        }
        _cacheResponseHeaders = @{SonicHeaderKeyCSPHeader:csp};
    }
}

- (NSString *)lastRefreshTime
{
    if (!self.config) {
        return nil;
    }
    return self.config[kSonicLocalRefreshTime];
}

@end
