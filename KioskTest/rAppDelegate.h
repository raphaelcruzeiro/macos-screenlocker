//
//  rAppDelegate.h
//  KioskTest
//
//  Created by Raphael Cruzeiro on 3/12/12.
//  Copyright (c) 2012 Inspira Tecnologia e Mkt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface rAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate> {
    bool shouldTerminate;
}

@property (assign) NSMutableArray *blockers;
@property (assign) IBOutlet NSView *contentView;

- (IBAction)unlockScreen:(id)sender;

@end
