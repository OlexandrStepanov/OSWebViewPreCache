//
//  IAURLCache.m
//
//  Created by Alex.S on 29/08/2015.
//  Copyright (c) 2015 Oleksandr Stepanov. All rights reserved.
//

#include <sys/xattr.h>

#import "OSURLCache.h"


#define PRE_CACHE_FOLDER @"WebCache"  // The folder in your app with the prefilled cache content
#define MAX_MEMORY_CAPACITY_MB 5
#define MAX_DISK_CAPACITY_MB 20

@interface OSURLCache(){
    
    BOOL _cacheEnabled;
}

@property (nonatomic, strong) NSURLCache*   defaultURLCache;

@property (nonatomic, strong) NSString *    cacheDirectory;
@property (nonatomic, strong) NSString *    preCacheDirectory;

@property (nonatomic) BOOL                  cacheWasUpdated;



@end


@implementation OSURLCache

+(instancetype)sharedInstance
{
    static dispatch_once_t once;
    static OSURLCache *sharedUrlCache;
    dispatch_once(&once, ^{
        sharedUrlCache = [[OSURLCache alloc] initWithMemoryCapacity:MAX_MEMORY_CAPACITY_MB *1024 *1024
                                                       diskCapacity:MAX_DISK_CAPACITY_MB *1024 *1024
                                                           diskPath:nil];
    });
    
    return sharedUrlCache;
}


- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0]; // Get documents folder
    path = [documentsDirectory stringByAppendingPathComponent:PRE_CACHE_FOLDER];
    
    if (self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path])
    {
        self.cacheDirectory = path;
        self.preCacheDirectory = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:PRE_CACHE_FOLDER];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:_cacheDirectory])
        {
            NSError *error;
            [[NSFileManager defaultManager] createDirectoryAtPath:_cacheDirectory withIntermediateDirectories:NO attributes:nil error:&error];
            
            if (error)
            {
                NSLog(@"Failed to create webview cache directory: %@", error);
            }
        }
    }
    
    return self;
}

- (void)enableCache
{
    // set caching paths
    self.cacheReadEnabled = YES;
    self.cacheWriteEnabled = YES;
    self.cacheWasUpdated = NO;
    
    self.defaultURLCache = [NSURLCache sharedURLCache];
    [NSURLCache setSharedURLCache:self];
    _cacheEnabled = YES;
}

- (void)disableCache
{
    if (_cacheEnabled)
    {
        [NSURLCache setSharedURLCache:self.defaultURLCache];
        _defaultURLCache = nil;
        _cacheEnabled = NO;
    }
}

- (BOOL)hasPrecacheDataForURL:(NSURL*)url
{
    NSString *storagePath = [self storagePathForRequestURL:url];
    return (storagePath != nil);
}

#pragma mark - NSURLCache override

-(NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request
{
    if (!_cacheEnabled || !self.cacheReadEnabled) {
        return nil;
    }
    
    // Is the file in the cache? If not, is the file in the PreCache?
    NSString* storagePath = [self storagePathForRequestURL:request.URL];
    if (storagePath)
    {
        // Return the cache response
        NSData* content = [NSData dataWithContentsOfFile:storagePath];
        
        NSString *mimeType = @"text/html";
        NSString *encodingName = @"utf-8";
        if ([[request.URL pathExtension] isEqualToString:@"png"])
        {
            mimeType = @"image/png";
            encodingName = nil;
        }
        else if ([[request.URL pathExtension] isEqualToString:@"jpg"] || [[request.URL pathExtension] isEqualToString:@"jpeg"])
        {
            mimeType = @"image/jpeg";
            encodingName = nil;
        }
        else if ([[request.URL pathExtension] isEqualToString:@"js"])
        {
            mimeType = @"application/javascript";
        }
        else if ([[request.URL pathExtension] isEqualToString:@"css"])
        {
            mimeType = @"text/css";
        }
        
        NSLog(@"Reading from cache URL %@", request.URL);
        NSURLResponse* response = [[NSURLResponse alloc] initWithURL:request.URL MIMEType:mimeType expectedContentLength:[content length] textEncodingName:encodingName] ;
        return [[NSCachedURLResponse alloc] initWithResponse:response data:content] ;
    }
    
    NSLog(@"Didn't found in cache URL %@", request.URL);
    return nil;
}

- (void)getCachedResponseForDataTask:(NSURLSessionDataTask *)dataTask completionHandler:(void (^) (NSCachedURLResponse *cachedResponse))completionHandler
{
    NSCachedURLResponse *urlResponse = [self cachedResponseForRequest:dataTask.currentRequest];
    completionHandler(urlResponse);
}


- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request
{
    if (!_cacheEnabled || !self.cacheWriteEnabled) {
        return;
    }
    
    //  Store cache to the cache
    NSString* storagePathCache = [self storagePathForRequestURL:request.URL andRootPath:self.cacheDirectory];
    NSString* storagePathPrecache = [self storagePathForRequestURL:request.URL andRootPath:self.preCacheDirectory];
    
    //  If data exist in cache - compare with it and override
    if ([[NSFileManager defaultManager] fileExistsAtPath:storagePathCache])
    {
        NSData *cachedData = [NSData dataWithContentsOfFile:storagePathCache];
        if (![cachedResponse.data isEqualToData:cachedData])
        {
            [self writeData:cachedResponse.data toCachePath:storagePathCache];
            self.cacheWasUpdated = YES;
        }
    }
    //  If data exist in pre cache - write it to the cache path, and compare data with pre cached
    else if ([[NSFileManager defaultManager] fileExistsAtPath:storagePathPrecache])
    {
        [self writeData:cachedResponse.data toCachePath:storagePathCache];
        NSData *cachedData = [NSData dataWithContentsOfFile:storagePathPrecache];
        if (![cachedResponse.data isEqualToData:cachedData])
        {
            self.cacheWasUpdated = YES;
        }
    }
    //  If data just doesn't exist - just write it to the cache
    else
    {
        [self writeData:cachedResponse.data toCachePath:storagePathCache];
    }
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forDataTask:(NSURLSessionDataTask *)dataTask
{
    [self storeCachedResponse:cachedResponse forRequest:dataTask.currentRequest];
}

#pragma mark -

// return the path if the file for the request is in the PreCache or Cache.
- (NSString *)storagePathForRequestURL:(NSURL*)url
{
    NSString *storagePath = [self storagePathForRequestURL:url andRootPath:self.cacheDirectory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:storagePath])
    {
        storagePath = [self storagePathForRequestURL:url andRootPath:self.preCacheDirectory];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:storagePath])
    {
        storagePath = nil;
    }
    return storagePath;
}

// Private method for generating the Cache file path for a request.
- (NSString *)storagePathForRequestURL:(NSURL*)url andRootPath:(NSString*) path
{
    NSString *host = [[url host] lowercaseString];
    NSString *relativePath = [[url relativePath] lowercaseString];
    NSString *localUrl = [[path stringByAppendingPathComponent:host] stringByAppendingPathComponent:relativePath];
    
    NSString *storageFile = [[localUrl componentsSeparatedByString: @"/"] lastObject];
    if ([storageFile rangeOfString:@"."].location == NSNotFound)
    {
        return [NSString stringWithFormat:@"%@/index", localUrl];
    }
    return localUrl;
}

// We do not want to backup this file to iCloud
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    return [URL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:nil];
}

- (void)writeData:(NSData*)cacheData toCachePath:(NSString*)storagePath
{
    NSString *storageDirectory = [storagePath stringByDeletingLastPathComponent];
    NSError* error = nil;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:storageDirectory withIntermediateDirectories:YES attributes:nil error:&error])
    {
        NSLog(@"Error creating cache directory: %@", error);
    }
    
    NSLog(@"Writing data to %@", storagePath);
    if (![cacheData writeToFile:storagePath atomically:YES])
    {
        NSLog(@"Could not write file to cache");
    }
    else
    {
        // prevent iCloud backup
        NSURL *cacheURL = [NSURL fileURLWithPath:storagePath];
        if (![OSURLCache addSkipBackupAttributeToItemAtURL:cacheURL])
        {
            NSLog(@"Could not set the do not backup attribute");
        }
    }
}

@end
