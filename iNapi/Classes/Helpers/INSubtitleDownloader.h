//
//  INSubtitleDownloader.h
//  iNapi
//
//  Created by Wojtek Nagrodzki on 22/06/2012.
//  Copyright (c) 2012 Trifork. All rights reserved.
//

#import <Foundation/Foundation.h>

@class INSubtitleDownloader;

@protocol INSubtitleDownloaderDelegate <NSObject>

- (BOOL)subtitleDownloader:(INSubtitleDownloader *)subtitleDownloader shouldArchivePreviousSubtitlesAtURL:(NSURL *)oldSubtitlesURL forMovieAtURL:(NSURL *)movieURL;

@end


@interface INSubtitleDownloader : NSObject

@property (weak, nonatomic) id<INSubtitleDownloaderDelegate> delegate;

-(void)downloadSubtitlesAtURL:(NSURL *)subtitlesURL forMovieAtURL:(NSURL *)movieURL completionHandler:(void (^)(NSURL * downloadedSubtitlesURL, NSError * error))completionHandler;

@end
