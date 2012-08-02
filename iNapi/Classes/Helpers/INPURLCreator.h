//
//  INPURLCreator.h
//  iNapi
//
//  Created by Wojtek Nagrodzki on 03/03/2012.
//  Copyright (c) 2012 Trifork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INPURLCreator : NSObject

- (NSURL *)iNapiURLForMovie:(NSString *)filePath language:(NSString *)language;

@end
