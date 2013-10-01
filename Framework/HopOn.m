//
//  HopOn.m
//  HopOn
//
//  Created by Matt Diephouse on 9/26/13.
//  Copyright (c) 2013 Matt Diephouse. All rights reserved.
//

#import "HopOn.h"


#import "Injector.h"

#import <ServiceManagement/ServiceManagement.h>

@implementation HopOn

+ (void)injectBundleAtURL:(NSURL *)url intoApplication:(NSRunningApplication *)application
{
	NSParameterAssert(url != nil);
	NSParameterAssert(application != nil);
	
	// Creating auth item to bless helper tool and install framework
	AuthorizationItem authItem = {kSMRightBlessPrivilegedHelper, 0, NULL, 0};
	
	// Creating a set of authorization rights
	AuthorizationRights authRights = {1, &authItem};
	
	// Specifying authorization options for authorization
	AuthorizationFlags flags = kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed | kAuthorizationFlagExtendRights;
	
	// Open dialog and prompt user for password
	AuthorizationRef authRef = NULL;
	OSStatus status = AuthorizationCreate(&authRights, kAuthorizationEmptyEnvironment, flags, &authRef);
	if (status != errAuthorizationSuccess)
	{
		NSLog(@"failed to authorize");
	}
	
	CFErrorRef blessError = NULL;
	BOOL result;
	
	NSString *bundleLabel = @"com.diephouse.matt.HopOn-Injector";
	
	result = SMJobBless(kSMDomainSystemLaunchd, (__bridge CFStringRef)bundleLabel, authRef, &blessError);
	
	if (result == NO) {
		CFIndex errorCode = CFErrorGetCode(blessError);
		CFStringRef errorDomain = CFErrorGetDomain(blessError);
		
		NSLog(@"an error occurred while installing %@ (domain: %@ (%@))", bundleLabel, errorDomain, [NSNumber numberWithLong:errorCode]);
	}
	
	NSXPCConnection *connection = [[NSXPCConnection alloc] initWithMachServiceName:HopOnInjectorServiceName options:NSXPCConnectionPrivileged];
	connection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(Injector)];
	[connection resume];
	
	NSURL *frameworkURL  = [[NSBundle bundleForClass:self] bundleURL];
	NSURL *machInjectURL = [frameworkURL URLByAppendingPathComponent:@"Versions/Current/SharedFrameworks/mach_inject_bundle.framework"];
	
	id<Injector> object = connection.remoteObjectProxy;
	[object injectBundleAtURL:url
	   intoApplicationWithPID:application.processIdentifier
withMachInjectFrameworkAtURL:machInjectURL];
}

@end
