//
//  main.m
//  HopOn-Injector
//
//  Created by Matt Diephouse on 9/26/13.
//  Copyright (c) 2013 Matt Diephouse. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <syslog.h>

#import "Injector.h"
#import "XPCListenerDelegate.h"

int main(int argc, const char * argv[])
{
    NSXPCListener		*listener = [[NSXPCListener alloc] initWithMachServiceName:HopOnInjectorServiceName];
	XPCListenerDelegate *delegate = [XPCListenerDelegate new];
	listener.delegate = delegate;
	[listener resume];
	
	[NSRunLoop.currentRunLoop run];
	
    exit(EXIT_SUCCESS);
}

