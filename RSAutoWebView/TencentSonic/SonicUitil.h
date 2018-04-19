#import <Foundation/Foundation.h>
#import "SonicConnection.h"
#import "SonicConstants.h"

@interface SonicUitil : NSObject

/**
 * Set sonic tag header into originRequest headers
 */
NSURLRequest *sonicWebRequest(NSURLRequest *originRequest);

/**
 * Using MD5 to encode the URL to session ID;
 */
NSString *sonicSessionID(NSString *url);

/**
 * Create sonic path with URL
 */
NSString *sonicUrl(NSString *url);

/**
 * Dispatch block to main thread.
 */
void dispatchToMain (dispatch_block_t block);

/**
 * Get SHA1 value from data.
 */
NSString * getDataSha1(NSData *data);

@end
