//
//  DetailViewController.h
//  IRKit for ProWidgets
//
//  Created by kinda on 15.04.2014.
//  Copyright (c) 2014 kinda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <libprowidgets/libprowidgets.h>

@interface PWWidgetIRKitforProWidgetsDetailViewController : PWContentViewController <UITableViewDelegate, UITableViewDataSource> {
}
@property (nonatomic,assign) NSDictionary *detail;

- (UITableView *)tableView;

@end