//
//  INDownloadResult.h
//  iNapi
//
//  Created by Wojtek Nagrodzki on 04/07/2012.
//  Copyright (c) 2012 Trifork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INDownloadResult : NSObject

@property (strong, nonatomic, readonly) NSString * movieFileName;
@property (strong, nonatomic, readonly) NSImage * downloadResultImage;

- (id)initWithDownloadedSubtitlesURL:(NSURL *)downloadedSubtitlesURL error:(NSError *)error;

@end
