//
//  rAppDelegate.m
//  KioskTest
//
//  Created by Raphael Cruzeiro on 3/12/12.
//  Copyright (c) 2012 Inspira Tecnologia e Mkt. All rights reserved.
//

#import "rAppDelegate.h"

@implementation rAppDelegate

@synthesize contentView, blockers;

- (void)dealloc
{
    [super dealloc];
    
    for(id obj in blockers) {
        [obj dealloc];
    }
    
    [blockers dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    shouldTerminate = NO;
    blockers = [[NSMutableArray alloc] init];
    
    NSRect screenRect;
    NSArray *screenArray = [NSScreen screens];
    unsigned screenCount = [screenArray count];
    unsigned index  = 0;
    
    for (index = 0; index < screenCount; index++)
    {
        NSScreen *screen = [screenArray objectAtIndex: index];
        screenRect = [screen frame];
        
        
        NSWindow *blocker = [[NSWindow alloc] initWithContentRect:screenRect styleMask:0 backing:NSBackingStoreBuffered defer:NO screen:[NSScreen mainScreen]];
        [blocker setBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"black-Linen.png"]]];
        [blocker setIsVisible:YES];
        [blocker setLevel:NSFloatingWindowLevel];
        [blocker makeKeyAndOrderFront:nil];
        [blockers insertObject:blocker atIndex:index];
    }
    
    @try {
        NSApplicationPresentationOptions options = NSApplicationPresentationHideDock + NSApplicationPresentationHideMenuBar + NSApplicationPresentationDisableForceQuit;
        [NSApp setPresentationOptions:options];
    }
    @catch(NSException * exception) {
        NSLog(@"Error.  Make sure you have a valid combination of options.");
    }
    
NSWindow *firstBlocker = (NSWindow*)[blockers objectAtIndex:0];
[firstBlocker setContentView:contentView];
}

- (IBAction) unlockScreen:(id)sender
{
    for(NSWindow *blocker in blockers) {
        [blocker orderOut:self];
        NSLog(@"closing blocker");
    }
    
    shouldTerminate = YES;
    
    [NSApp terminate:self];
}

-(NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    if (shouldTerminate) {
        return NSTerminateNow;
    }
    return NSTerminateCancel;
}


@end
