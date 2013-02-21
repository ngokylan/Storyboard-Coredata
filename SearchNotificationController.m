//
//  SearchNotificationController.m
//  Storyboard Coredata
//
//  Created by Ngo Ky on 8/11/12.
//  Copyright (c) 2012 Ngo Ky. All rights reserved.
//

#import "SearchNotificationController.h"
#import "AppDelegate.h"
#import "DetailNotificationView.h"
#import "EGORefreshTableHeaderView.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "XMLParser.h"

@interface SearchNotificationController ()
{
    NSManagedObjectContext *context;
}
-(void)fetchFinish:(ASIHTTPRequest *)request;
-(void)fetchFail:(ASIHTTPRequest *)request;
@end

@implementation SearchNotificationController

@synthesize theSearchBar;
@synthesize theTableView;
@synthesize tableData;
@synthesize navController;
@synthesize disableViewOverlay;
@synthesize tempDir;

XMLParser *xmlParser;
CGRect dateFrame;
UILabel *dateLabel;
CGRect contentFrame;
UILabel *contentLabel;



//////////////////end refresh tableview/////////////////////////////////////////////////


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //initial app delegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
       //Initialize the copy array.
	copyTableData = [[NSMutableArray alloc] init];
    
    searching = NO;
	letUserSelectRow = YES;
    
    //assign searchbar delegate
    self.theSearchBar.delegate = self;
    
    //set the delegate to the table view

    [[self theTableView] setDelegate:self];
    [[self theTableView] setDataSource:self];
    
    //[self.theSearchBar]
    deactiveSearch = FALSE;
    
    //--------------refresh table header----------------
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *aView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.theTableView.bounds.size.height, self.theTableView.frame.size.width, self.theTableView.bounds.size.height)];
		aView.delegate = self;
		[self.theTableView addSubview:aView];
		_refreshHeaderView = aView;
		[aView release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    //notification observer network connection
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called.
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifier];
	[self updateInterfaceWithReachability: internetReach];
    
    //load table data from SQLlite
    [self loadTableData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [navController release];
    [theTableView release];
    [disableViewOverlay release];
    [_refreshHeaderView release];
    [super dealloc];
}
- (void)viewDidUnload {
	_refreshHeaderView=nil;
}

#pragma Start Pull Down Refresh tableview code

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
}

- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.theTableView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

//start dowloading
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
//------this method is to call refresh event occur

-(void)loadXML{
    //start load XML from server
	xmlParser = [[XMLParser alloc] loadXMLByURL:@"http://ibinhire.zzl.org/minh.xml"];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	//[self reloadTableViewDataSource];
    [self performSelectorOnMainThread:@selector(loadXML) withObject:nil waitUntilDone:YES];
	//[self performSelector:@selector(loadXML) withObject:nil afterDelay:3.0];
    
    //update tableview datasource
    self.tableData = [xmlParser notifications];
    
    //read and download attach files from XMLfile
    NSLog(@"%@",[xmlParser notifications]);
    [self dowload];
    
    //call reload data
    [self.theTableView reloadData];

}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma UITable process
//***********--------------------------------------------------------------
//***********--------------

-(void)loadTableData{
    //handle searching NSObjects
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Notification" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title like \"*\""];
    [request setPredicate:predicate];
    
    NSError *error;
    tableData = [[context executeFetchRequest:request error:&error] mutableCopy];
    
    UIAlertView *theAlert;
    
    if(tableData.count > 0)
    {
        [theTableView reloadData];
    }
    
    //handle search bar
    [theSearchBar setShowsCancelButton:NO animated:YES];
    [theSearchBar resignFirstResponder];
    self.theTableView.allowsSelection = YES;
    self.theTableView.scrollEnabled = YES;
    
    //assign XParser notifications array with tableview data
    xmlParser.notifications = tableData;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 55;
}

//set editable mode for tableview
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"Do something");
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if([[xmlParser notifications] count] > 0 )
    {
        return [[xmlParser notifications] count];
    }
    else{
        return [tableData count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Notification *notification = [[xmlParser notifications] objectAtIndex:indexPath.row];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
        CGRect contentFrame = CGRectMake(45, 2, 265, 30);
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:contentFrame];
        contentLabel.tag = 0011;
        contentLabel.numberOfLines = 2;
        contentLabel.font = [UIFont boldSystemFontOfSize:12];
        [cell.contentView addSubview:contentLabel];
        
        CGRect dateFrame = CGRectMake(45, 40, 265, 10);
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:dateFrame];
        dateLabel.tag = 0012;
        dateLabel.font = [UIFont systemFontOfSize:10];
        [cell.contentView addSubview:dateLabel];

    }
    id currentObj = [tableData objectAtIndex:indexPath.row];
    NSString *displayContentText = [NSString stringWithFormat:@"%@",[currentObj valueForKey:@"title"]];
    
    NSString *displayDate= [NSString stringWithFormat:@"%@",[currentObj valueForKey:@"date"]];
    
    UILabel *contentLabel = (UILabel *)[cell.contentView viewWithTag:0011];
    contentLabel.text = displayContentText;
	
	UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:0012];
    dateLabel.text = displayDate;
	
    
    //Setting the accessory cell
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

// Deselect the current table row selection
- (void) deselect {
	[self.theTableView deselectRowAtIndexPath:[self.theTableView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

//catch select event
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.editing) {
        // do want you in 'normal' mode
        
        //Get the selected staff
        id currentObj = [tableData objectAtIndex:indexPath.row];
        NSString *selectedDate = [NSString stringWithFormat:@"%@",[currentObj valueForKey:@"date"]];
        NSString *selectedTitle = [NSString stringWithFormat:@"%@",[currentObj valueForKey:@"title"]];
        NSString *selectedDesc = [NSString stringWithFormat:@"%@",[currentObj valueForKey:@"description"]];
        NSString *selectedStaffID= [NSString stringWithFormat:@"%@",[currentObj valueForKey:@"staff_id"]];
         NSString *selectedAttachFile  = [NSString stringWithFormat:@"%@",[currentObj valueForKey:@"attach"]];
        
        DetailNotificationView *notificationController = [[DetailNotificationView alloc] initWithNibName:@"DetailNotificationView" bundle:nil];
        //pass data
        notificationController.date = selectedDate;
        notificationController.title = selectedTitle;
        notificationController.desc = selectedDesc;
        notificationController.staff_id = selectedStaffID;
        notificationController.attachFileLink = selectedAttachFile;
        
        UINavigationController *aNavigationController = [[UINavigationController alloc] init];
        
        //[aNavigationController pushViewController:staffDetailController animated:YES];
        [self presentModalViewController:notificationController animated:YES];
        //    [[self navigationController] presentModalViewController:aNavigationController animated:YES];
        
        [notificationController release];
        [aNavigationController release];
        
    }
    else {
        // do want you want in edit mode
    }
    
}

#pragma Minh - handle ASIHTTPRequet  -------------------------------------------------------------
//check exist file
-(BOOL)fileExist:(NSString*)filename{
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    BOOL exist;
    if ([filemgr fileExistsAtPath: filename ] == YES)
        exist = TRUE;
    else
        exist = FALSE;
    [filemgr release];
    
    return exist;
}

//dowload
-(void)dowload
{
    if(!networkQueue)
    {
        networkQueue = [[ASINetworkQueue alloc] init];
    }
    [networkQueue reset];
    [networkQueue setRequestDidFailSelector:@selector(fetchFail:)];
    [networkQueue setRequestDidFinishSelector:@selector(fetchFinish:)];
    [networkQueue setQueueDidFinishSelector:@selector(queuefinish)];
    [networkQueue setShowAccurateProgress:YES];
    [networkQueue setDelegate:self];
    
    //get array files to download
    id currentObj = nil;
    NSString *attachFileLink = nil;
    for(int i = 0; i < [tableData count]; i++)
    {
        currentObj = [tableData objectAtIndex:i];
        attachFileLink = [NSString stringWithFormat:@"%@",[currentObj valueForKey:@"attach"]];
        if(![attachFileLink isEqualToString:@"(null)"] && attachFileLink != nil && attachFileLink != ( NSString *) [ NSNull null ])
        {
            NSLog(@"%@",attachFileLink);
            //call download function
            
            //Change the host name here to change the server your monitoring
            hostReach = [[Reachability reachabilityWithHostName: attachFileLink] retain];
            [hostReach startNotifier];

            //path
            NSString *filename = [attachFileLink lastPathComponent];
            NSString *dowloadPath =
            [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:filename];
            
            //call function to validate file exist
            if([self fileExist:dowloadPath] == TRUE)
            {
                NSLog(@"File exist");
            }
            else{
                tempDir = dowloadPath;
                NSString *tempFilePath = [tempDir stringByAppendingPathExtension:@"download"];
                
                //download request
                ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:attachFileLink]] autorelease];
                [request setDownloadDestinationPath:dowloadPath];
                [request setTemporaryFileDownloadPath:tempFilePath];
                [request setAllowResumeForFileDownloads:YES];
                [request setUserInfo:[NSDictionary dictionaryWithObject:@"request1" forKey:@"name"]];
                //[request startAsynchronous];
                
                [networkQueue addOperation:request];
            }
        }
    }
    //call network queue to start download entire file
    [networkQueue go];
}

-(void)fetchFail:(ASIHTTPRequest *) request
{
    //display AlertView
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Download" message:@"Fail to Dowload Attach Files" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [theAlert show];
    
    [theAlert autorelease];
}

-(void)fetchFinish:(ASIHTTPRequest *) request
{
    //delete temporary file
    NSString *extension = @"pdf.download";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *documentsDirectory = tempDir;
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        if ([[filename pathExtension] isEqualToString:extension]) {
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
            NSLog(@"Tempt file deleted");
        }
    }
    
    //
}

//all download queues are finished
-(void)queuefinish{
    //[theTimer invalidate];
    NSLog(@"Simulated operation finished!");
    
    //display AlertView
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Download" message:@"Dowload Completed" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [theAlert show];
    
    [theAlert autorelease];
}

//display connection error AlertView
-(void) displayConnErr: (Reachability*) curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired= [curReach connectionRequired];
    NSString* statusString= @"";
    UIAlertView *theAlert = NULL;
    
    if(connectionRequired)
    {
        statusString= [NSString stringWithFormat: @"%@No internet Connection.", statusString];
        //display AlertView
        theAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:statusString delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [theAlert show];
    }
    [theAlert release];
}


//Update interface with Reachability
- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    if(curReach == hostReach)
	{
		[self displayConnErr: curReach];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        BOOL connectionRequired= [curReach connectionRequired];
        
        NSString* baseLabel=  @"";
        if(connectionRequired)
        {
            baseLabel=  @"Connection fail!";
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:baseLabel delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [theAlert show];
            [theAlert release];
            
        }
    }
	if(curReach == internetReach)
	{
		[self displayConnErr: curReach];
	}
	if(curReach == wifiReach)
	{
		[self displayConnErr: curReach];
	}
	
}

- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability: curReach];
}


//*********-----------------------------------------------------------------------
//*********


#pragma Minh - handle uisearch bar -------------------------------------------------------------

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    // If you wanted to display results as the user types
    // you would do that here.
}
- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar2 {
	
	//This method is called again when the user clicks back from teh detail view.
	//So the overlay is displayed on the results, which is something we do not want to happen.
    [[self theSearchBar] becomeFirstResponder];
	[self searchBar:theSearchBar2 activate:YES];
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text=@"";
    [self searchBar:searchBar activate:NO];
}
-(void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active{
    self.theTableView.allowsSelection = !active;
    self.theTableView.scrollEnabled = !active;
    if (!active) {
        [disableViewOverlay removeFromSuperview];
        [searchBar resignFirstResponder];
    } else {
        [self.view addSubview:self.disableViewOverlay];
        
        [UIView beginAnimations:@"FadeIn" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView commitAnimations];
        
        // probably not needed if you have a details view since you
        // will go there on selection
        NSIndexPath *selected = [self.theTableView indexPathForSelectedRow];
        if(selected){
            [self.theTableView deselectRowAtIndexPath:selected animated:NO];
        }
    }
    [searchBar setShowsCancelButton:active animated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //handle searching NSObjects
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Staff" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstname like %@", self.theSearchBar.text];
    [request setPredicate:predicate];
    
    NSError *error;
    tableData = [[context executeFetchRequest:request error:&error] mutableCopy];
    
    UIAlertView *theAlert;
    
    if(tableData.count <= 0)
    {
        NSString *message = [NSString stringWithFormat:@"No Person with \"%@\" first name",self.theSearchBar.text];
        theAlert = [[UIAlertView alloc] initWithTitle:@"Search Result" message:message delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [theAlert show];
        [theAlert release];
        
        //clear tableview data
        tableData = nil;
        [theTableView reloadData];
        
    }
    else{   //search result > 0
        [theTableView reloadData];
    }
    
    //handle search bar
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.theTableView.allowsSelection = YES;
    self.theTableView.scrollEnabled = YES;
    
    //[theAlert release];
    
}

- (void) doneSearching_Clicked:(id)sender {
	
	theSearchBar.text = @"";
	[theSearchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.rightBarButtonItem = nil;
	self.theTableView.scrollEnabled = YES;
	
	[disableViewOverlay removeFromSuperview];
	[disableViewOverlay release];
	disableViewOverlay = nil;
	
	[self.theTableView reloadData];
}

//this important otherwise, the keyboard will be stucked and not display in next time
//open this view
- (BOOL)Searchbar2ShouldReturn:(UISearchBar *)searchBar2 {
    
    [theSearchBar becomeFirstResponder];
    
    return YES;
    
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    deactiveSearch = TRUE;
    [self performSelector:@selector(searchBarCancelButtonClicked:) withObject:theSearchBar];
    
}


@end
