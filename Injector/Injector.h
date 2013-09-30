//
//  Injector.h
//  HopOn
//
//  Created by Matt Diephouse on 9/28/13.
//  Copyright (c) 2013 Matt Diephouse. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HopOnInjectorServiceName @"com.diephouse.matt.HopOn.Injector"

@protocol Injector <NSObject>

- (void)injectBundleAtURL:(NSURL *)bundleURL
   intoApplicationWithPID:(pid_t)pid
withMachInjectFrameworkAtURL:(NSURL *)machInjectURL;

@end

