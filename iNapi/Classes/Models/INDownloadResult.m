//
//  INDownloadResult.m
//  iNapi
//
//  Created by Wojtek Nagrodzki on 04/07/2012.
//  Copyright (c) 2012 Trifork. All rights reserved.
//

#import "INDownloadResult.h"
#import "INErrors.h"


@interface INDownloadResult ()

@property (strong, nonatomic) NSURL * downloadedSubtitlesURL;
@property (strong, nonatomic) NSImage * downloadResultImage;

@end


@implementation INDownloadResult

- (id)initWithDownloadedSubtitlesURL:(NSURL *)aDownloadedSubtitlesURL error:(NSError *)error
{
    self = [super init];
    if (self) {
        _downloadedSubtitlesURL = aDownloadedSubtitlesURL;
        
        if (error == nil) {
            _downloadResultImage = [NSImage imageNamed:@"DownloadStatusSucceeded"];
            return self;
        }
        
        if ([error.domain isEqualToString:iNapiErrorDomain] && error.code == iNapiSubtitlesNotFound) {
            _downloadResultImage = [NSImage imageNamed:@"DownloadStatusNotFound"];
            return self;
        }
        
        _downloadResultImage = [NSImage imageNamed:@"DownloadStatusFailed"];
    }
    return self;
}

#pragma mark - Interface

- (NSString *)movieFileName
{
    return self.downloadedSubtitlesURL.path.lastPathComponent;
}

@end
