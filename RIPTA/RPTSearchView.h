//
//  RPTSearchView.h
//  RIPTA
//
//  Created by Brian Olencki on 10/31/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RPTSearchView;
@protocol RPTSearchViewDelegate <NSObject>
@optional
- (void)searchView:(RPTSearchView*)searchView didStartToOpenFromPoint:(CGPoint)point;
- (void)searchView:(RPTSearchView*)searchView didStartToCloseFromPoint:(CGPoint)point;
@end

@interface RPTSearchView : UIView <UITableViewDataSource, UITableViewDelegate> {
    CGRect origFrame;
}
@property (nonatomic, retain) NSArray *aryContent;
@property (nonatomic, retain, readonly) UIView *contentView;
@property (nonatomic, retain, readonly) UITableView *tableView;
@property (nonatomic, retain, readonly) UIVisualEffectView *blurView;
@property (nonatomic, readonly) BOOL open;
@property (nonatomic, retain) id<RPTSearchViewDelegate> delegate;
- (void)openAnimated:(BOOL)animated;
- (void)closeAnimated:(BOOL)animated;
@end
