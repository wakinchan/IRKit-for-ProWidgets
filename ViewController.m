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
    
    self.view.backgroundColor = [PWTheme parseColorString:@"#d9d9d9"];

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

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
    vc.title = _asDictionary[row][@"name"];
    vc.detail = _asDictionary[row];
    [self.widget pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [PWTheme parseColorString:@"#e5e5e5"];
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
    return [_asDictionary count];
}

- (void)retrieveRecords
{
    NSDictionary *dict = @{ @"action": @"get_signal" };
    [OBJCIPC sendMessageToAppWithIdentifier:@"jp.maaash.simpleremote" messageName:@"IRKitSimple" dictionary:dict replyHandler:^(NSDictionary *reply) {
        NSArray *asDictionary = reply[@"asDictionary"];
        NSArray *images = reply[@"images"];
        if (asDictionary) {
            RELEASE(_asDictionary)
            RELEASE(_images)
            _asDictionary = [asDictionary copy];
            _images = [images copy];

            [self.tableView reloadData];

            // from http://stackoverflow.com/questions/7547934/animated-reloaddata-on-uitableview
            CATransition *animation = [CATransition animation];
            [animation setType:kCATransitionFade];
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [animation setFillMode:kCAFillModeBoth];
            [animation setDuration:.2];
            [[self.tableView layer] addAnimation:animation forKey:@"fade"];
        } else {
            [self.widget showMessage:@"Please set up IRKit Simple.app."];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    unsigned int row = [indexPath row];
    NSDictionary *asDictionary = _asDictionary[row];
    NSData *imageData = _images[row];

    static NSString *identifier = @"PWWidgetIRKitTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
    }
    cell.textLabel.text = asDictionary[@"name"];
    cell.detailTextLabel.text = asDictionary[@"hostname"];
    UIImage *icon = [[[UIImage alloc] initWithData:imageData] autorelease];
    cell.imageView.image = [icon makeThumbnailOfSize:CGSizeMake(40,40)];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

    return cell;
}

- (void)dealloc
{
    // release everything here
    RELEASE(_asDictionary)
    RELEASE(_images)
    [super dealloc];
}

@end