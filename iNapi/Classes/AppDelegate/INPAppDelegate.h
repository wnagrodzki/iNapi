//
//  INPAppDelegate.h
//  iNapi
//
//  Created by Wojtek Nagrodzki on 25/02/2012.
//  Copyright (c) 2012 Trifork. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface INPAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

- (IBAction)showPreferences:(id)sender;

@end
