//
//  ViewController.m
//  IRKit for ProWidgets
//
//  Created by kinda on 15.04.2014.
//  Copyright (c) 2014 kinda. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "UIImage+IRKit.h"
#import "Headers.h"
#import <objcipc/objcipc.h>

@implementation PWWidgetIRKitforProWidgetsViewController

- (void)load
{
    self.wantsFullscreen = NO;
    self.shouldMaximizeContentHeight = NO;
    self.requiresKeyboard = NO;

    self.shouldAutoConfigureStandardButtons = YES;
    self.actionButtonText = @"Manage";
    
    self.view.backgroundColor = [UIColor clearColor];
    // self.view.backgroundColor = [PWTheme parseColorString:@"#d9d9d9"];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
}

- (NSString *)title
{
    return @"IRKit";
}

- (void)loadView
{
    self.view = [[UITableView new] autorelease];
}

- (void)triggerAction
{
    SpringBoard *app = (SpringBoard *)[UIApplication sharedApplication];
    [app launchApplicationWithIdentifier:@"jp.maaash.simpleremote" suspended:NO];
    [self.widget dismiss];
}

- (void)triggerClose
{
    [self.widget dismiss];
}

- (UITableView *)tableView
{
    return (UITableView *)self.view;
}

- (CGFloat)contentHeightForOrientation:(PWWidgetOrientation)orientation
{
    // this method is unnecessary if either wantsFullscreen or shouldMaximizeContentHeight is YES.
    return 350.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    unsigned int row = [indexPath row];

    NSDictionary *dict = @{ @"action": @"send_signal", @"index" : [NSNumber numberWithInteger:row] };
    [OBJCIPC sendMessageToAppWithIdentifier:@"jp.maaash.simpleremote" messageName:@"IRKitSimple" dictionary:dict replyHandler:^(NSDictionary *reply) {
        BOOL success = [reply[@"success"] boolValue];
        if (!success) {
            [self.widget showMessage:@"Failed to send signal."];
        }
    }];

    // deselect the cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    unsigned int row = [indexPath row];

    PWWidgetIRKitforProWidgetsDetailViewController * vc = [[PWWidgetIRKitforProWidgetsDetailViewController alloc] initForWidget:self.widget];
    vc.title = _signals[row][@"name"];
    vc.detail = _signals[row];
    [self.widget pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    //cell.backgroundColor = [PWTheme parseColorString:@"#e5e5e5"];
}

- (void)willBePresentedInNavigationController:(UINavigationController *)navigationController
{
    [self retrieveRecords];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_signals count];
}

- (void)retrieveRecords
{
    NSDictionary *dict = @{ @"action": @"get_signal" };
    [OBJCIPC sendMessageToAppWithIdentifier:@"jp.maaash.simpleremote" messageName:@"IRKitSimple" dictionary:dict replyHandler:^(NSDictionary *reply) {
        NSArray *signals = reply[@"dict"];
        if (signals) {
            RELEASE(_signals)
            _signals = [signals copy];

            [self.tableView reloadData];

            // from http://stackoverflow.com/questions/7547934/animated-reloaddata-on-uitableview
            CATransition *animation = [CATransition animation];
            [animation setType:kCATransitionFade];
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [animation setFillMode:kCAFillModeBoth];
            [animation setDuration:.2];
            [[self.tableView layer] addAnimation:animation forKey:@"fade"];
        } else {
            [self.widget showMessage:@"Please set up \"IRKit SimpleRemote\"."];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    unsigned int row = [indexPath row];
    NSDictionary *signals = _signals[row];

    static NSString *identifier = @"PWWidgetIRKitTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
    }
    cell.textLabel.text = signals[@"name"];
    cell.detailTextLabel.text = signals[@"hostname"];
    NSString *type = signals[@"custom"][@"type"];

    UIImage *image = [UIImage new];
    SBApplication* app = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithDisplayIdentifier:@"jp.maaash.simpleremote"];
    if ([type isEqualToString:@"preset"]) {
        NSString *name = signals[@"custom"][@"name"];
        _UIAssetManager *manager = [objc_getClass("_UIAssetManager") assetManagerForBundle:[app bundle]];
        image = [manager imageNamed:[NSString stringWithFormat:@"btn_icon_120_%@.png", name]];
    } else if ([type isEqualToString:@"album"]) {
        NSString *dir = signals[@"custom"][@"dir"];
        if ([dir hasPrefix:@"/var/mobile/Applications/"]) {
            dir = [[dir componentsSeparatedByString:@"/"] lastObject];
        }
        NSString *path = [NSString stringWithFormat:@"%@/Documents/%@/120.png", [app containerPath], dir];
        image = [[UIImage imageWithContentsOfFile:path] makeCornerRoundImage];
    }

    cell.imageView.image = [image makeThumbnailOfSize:CGSizeMake(40,40)];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

    return cell;
}

- (void)dealloc
{
    // release everything here
    RELEASE(_signals)
    [super dealloc];
}

@end