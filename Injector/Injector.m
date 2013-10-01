//
//  Injector.m
//  HopOn
//
//  Created by Matt Diephouse on 9/28/13.
//  Copyright (c) 2013 Matt Diephouse. All rights reserved.
//

#import "Injector.h"
#import "Injector_Internal.h"


#import <dlfcn.h>

@implementation Injector

#pragma mark -
#pragma mark Injector Protocol

- (void)injectBundleAtURL:(NSURL *)bundleURL
   intoApplicationWithPID:(pid_t)pid
withMachInjectFrameworkAtURL:(NSURL *)machInjectURL
{
	NSString *frameworkPath = [machInjectURL URLByAppendingPathComponent:@"mach_inject_bundle"].path;
	void *framework = dlopen(frameworkPath.UTF8String, RTLD_NOW);
	
	mach_error_t (*mach_inject_bundle_pid)(const char *, pid_t ) = dlsym(framework, "mach_inject_bundle_pid");
	
	mach_inject_bundle_pid(bundleURL.path.fileSystemRepresentation, pid);
	
	NSString *bundleLabel = @"com.diephouse.matt.HopOn-Injector";
	NSFileManager *fileManager = NSFileManager.defaultManager;
	NSURL *plistURL  = [NSURL fileURLWithPath:[NSString stringWithFormat:@"/Library/LaunchDaemons/%@.plist", bundleLabel]];
	NSURL *helperURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"/Library/PrivilegedHelperTools/%@", bundleLabel]];
	
	NSError *error;
	BOOL result;
	
	result = [fileManager removeItemAtURL:plistURL error:&error];
	if (!result)
	{
		NSLog(@"Unable to remove launchd plist: %@", error);
	}
	
	result = [fileManager removeItemAtURL:helperURL error:&error];
	if (!result)
	{
		NSLog(@"Unable to remove helper: %@", error);
	}
	
	exit(EXIT_SUCCESS);
}


@end
