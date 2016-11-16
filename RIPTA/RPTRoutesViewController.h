//
//  RPTRoutesViewController.h
//  RIPTA
//
//  Created by Preston Perriott on 10/27/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "RPTLeftMenuViewController.h"
#import "RIPTA.h"



@interface RPTRoutesViewController : UIViewController 
@property (strong, nonatomic)UIView *TopHolderView;
@property (strong, nonatomic)UIView *BottomHolderView;
@property (strong, nonatomic)MKMapView *Map;
@property (strong, nonatomic)UITableView *RoutesTableView;
@property (nonatomic,  strong) UITableView *tableView;
@property (strong, nonatomic)UIWindow *window;


@end
