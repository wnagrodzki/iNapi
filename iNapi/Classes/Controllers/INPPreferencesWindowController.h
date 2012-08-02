//
//  INPPreferencesWindowController.h
//  iNapi
//
//  Created by Wojtek Nagrodzki on 25/02/2012.
//  Copyright (c) 2012 Trifork. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface INPPreferencesWindowController : NSWindowController

+ (NSString *)subtitleLanguage;
+ (BOOL)convertToUTF8;
+ (BOOL)archivePreviousSubtitles;
+ (BOOL)createSRTCopy;
+ (BOOL)showMainWindow;
+ (BOOL)useGrowl;
+ (BOOL)quitINapi;

@end
