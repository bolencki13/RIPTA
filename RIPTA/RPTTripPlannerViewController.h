//
//  RPTTripPlannerViewController.h
//  RIPTA
//
//  Created by Preston Perriott on 10/29/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"


@interface RPTTripPlannerViewController : UIViewController
@property (nonatomic, retain, readonly) UISearchBar *toSearchBar;
@property (nonatomic, retain, readonly) UISearchBar *fromSearchBar;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *tableHolsterView;


@end
