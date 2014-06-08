//
//  IRKitforProWidgets.m
//  IRKit for ProWidgets
//
//  Created by kinda on 15.04.2014.
//  Copyright (c) 2014 kinda. All rights reserved.
//

#import "IRKitforProWidgets.h"
#import "Headers.h"
#import <objcipc/objcipc.h>

@implementation PWWidgetIRKitforProWidgets

- (void)configure
{
    [super configure];
}

- (void)load
{
    // check if the app is installed on the device
    SBApplicationController *controller = [objc_getClass("SBApplicationController") sharedInstance];
    SBApplication *authApp = [controller applicationWithDisplayIdentifier:@"jp.maaash.simpleremote"];
    if (authApp == nil) {
        [self showMessage:@"You need to install \"IRKit SimpleRemote\" from App Store to use this widget."];
        [self dismiss];
        return;
    }

    [super load];
    // load resources here and push the root view controller here
    // initialize the root view controller (must use initForWidget:)
    _viewController = [[PWWidgetIRKitforProWidgetsViewController alloc] initForWidget:self];
    [self pushViewController:_viewController animated:NO];
}

- (void)willDismiss
{
    [OBJCIPC deactivateAppWithIdentifier:@"jp.maaash.simpleremote"];
}

- (void)dealloc
{
    // release everything here
    [_viewController release];
    [super dealloc];
}

@end