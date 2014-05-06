//
//  ViewController.h
//  IRKit for ProWidgets
//
//  Created by kinda on 15.04.2014.
//  Copyright (c) 2014 kinda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <libprowidgets/libprowidgets.h>

@interface PWWidgetIRKitforProWidgetsViewController : PWContentViewController <UITableViewDelegate, UITableViewDataSource> {
	NSArray *_asDictionary;
    NSArray *_images;
}

- (UITableView *)tableView;

@end