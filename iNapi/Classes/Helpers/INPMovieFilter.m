//
//  INPMovieFilter.m
//  iNapi
//
//  Created by Wojtek Nagrodzki on 03/03/2012.
//  Copyright (c) 2012 Trifork. All rights reserved.
//

#import "INPMovieFilter.h"


@interface INPMovieFilter ()

@property (strong, nonatomic) NSFileManager * fileManager;

- (BOOL)fileConformsToMovieUTI:(NSString *)filePath;
- (NSArray *)moviePathsAtDirectory:(NSString *)directoryPath;

@end


@implementation INPMovieFilter

- (id)init
{
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}

#pragma mark - Interface

- (NSArray *)moviePathsAmongFilePaths:(NSArray *)filePaths
{
	NSMutableArray * movies = [NSMutableArray array];
	
	BOOL isDirectory;
	for (NSString * path in filePaths) {
		[self.fileManager fileExistsAtPath:path isDirectory:&isDirectory];
		
		if (isDirectory) {
			NSArray * moviePathsAtDirectory = [self moviePathsAtDirectory:path];
			[movies addObjectsFromArray:moviePathsAtDirectory];
		}
		else {
			if ([self fileConformsToMovieUTI:path])
				[movies addObject:path];
		}
	}
	
	return movies;
}

#pragma mark - Private

- (BOOL)fileConformsToMovieUTI:(NSString *)filePath
{
	NSString* targetFilePath_converted = [filePath stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	CFURLRef anUrl = (__bridge CFURLRef)[NSURL URLWithString: targetFilePath_converted];
	FSRef ref;
	CFURLGetFSRef(anUrl,&ref);
	CFTypeRef outValue;
	LSCopyItemAttribute (
						 &ref,
						 kLSRolesAll,
						 kLSItemContentType,
						 &outValue
						 );
	
	CFStringRef uti = (__bridge CFStringRef)[NSString stringWithString:(__bridge NSString *)outValue];
	
	return UTTypeConformsTo(uti, kUTTypeMovie);
}

- (NSArray *)moviePathsAtDirectory:(NSString *)directoryPath
{
	NSMutableArray * movies = [NSMutableArray array];
	
	NSDirectoryEnumerator* enumerator = [self.fileManager enumeratorAtPath:directoryPath];
	BOOL isDirectory;
	NSString * iPath = nil;
	NSString* completeIPath = nil;
	
	while (iPath = [enumerator nextObject]) {
		completeIPath = [[NSString stringWithString:directoryPath] stringByAppendingPathComponent:iPath];
		[self.fileManager fileExistsAtPath:completeIPath isDirectory: &isDirectory];
		
		if (!isDirectory)
			if ([self fileConformsToMovieUTI:completeIPath])
				[movies addObject:completeIPath];
	}
	
	return movies;
}

@end
