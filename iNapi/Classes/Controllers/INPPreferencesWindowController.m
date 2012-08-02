//
//  INPPreferencesWindowController.m
//  iNapi
//
//  Created by Wojtek Nagrodzki on 25/02/2012.
//  Copyright (c) 2012 Trifork. All rights reserved.
//

#import "INPPreferencesWindowController.h"


static NSString * const INPPreferencesWindowControllerConvertToUTF8Key = @"INPPreferencesWindowControllerConvertToUTF8";
static NSString * const INPPreferencesWindowControllerArchivePreviousSubtitlesKey = @"INPPreferencesWindowControllerArchivePreviousSubtitles";
static NSString * const INPPreferencesWindowControllerCreateSRTCopyKey = @"INPPreferencesWindowControllerCreateSRTCopy";
static NSString * const INPPreferencesWindowControllerShowMainWindowKey = @"INPPreferencesWindowControllerShowMainWindow";
static NSString * const INPPreferencesWindowControllerUseGrowlKey = @"INPPreferencesWindowControllerUseGrowl";
static NSString * const INPPreferencesWindowControllerQuitINapiKey = @"INPPreferencesWindowControllerQuitINapi";
static NSString * const INPPreferencesWindowControllerSelectedLanguageIndexKey = @"INPPreferencesWindowControllerSelectedLanguageIndexKey";


@interface INPPreferencesWindowController ()

@property (assign, nonatomic) BOOL convertToUTF8;
@property (assign, nonatomic) BOOL archivePreviousSubtitles;
@property (assign, nonatomic) BOOL createSRTCopy;
@property (assign, nonatomic) BOOL showMainWindow;
@property (assign, nonatomic) BOOL useGrowl;
@property (assign, nonatomic) BOOL quitINapi;

@property (copy, nonatomic) NSArray * languages;
@property (assign, nonatomic) NSInteger selectedLanguageIndex;

- (void)localizeUserInterface;

@property (weak) IBOutlet NSTextField *subtitleLanguageLabel;
@property (weak) IBOutlet NSTextField *subtitlesLabel;
@property (weak) IBOutlet NSButton *convertToUTF8Button;
@property (weak) IBOutlet NSButton *archivePreviousButton;
@property (weak) IBOutlet NSButton *createSRTCopyButton;
@property (weak) IBOutlet NSTextField *duringDownloadLabel;
@property (weak) IBOutlet NSButton *showMainWindowButton;
@property (weak) IBOutlet NSButton *useGrowlButton;
@property (weak) IBOutlet NSTextField *afterDownloadLabel;
@property (weak) IBOutlet NSButton *quitINapiButton;

@end


@implementation INPPreferencesWindowController

@synthesize subtitleLanguageLabel;
@synthesize subtitlesLabel;
@synthesize convertToUTF8Button;
@synthesize archivePreviousButton;
@synthesize createSRTCopyButton;
@synthesize duringDownloadLabel;
@synthesize showMainWindowButton;
@synthesize useGrowlButton;
@synthesize afterDownloadLabel;
@synthesize quitINapiButton;

// Private
@synthesize convertToUTF8;
@synthesize archivePreviousSubtitles;
@synthesize createSRTCopy;
@synthesize showMainWindow;
@synthesize useGrowl;
@synthesize quitINapi;
@synthesize languages;
@synthesize selectedLanguageIndex;

#pragma mark - Class methods

+ (NSString *)subtitleLanguage
{
    NSInteger selectedLanguageIndex = [[NSUserDefaults standardUserDefaults] integerForKey:INPPreferencesWindowControllerSelectedLanguageIndexKey];
    NSArray * languageCodes = [NSArray arrayWithObjects:@"PL", @"EN", nil];
    
    return [languageCodes objectAtIndex:selectedLanguageIndex];
}

+ (BOOL)convertToUTF8
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:INPPreferencesWindowControllerConvertToUTF8Key];
}

+ (BOOL)archivePreviousSubtitles
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:INPPreferencesWindowControllerArchivePreviousSubtitlesKey];
}

+ (BOOL)createSRTCopy
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:INPPreferencesWindowControllerCreateSRTCopyKey];
}

+ (BOOL)showMainWindow
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:INPPreferencesWindowControllerShowMainWindowKey];
}

+ (BOOL)useGrowl
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:INPPreferencesWindowControllerUseGrowlKey];
}

+ (BOOL)quitINapi
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:INPPreferencesWindowControllerQuitINapiKey];
}

#pragma mark - 

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        NSString * polish = NSLocalizedString(@"Polish", nil);
        NSString * english = NSLocalizedString(@"English", nil);
        self.languages = [NSArray arrayWithObjects:polish, english, nil];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self localizeUserInterface];
}

#pragma mark - Setters/Getters

- (void)setConvertToUTF8:(BOOL)flag
{
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:INPPreferencesWindowControllerConvertToUTF8Key];
}

- (BOOL)convertToUTF8
{
    return [[self class] convertToUTF8];
}

- (void)setArchivePreviousSubtitles:(BOOL)flag
{
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:INPPreferencesWindowControllerArchivePreviousSubtitlesKey];
}

- (BOOL)archivePreviousSubtitles
{
    return [[self class] archivePreviousSubtitles];
}

- (void)setCreateSRTCopy:(BOOL)flag
{
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:INPPreferencesWindowControllerCreateSRTCopyKey];
}

- (BOOL)createSRTCopy
{
    return [[self class] createSRTCopy];
}

- (void)setShowMainWindow:(BOOL)flag
{
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:INPPreferencesWindowControllerShowMainWindowKey];
}

- (BOOL)showMainWindow
{
    return [[self class] showMainWindow];
}

- (void)setUseGrowl:(BOOL)flag
{
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:INPPreferencesWindowControllerUseGrowlKey];
}

- (BOOL)useGrowl
{
    return [[self class] useGrowl];
}

- (void)setQuitINapi:(BOOL)flag
{
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:INPPreferencesWindowControllerQuitINapiKey];
}

- (BOOL)quitINapi
{
    return [[self class] quitINapi];
}

- (void)setSelectedLanguageIndex:(NSInteger)newSelectedLanguageIndex
{
    [[NSUserDefaults standardUserDefaults] setInteger:newSelectedLanguageIndex forKey:INPPreferencesWindowControllerSelectedLanguageIndexKey];
}

- (NSInteger)selectedLanguageIndex
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:INPPreferencesWindowControllerSelectedLanguageIndexKey];
}

#pragma mark - Private

- (void)localizeUserInterface
{
    self.subtitleLanguageLabel.stringValue = NSLocalizedString(@"Subtitle language", nil);
    self.subtitlesLabel.stringValue        = NSLocalizedString(@"Subtitles", nil);
    self.convertToUTF8Button.title         = NSLocalizedString(@"Convert to UTF8", nil);
    self.archivePreviousButton.title       = NSLocalizedString(@"Archive previous", nil);
    self.createSRTCopyButton.title         = NSLocalizedString(@"Create SRT copy", nil);
    self.duringDownloadLabel.stringValue   = NSLocalizedString(@"During download", nil);
    self.showMainWindowButton.title        = NSLocalizedString(@"Show main window", nil);
    self.useGrowlButton.title              = NSLocalizedString(@"Use Growl", nil);
    self.afterDownloadLabel.stringValue    = NSLocalizedString(@"After download", nil);
    self.quitINapiButton.title             = NSLocalizedString(@"Quit iNapi", nil);
}

@end
