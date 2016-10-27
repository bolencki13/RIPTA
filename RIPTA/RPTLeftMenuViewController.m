//
//  RPTLeftMenuViewController.m
//  RIPTA
//
//  Created by Preston Perriott on 10/26/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "RPTLeftMenuViewController.h"

@interface RPTLeftMenuViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSArray *aryMenu;
    
    UIImageView *imgViewBackground;
    UIVisualEffectView *blurView;
    UITableView *tblMenu;
}

@end

@implementation RPTLeftMenuViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    imgViewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
    imgViewBackground.frame = self.view.bounds;
    imgViewBackground.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:imgViewBackground];
    
    blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    blurView.frame = imgViewBackground.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [imgViewBackground addSubview:blurView];
    
    aryMenu = @[
                @"Busses",
                @"Routes",
                @"Trip Planner",
                @"Settings",
                ];
    
    tblMenu = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame)-100, CGRectGetHeight(self.view.frame)-200) style:UITableViewStyleGrouped];
    tblMenu.backgroundColor = [UIColor clearColor];
    tblMenu.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblMenu.scrollEnabled = NO;
    tblMenu.dataSource = self;
    tblMenu.delegate = self;
    [self.view addSubview:tblMenu];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [aryMenu count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"ripta.cell.menu";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [aryMenu objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *item = [aryMenu objectAtIndex:indexPath.row];
    
    
    /*
     
     Check if currently visible controller is equal to item selected.
     if not - fade to new UIViewController
     else close menu
     
     */
    
    if ([item isEqualToString:@"Busses"]) {
        
    }
    else if ([item isEqualToString:@"Routes"]) {
        
    }
    else if ([item isEqualToString:@"Trip Planner"]) {
        
    }
    else if ([item isEqualToString:@"Settings"]) {
        
    }
}
@end
