//
//  RPTLeftMenuViewController.m
//  RIPTA
//
//  Created by Preston Perriott on 10/26/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

//
//  RPTLeftMenuViewController.m
//  RIPTA
//
//  Created by Preston Perriott on 10/26/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "RPTLeftMenuViewController.h"

@interface RPTLeftMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readwrite, strong) UITableView *tableView;
@property (strong, nonatomic)NSArray *aryMenu;

@property (strong, nonatomic) UIImageView *imgViewBackground;
@property (strong, nonatomic) UIWindow *window;

@end

@implementation RPTLeftMenuViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btnInfo = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [btnInfo sizeToFit];
    [btnInfo addTarget:self action:@selector(handleInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    UINavigationItem *bottomNavigationItem = [[UINavigationItem alloc] init];
    bottomNavigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnInfo];
    
    UINavigationBar *bottomBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-44, CGRectGetWidth(self.view.frame), 44)];
    bottomBar.items = @[bottomNavigationItem];
    [self.view addSubview:bottomBar];
    bottomBar.alpha = .45;
    
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 1.5) / 2.0f, self.view.frame.size.width, 54 * 3) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    
    self.aryMenu = @[
                     @"Busses",
                     @"Routes",
                     @"Trip Planner",
                     ];
    
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)handleInfo:(UIButton*)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Info" message:@"Copyright © Brian & Preston\n\nThird part libraries retain their rights.\n- Chameleon (The MIT License (MIT))\n- RESideMenu (The MIT License (MIT))\n- ActionSheetPicker-3.0 (BSD License)\n\nInformation is provided my RIPTA" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.aryMenu count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"ripta.cell.menu";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Italic" size:30];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.aryMenu[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *item = [self.aryMenu objectAtIndex:indexPath.row];
    
    RPTRootViewController *RootVC = [[RPTRootViewController alloc]init];
    UINavigationController *RootNav = [[UINavigationController alloc]initWithRootViewController:RootVC];
    
    RPTRoutesViewController *VC = [[RPTRoutesViewController alloc] init];
    UINavigationController *RoutesNav = [[UINavigationController alloc]initWithRootViewController:VC];
//    RPTLeftMenuViewController *LVC = [[RPTLeftMenuViewController alloc] init];
    RPTTripPlannerViewController *TripVC = [[RPTTripPlannerViewController alloc]init];
    
    
    /*
     Check if currently visible controller is equal to item selected.
     if not - fade to new UIViewController
     else close menu
     
     */
    
    if ([item isEqualToString:@"Busses"]) {
        
        
        [self.sideMenuViewController hideMenuViewController];
        
        NSLog(@"Content VC : %d", self.sideMenuViewController.contentViewController.isViewLoaded);
        NSLog(@"Content VC : %@", self.sideMenuViewController.contentViewController.class);
        
        [self.sideMenuViewController setContentViewController:RootNav];
        
        
        
    }
    else if ([item isEqualToString:@"Routes"]) {
        
        
        [self.sideMenuViewController hideMenuViewController];
        [self.sideMenuViewController setContentViewController:RoutesNav];
        //  [self.sideMenuViewController presentViewController:SideMenuVC animated:YES completion:nil];
        
        
    }
    else if ([item isEqualToString:@"Trip Planner"]) {
        [self.sideMenuViewController hideMenuViewController];
        [self.sideMenuViewController setContentViewController:TripVC];
    }
    else if ([item isEqualToString:@"Settings"]) {
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 54;
    
}
@end
