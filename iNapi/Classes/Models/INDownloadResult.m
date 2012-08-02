//
//  INDownloadResult.m
//  iNapi
//
//  Created by Wojtek Nagrodzki on 04/07/2012.
//  Copyright (c) 2012 Trifork. All rights reserved.
//

#import "INDownloadResult.h"


@interface INDownloadResult ()

@property (strong, nonatomic) NSURL * downloadedSubtitlesURL;
@property (strong, nonatomic) NSImage * downloadResultImage;

@end


@implementation INDownloadResult

@synthesize movieFileName;
@synthesize downloadResultImage;
// Private
@synthesize downloadedSubtitlesURL;

- (id)initWithDownloadedSubtitlesURL:(NSURL *)aDownloadedSubtitlesURL error:(NSError *)error
{
    self = [super init];
    if (self) {
        self.downloadedSubtitlesURL = aDownloadedSubtitlesURL;
        
        if (error == nil) {
            self.downloadResultImage = [NSImage imageNamed:@"DownloadStatusSucceeded"];
            return self;
        }
        
        if ([error.domain isEqualToString:@"com.izydor86.iNapi"] && error.code == 404) {
            self.downloadResultImage = [NSImage imageNamed:@"DownloadStatusNotFound"];
            return self;
        }
        
        self.downloadResultImage = [NSImage imageNamed:@"DownloadStatusFailed"];
    }
    return self;
}

#pragma mark - Interface

- (NSString *)movieFileName
{
    return self.downloadedSubtitlesURL.path.lastPathComponent;
}

@end
