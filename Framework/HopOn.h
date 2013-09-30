//
//  HopOn.h
//  HopOn
//
//  Created by Matt Diephouse on 9/26/13.
//  Copyright (c) 2013 Matt Diephouse. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HopOn : NSObject

+ (void)injectBundleAtURL:(NSURL *)url intoApplication:(NSRunningApplication *)application;

@end
