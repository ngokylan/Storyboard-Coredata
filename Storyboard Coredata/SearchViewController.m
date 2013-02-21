//
//  SearchViewController.m
//  Storyboard Coredata
//
//  Created by Ngo Ky on 5/11/12.
//  Copyright (c) 2012 Ngo Ky. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"
#import "DetailStaffView.h"

@interface SearchViewController ()
{
    NSManagedObjectContext *context;
}

@end

@implementation SearchViewController

@synthesize theSearchBar;
@synthesize theTableView1;
@synthesize tableData;
@synthesize disableViewOverlay;
@synthesize navController;

//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//{
//    self.navController = [[UINavigationController alloc] initWithRootViewController:self.navController];
//    
//    [self.navController.navigationBar setBarStyle:UIBarStyleBlack];
//    
//    [self.view addSubview:self.navController.view];
//    return YES;
//}
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
    
    self.tableData = [[NSMutableArray alloc]init];
    self.disableViewOverlay = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, 416.0f)];
    self.disableViewOverlay.alpha = 0;
    //Initialize the copy array.
	copyTableData = [[NSMutableArray alloc] init];
    
    searching = NO;
	letUserSelectRow = YES;
    
    //assign searchbar delegate
    self.theSearchBar.delegate = self;
    
    //set the delegate to the table view
    
    [[self theTableView1] setDelegate:self];
    [[self theTableView1] setDataSource:self];
    
    //[self.theSearchBar]
    deactiveSearch = FALSE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-----------------------Tableview process---------------------------------------

//set editable mode for tableview
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"Do somthing");
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [tableData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    id currentObj = [tableData objectAtIndex:indexPath.row];
    NSString *displayText = [NSString stringWithFormat:@"%@ %@",[currentObj valueForKey:@"firstname"], [currentObj valueForKey:@"lastname"]];
    
    cell.textLabel.text =  displayText;
    
    //Setting the accessory cell
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

// Deselect the current table row selection
- (void) deselect {
	[self.theTableView1 deselectRowAtIndexPath:[self.theTableView1 indexPathForSelectedRow] animated:YES];
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
        NSString *selectedFirstname = [NSString stringWithFormat:@"%@",[currentObj valueForKey:@"firstname"]];
        NSString *selectedLastname = [NSString stringWithFormat:@"%@",[currentObj valueForKey:@"lastname"]];
        NSString *selectedEmail = [NSString stringWithFormat:@"%@",[currentObj valueForKey:@"email"]];
        
        DetailStaffView *staffDetailController = [[DetailStaffView alloc] initWithNibName:@"DetailStaffView" bundle:nil];
        //pass data
        staffDetailController.selectedEmail = selectedEmail;
        staffDetailController.selectedFirstname = selectedFirstname;
        staffDetailController.selectedLastname = selectedLastname;
        
        UINavigationController *aNavigationController = [[UINavigationController alloc] init];
        
        //[aNavigationController pushViewController:staffDetailController animated:YES];
        [self presentModalViewController:staffDetailController animated:YES];
        //    [[self navigationController] presentModalViewController:aNavigationController animated:YES];
        
        [staffDetailController release];
        [aNavigationController release];

    }
    else {
        // do want you want in edit mode
    }
    
}

//-----------------------End Tableview process---------------------------------------


//-----------------------Search process---------------------------------------
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
    self.theTableView1.allowsSelection = !active;
    self.theTableView1.scrollEnabled = !active;
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
        NSIndexPath *selected = [self.theTableView1 indexPathForSelectedRow];
        if(selected){
            [self.theTableView1 deselectRowAtIndexPath:selected animated:NO];
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
        [theTableView1 reloadData];

    }
    else{   //search result > 0
        [theTableView1 reloadData];
    }
    
    //handle search bar
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.theTableView1.allowsSelection = YES;
    self.theTableView1.scrollEnabled = YES;
    
    //[theAlert release];

}

- (void) doneSearching_Clicked:(id)sender {
	
	theSearchBar.text = @"";
	[theSearchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.rightBarButtonItem = nil;
	self.theTableView1.scrollEnabled = YES;
	
	[disableViewOverlay removeFromSuperview];
	[disableViewOverlay release];
	disableViewOverlay = nil;
	
	[self.theTableView1 reloadData];
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

//-----------------------End Search process---------------------------------------
- (void)dealloc {
    [theSearchBar release];
    [theTableView1 release];
    [tableData release];
    [disableViewOverlay release];
    [super dealloc];
}

//edit tableview
- (IBAction)btnNavEdit:(id)sender {
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}
@end
