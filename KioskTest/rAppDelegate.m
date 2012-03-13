// Copyright (C) 2012 Raphael Cruzeiro
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
// CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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
