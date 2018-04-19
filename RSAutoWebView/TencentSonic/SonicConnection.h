#import <Foundation/Foundation.h>
#import "SonicSession.h"
#import "SonicConnection.h"

/**
 * Subclass this class to request the network data from custom connection.
 */

@interface SonicConnection : NSObject

/** Use this protocal to transfer data to sonic session. */
@property (nonatomic,assign)id<SonicSessionProtocol> session;

/** Current request. */
@property (nonatomic,readonly)NSURLRequest *request;

/**
 * Check if this request class can use SonicConnection to load
 
 * @param request the request passed by the SonicSession
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request;

/**
 * SonicSession will pass the request to the connection
 
 * @param aRequest the request passed by the SonicSession
 */
- (instancetype)initWithRequest:(NSURLRequest *)aRequest;

/**
 * Start request
 */
- (void)startLoading;

/** 
 * Cancel request
 */
- (void)stopLoading;

@end
