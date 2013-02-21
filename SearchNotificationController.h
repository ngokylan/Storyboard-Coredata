//
//  SearchNotificationController.h
//  Storyboard Coredata
//
//  Created by Ngo Ky on 8/11/12.
//  Copyright (c) 2012 Ngo Ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EGORefreshTableHeaderView.h"
#import "Reachability.h"
#import "Notification.h"
#import "XMLParser.h"

@class ASINetworkQueue;

@interface SearchNotificationController : UIViewController<EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *tableData;
    NSMutableArray *copyTableData;
    
    UIView *view;
    UIView *disableViewOverlay;
    
    UITableView *theTableView;
    UISearchBar *theSearchBar;
    
    BOOL searching;
	BOOL letUserSelectRow;
    BOOL deactiveSearch;
    
    //refresh table header
    EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;
    
    //http request
    ASINetworkQueue *networkQueue;
    
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
    UISwitch *accurateProgess;
}
@property (retain) UIActivityIndicatorView *indicatorView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)btnNavEdit:(id)sender;

@property (retain, nonatomic) IBOutlet UINavigationBar *navController;
@property (retain, nonatomic) IBOutlet UISearchBar *theSearchBar;

@property (retain) NSMutableArray *tableData;
@property(retain, nonatomic) UIView *disableViewOverlay;
@property(retain, nonatomic) UIView *view;

@property (retain, nonatomic) IBOutlet UITableView *theTableView;
@property (retain, nonatomic) NSString *tempDir;

//refresh table header method
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
