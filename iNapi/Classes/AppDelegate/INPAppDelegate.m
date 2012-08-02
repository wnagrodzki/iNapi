//
//  INPAppDelegate.m
//  iNapi
//
//  Created by Wojtek Nagrodzki on 25/02/2012.
//  Copyright (c) 2012 Trifork. All rights reserved.
//

#import "INPAppDelegate.h"
#import "INPPreferencesWindowController.h"
#import "INPMovieFilter.h"
#import "INSubtitleDownloader.h"
#import "INDownloadResult.h"
#import "INPURLCreator.h"


@interface INPAppDelegate () <INSubtitleDownloaderDelegate>

@property (weak) IBOutlet NSArrayController *downloadResultsArrayController;

@property (strong, nonatomic) INSubtitleDownloader * subtitleDownloader;
@property (strong, nonatomic) INPURLCreator * urlCreator;
@property (strong, nonatomic) INPMovieFilter * movieFilter;
@property (strong, nonatomic) INPPreferencesWindowController * preferencesWindowController;
@property (strong, nonatomic) NSMutableArray * downloadResults;
@property (assign, nonatomic) float downloadProgress;

@end


@implementation INPAppDelegate

- (IBAction)showPreferences:(id)sender
{    
    [self.preferencesWindowController.window makeKeyAndOrderFront:self];
}

#pragma mark - Private

- (INSubtitleDownloader *)subtitleDownloader
{
    if (_subtitleDownloader == nil) {
        _subtitleDownloader = [[INSubtitleDownloader alloc] init];
        _subtitleDownloader.delegate = self;
    }
    return _subtitleDownloader;
}

- (INPURLCreator *)urlCreator
{
    if (_urlCreator == nil) {
        _urlCreator = [[INPURLCreator alloc] init];
    }
    
    return _urlCreator;
}

- (INPMovieFilter *)movieFilter
{
    if (_movieFilter == nil) {
        _movieFilter = [[INPMovieFilter alloc] init];
    }
    
    return _movieFilter;
}

- (INPPreferencesWindowController *)preferencesWindowController
{
    if (_preferencesWindowController == nil) {
        _preferencesWindowController = [[INPPreferencesWindowController alloc] initWithWindowNibName:@"INPPreferencesWindow"];
    }
    
    return _preferencesWindowController;
}

- (NSMutableArray *)downloadResults
{
    if (_downloadResults == nil) {
        _downloadResults = [NSMutableArray array];
    }
    
    return _downloadResults;
}

#pragma mark - Notifications

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
}

#pragma mark - NSApplicationDelegate

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
	if (!flag) {
		[self.window makeKeyAndOrderFront:self];
		return NO;
	}
	
	return YES;
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames
{
    [self.downloadResultsArrayController removeObjects:self.downloadResults];
    
    self.downloadProgress = 0;
    
    if ([INPPreferencesWindowController showMainWindow] == YES) {
        [self.window makeKeyAndOrderFront:self];
    }
    
    self.movieFilter = [[INPMovieFilter alloc] init];
    NSArray * array = [self.movieFilter moviePathsAmongFilePaths:filenames];
    
    for (NSString * path in array) {
        NSURL * movieURL = [NSURL fileURLWithPath:path];
        NSURL * subtitlesURL = [self.urlCreator iNapiURLForMovie:path language:[INPPreferencesWindowController subtitleLanguage]];
        [self.subtitleDownloader downloadSubtitlesAtURL:subtitlesURL forMovieAtURL:movieURL completionHandler:^(NSURL *downloadedSubtitlesURL, NSError *error) {
            INDownloadResult * result = [[INDownloadResult alloc] initWithDownloadedSubtitlesURL:downloadedSubtitlesURL error:error];
            [self.downloadResultsArrayController addObject:result];
            self.downloadProgress += 1.0 / array.count;
        }];
    }
    
    if ([INPPreferencesWindowController quitINapi] == YES) {
        [NSApp terminate:self];
    }
}

#pragma mark - INSubtitleDownloaderDelegate

- (BOOL)subtitleDownloader:(INSubtitleDownloader *)subtitleDownloader shouldArchivePreviousSubtitlesAtURL:(NSURL *)oldSubtitlesURL forMovieAtURL:(NSURL *)movieURL
{
    return [INPPreferencesWindowController archivePreviousSubtitles];
}

@end
