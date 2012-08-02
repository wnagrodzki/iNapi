//
//  INPURLCreator.m
//  iNapi
//
//  Created by Wojtek Nagrodzki on 03/03/2012.
//  Copyright (c) 2012 Trifork. All rights reserved.
//

#import "INPURLCreator.h"
#import "NSData+MD5.h"


@interface INPURLCreator ()

- (NSString *)md5HashOfFirst10MBOfFile:(NSString *)filePath;
- (NSString *)mysteriousHash:(NSString *)md5String;

@end


@implementation INPURLCreator

- (NSURL *)iNapiURLForMovie:(NSString *)filePath language:(NSString *)language
{
	NSString * md5Hash = [self md5HashOfFirst10MBOfFile:filePath];
	NSString * mysteriousHash = [self mysteriousHash:md5Hash];
	
	NSString* urlString = [NSString stringWithFormat:
						   @"http://napiprojekt.pl/unit_napisy/dl.php?"
						   @"l=%@&"
						   @"f=%@&"
						   @"t=%@&"
						   @"v=pynapi&"
						   @"kolejka=false&"
						   @"nick=&"
						   @"pass=&"
						   @"napios=posix",language, md5Hash, mysteriousHash];
	
	return [NSURL URLWithString:urlString];
}

- (NSString *)md5HashOfFirst10MBOfFile:(NSString *)filePath
{
	NSFileHandle * fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
	NSData * data = [fileHandle readDataOfLength:1024*1024*10];
	return [data md5];
}

- (NSString *)mysteriousHash:(NSString *)md5String
{
	if ([md5String length] != 32) {
		return nil;
	}
	
	int idx[] = {0xe, 0x3, 0x6, 0x8, 0x2};
	int mul[] = {2, 2, 5, 4, 3};
	int add[] = {0x0, 0xd, 0x10, 0xb, 0x5};
	
	int t;
	unsigned tmp, v;
	
	NSMutableString *result = [NSMutableString string];
	
	for (int i = 0; i < 5; i++) {
		
		//hex to int
		NSScanner *scanner = [NSScanner scannerWithString:[NSString stringWithFormat:@"%c", [md5String characterAtIndex:idx[i]]]];
		[scanner scanHexInt:&tmp];
		
		t = add[i] + tmp;
		
		//hex to int
		NSString *subString;
		
		if (t > 30) {
			subString = [md5String substringFromIndex:t];
		}
		else {
			subString = [md5String substringWithRange:NSMakeRange(t, 2)];
		}
		
		scanner = [NSScanner scannerWithString:subString];
		[scanner scanHexInt:&v];
		
		NSString *hexResult = [NSString stringWithFormat:@"%x", v * mul[i]];
		NSString *lastLetter = [hexResult substringFromIndex:[hexResult length] - 1];
		[result appendString:lastLetter];
	}
	
	return [result stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

@end
