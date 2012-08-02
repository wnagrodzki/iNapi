//
//  INSubtitleDownloader.m
//  iNapi
//
//  Created by Wojtek Nagrodzki on 22/06/2012.
//  Copyright (c) 2012 Trifork. All rights reserved.
//

#import "INSubtitleDownloader.h"


@interface INSubtitleDownloader ()

@property (assign, nonatomic) dispatch_queue_t downloadQueue;
@property (strong, nonatomic) NSFileManager * fileManager;

@end


@implementation INSubtitleDownloader

@synthesize delegate;
// Private
@synthesize downloadQueue;
@synthesize fileManager;

+ (INSubtitleDownloader *)sharedDownloader
{
    __strong static id _sharedObject = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.downloadQueue = dispatch_queue_create("com.izydor86.inapi.downloadSubtitles", DISPATCH_QUEUE_SERIAL);
        self.fileManager = [NSFileManager defaultManager];
    }
    return self;
}

- (void)dealloc
{
    dispatch_release(downloadQueue);
    self.downloadQueue = NULL;
}

#pragma mark - Interface

-(void)downloadSubtitlesAtURL:(NSURL *)subtitlesURL forMovieAtURL:(NSURL *)movieURL completionHandler:(void (^)(NSURL * downloadedSubtitlesURL, NSError * downloadError))completionHandler
{
    dispatch_async(self.downloadQueue, ^{
        
        // download subtitles
        NSError * error;
        NSString * subtitles = [NSString stringWithContentsOfURL:subtitlesURL 
                                                        encoding:NSWindowsCP1250StringEncoding 
                                                           error:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(nil, error);
            });
            return;
        }
        
        // check if subtitles were found, if not pass error 
        if ([subtitles isEqualToString:@"NPc0"]) {
            error = [NSError errorWithDomain:@"com.izydor86.iNapi" code:404 userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(nil, error);
            });
            return;
        }
        
        // construct URL where subtitles will to be stored
        NSURL * subtitlesSaveURL = [[movieURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"txt"];
        
        // rename existing subtitles if necessary
        BOOL archivePreviousSubtitles = [self.delegate subtitleDownloader:self shouldArchivePreviousSubtitlesAtURL:subtitlesSaveURL forMovieAtURL:movieURL];
        if (archivePreviousSubtitles && [self.fileManager fileExistsAtPath:subtitlesSaveURL.path] == YES) {
            NSURL * archiverSubtitlesSaveURL = [self archivedURLWithURL:subtitlesSaveURL];
            if ([self.fileManager moveItemAtURL:subtitlesSaveURL toURL:archiverSubtitlesSaveURL error:&error] == NO) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(nil, error);
                });
                return;
            }
        }
        
        // save subtitles
        if ([subtitles writeToURL:subtitlesSaveURL atomically:YES encoding:NSWindowsCP1250StringEncoding error:&error] == NO) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(nil, error);
            });
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(subtitlesSaveURL, nil);
        });
    });
}

#pragma mark - Private

- (NSURL *)archivedURLWithURL:(NSURL *)url
{
    NSString * lastPathComponent = [url lastPathComponent];
    NSString * dateAndExtension = [NSString stringWithFormat:@"%@.txt", [NSDate date]];
    lastPathComponent = [lastPathComponent stringByReplacingOccurrencesOfString:@".txt" withString:dateAndExtension];
    
    return [[url URLByDeletingLastPathComponent] URLByAppendingPathComponent:lastPathComponent];
}

@end
