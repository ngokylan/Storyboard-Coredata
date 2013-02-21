//
//  SearchViewController.h
//  Storyboard Coredata
//
//  Created by Ngo Ky on 5/11/12.
//  Copyright (c) 2012 Ngo Ky. All rights reserved.
//

#import "FlipsideViewController.h"
#import <CoreData/CoreData.h>

@class SearchViewController;

@protocol SearchViewControllerDelegate<UISearchBarDelegate>
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface SearchViewController : FlipsideViewController<UISearchBarDelegate, UITableViewDataSource>{
    NSMutableArray *tableData;
    NSMutableArray *copyTableData;
    
   // UIView *disableViewOverlay;
    
    //UITableView *theTableView;
    //UISearchBar *theSearchBar;
    
    BOOL searching;
	BOOL letUserSelectRow;
    BOOL deactiveSearch;
}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (assign, nonatomic) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)btnNavEdit:(id)sender;
@property (retain, nonatomic) IBOutlet UISearchBar *theSearchBar;
@property (retain, nonatomic) IBOutlet UITableView *theTableView1;

@property (retain) NSMutableArray *tableData;
@property(retain, nonatomic) UIView *disableViewOverlay;

@property (retain, nonatomic) UINavigationController *navController;
@end
