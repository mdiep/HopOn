//
//  XPCListenerDelegate.m
//  HopOn
//
//  Created by Matt Diephouse on 9/27/13.
//  Copyright (c) 2013 Matt Diephouse. All rights reserved.
//

#import "XPCListenerDelegate.h"

#include <syslog.h>
#import "Injector.h"
#import "Injector_Internal.h"

@implementation XPCListenerDelegate

#pragma mark -
#pragma mark NSXPCListenerDelegate

- (BOOL)listener:(NSXPCListener *)listener shouldAcceptNewConnection:(NSXPCConnection *)newConnection
{
	newConnection.exportedInterface = [NSXPCInterface interfaceWithProtocol:@protocol(Injector)];
	newConnection.exportedObject	= [Injector new];
	[newConnection resume];
	
	return YES;
}


@end
