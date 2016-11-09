//
//  RPTRoutesViewController.m
//  RIPTA
//
//  Created by Preston Perriott on 10/27/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "RPTRoutesViewController.h"
#import "RESideMenu.h"


@interface RPTRoutesViewController () <MKMapViewDelegate, UITableViewDataSource, UITabBarDelegate>



@end

@implementation RPTRoutesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self SetUpMapView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)SetUpMapView{
    
   /* _TopHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), (CGRectGetHeight(self.view.frame)/2 ))];
    [self.view addSubview:_TopHolderView];
    _Map = [[MKMapView alloc]init];
    _Map.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _Map.delegate = self;
    [_TopHolderView addSubview:_Map];
    
    _BottomHolderView = [[UIView alloc] init];
    _BottomHolderView.translatesAutoresizingMaskIntoConstraints = false;*/
    
    UIImage *BGImage = [UIImage imageNamed:@"GradientPlanner.jpg"];
    UIImageView *ImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    ImageView.image = BGImage;
    ImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    ImageView.layer.masksToBounds = TRUE;
    [self.view addSubview:ImageView];
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:235.0/ 255.0 green:219.0/255.0 blue:152/255.0 alpha:.7];
    
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStyleDone target:self action:@selector(handleMenu:)];
    
    
    _TopHolderView =[[UIView alloc]init];
    _TopHolderView.translatesAutoresizingMaskIntoConstraints = false;
    _TopHolderView.backgroundColor = [UIColor clearColor];
    _TopHolderView.layer.masksToBounds = TRUE;
    [self.view addSubview:_TopHolderView];
    
    [_TopHolderView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = TRUE;
    [_TopHolderView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = TRUE;
    [_TopHolderView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = TRUE;
    [_TopHolderView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:.5].active =TRUE;
    
    _Map = [[MKMapView alloc ]init];
    _Map.translatesAutoresizingMaskIntoConstraints  = false;
    _Map.layer.masksToBounds = YES;
    
    [_TopHolderView addSubview:_Map];
    
    [_Map.widthAnchor constraintEqualToAnchor:_TopHolderView.widthAnchor].active =TRUE;
    [_Map.heightAnchor constraintEqualToAnchor:_TopHolderView.heightAnchor].active = TRUE;
    [_Map.topAnchor constraintEqualToAnchor:_TopHolderView.topAnchor].active = TRUE;
    [_Map.centerXAnchor constraintEqualToAnchor:_TopHolderView.centerXAnchor].active = TRUE;
    
    _BottomHolderView = [[UIView alloc]init];
    _BottomHolderView.translatesAutoresizingMaskIntoConstraints = false;
    //_BottomHolderView.layer.masksToBounds = TRUE;
    _BottomHolderView.backgroundColor = [UIColor blueColor];
    _BottomHolderView.alpha = .25;
    _BottomHolderView.layer.cornerRadius = 5;
    _BottomHolderView.layer.masksToBounds = NO;
    _BottomHolderView.layer.shadowOffset = CGSizeMake(-15, 20);
    _BottomHolderView.layer.shadowRadius = 5;
    _BottomHolderView.layer.shadowOpacity = 1;
    [self.view addSubview:_BottomHolderView];
    
    [_BottomHolderView.centerXAnchor constraintEqualToAnchor:_TopHolderView.centerXAnchor].active =TRUE;
    [_BottomHolderView.widthAnchor constraintEqualToAnchor:_TopHolderView.widthAnchor constant:-20].active = TRUE;
    [_BottomHolderView.topAnchor constraintEqualToAnchor:_TopHolderView.bottomAnchor constant:10].active = TRUE;
    [_BottomHolderView.heightAnchor constraintEqualToAnchor:_TopHolderView.heightAnchor constant:-20].active = TRUE;
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
     //   UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 1.5) / 2.0f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
      //  UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, (_BottomHolderView.frame.origin.y), _BottomHolderView.frame.size.width, _BottomHolderView.frame.size.height) style:UITableViewStylePlain];
        tableView.translatesAutoresizingMaskIntoConstraints = false;
        
        //tableView.style = UITableViewStylePlain;
       // _tableView.translatesAutoresizingMaskIntoConstraints = false;
        //_tableView.layer.masksToBounds = TRUE;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
//        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    
    [_BottomHolderView addSubview:_tableView];
    
    
    [_tableView.centerXAnchor constraintEqualToAnchor:_BottomHolderView.centerXAnchor].active =TRUE;
    [_tableView.widthAnchor constraintEqualToAnchor:_BottomHolderView.widthAnchor].active = TRUE;
    [_tableView.topAnchor constraintEqualToAnchor:_BottomHolderView.topAnchor].active = TRUE;
    [_tableView.heightAnchor constraintEqualToAnchor:_BottomHolderView.heightAnchor].active = TRUE;
    
    
}
- (void)handleMenu:(UIBarButtonItem*)sender {
    
    
      
    [self.sideMenuViewController presentLeftMenuViewController];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 35;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString* cellIdentifier = @"ripta.cell.menu";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Italic" size:21];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = @"Bus Route Info";
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    /*
     Check if currently visible controller is equal to item selected.
     if not - fade to new UIViewController
     else close menu
     
     */
    
    }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
