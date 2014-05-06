//
//  DetailViewController.m
//  IRKit for ProWidgets
//
//  Created by kinda on 15.04.2014.
//  Copyright (c) 2014 kinda. All rights reserved.
//

#import "DetailViewController.h"
#import <objcipc/objcipc.h>
#import "Headers.h"

@implementation PWWidgetIRKitforProWidgetsDetailViewController
@synthesize detail;

- (void)load
{
    self.wantsFullscreen = NO;
    self.shouldMaximizeContentHeight = YES;
    self.requiresKeyboard = NO;
    
    self.view.backgroundColor = [PWTheme parseColorString:@"#d9d9d9"];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
}

- (void)loadView
{
    self.view = [[UITableView new] autorelease];
}

- (UITableView *)tableView
{
    return (UITableView *)self.view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    unsigned int row = [indexPath row];

    NSString *copyString;
    switch (row) {
        case 0: copyString = detail[@"deviceid"]; break;
        case 1: copyString = detail[@"format"]; break;
        case 2: copyString = [detail[@"freq"] stringValue]; break;
        case 3: copyString = detail[@"type"]; break;
        case 4: copyString = [detail[@"data"] componentsJoinedByString:@","]; break;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = copyString;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    CGSize bounds = CGSizeMake(self.tableView.frame.size.width, self.tableView.frame.size.height);
    CGSize size = [cell.textLabel.text sizeWithFont:cell.textLabel.font
                                                constrainedToSize:bounds
                                                lineBreakMode:NSLineBreakByClipping];
    CGSize detailSize = [cell.detailTextLabel.text sizeWithFont:cell.detailTextLabel.font
                                                constrainedToSize:bounds
                                                lineBreakMode:NSLineBreakByCharWrapping];
    return size.height + detailSize.height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [PWTheme parseColorString:@"#e5e5e5"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    unsigned int row = [indexPath row];

    static NSString *identifier = @"PWWidgetIRKitDetailTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
    }
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.numberOfLines = 0;
    switch (row) {
        case 0:
            cell.textLabel.text = @"deviceid";
            cell.detailTextLabel.text = detail[@"deviceid"];
            break;
        case 1:
            cell.textLabel.text = @"format";
            cell.detailTextLabel.text = detail[@"format"];
            break;
        case 2:
            cell.textLabel.text = @"freq";
            cell.detailTextLabel.text = [detail[@"freq"] stringValue];
            break;
        case 3:
            cell.textLabel.text = @"type";
            cell.detailTextLabel.text = detail[@"type"];
            break;
        case 4:
            cell.textLabel.text = @"data";
            cell.detailTextLabel.text = [detail[@"data"] componentsJoinedByString:@","];
            break;
    }

    return cell;
}

- (void)dealloc
{
    // release everything here
    [super dealloc];
}

@end