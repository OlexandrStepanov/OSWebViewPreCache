//
//  IAURLCache.h
//
//  Created by Alex.S on 29/08/2015.
//  Copyright (c) 2015 Oleksandr Stepanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOG_VERBOSE 1

/**
 *  This class implements caching for web pages and resources, so they are available offline.
 *  Before displaying web page, which you would like to be shown from cache, call enableCache method
 *  After, to prevent using cache for all following HTTP requests, call disableCache.
 */
@interface OSURLCache : NSURLCache

/**
 *  Returns current instance of this class in between calls enableCache and disableCache
 */
+ (instancetype)sharedInstance;

/**
 *  Once called, the caching for web views is enabled. Sets cacheReadEnabled and cacheWriteEnabled to YES.
 */
- (void)enableCache;

/**
 *  Call to disable cache for requests.
 */
- (void)disableCache;

/**
 *  Use this method to check, does application has precache for this URL.
 *
 *  @param url  URL to check
 *
 *  @return Boolean flag, is requested url precached
 */
- (BOOL)hasPrecacheDataForURL:(NSURL*)url;

/**
 *  Was cache updated during last session. enableCache sets this property to NO.
 */
@property (nonatomic, readonly) BOOL cacheWasUpdated;

/**
 *  These flags controls can be cached web resources read from the cache, and should they be written to the cache.
 *  Note, enableCache class methods sets these flags to YES.
 */
@property (nonatomic) BOOL cacheReadEnabled;
@property (nonatomic) BOOL cacheWriteEnabled;

@end
