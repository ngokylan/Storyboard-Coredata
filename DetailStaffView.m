//
//  DetailStaffView.m
//  Storyboard Coredata
//
//  Created by Ngo Ky on 7/11/12.
//  Copyright (c) 2012 Ngo Ky. All rights reserved.
//

#import "DetailStaffView.h"

@interface DetailStaffView ()

@end

@implementation DetailStaffView
@synthesize selectedFirstname;
@synthesize selectedLastname;
@synthesize selectedEmail;
@synthesize vController;

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
    
    //Display the selected staff.
    firstnameField.text = selectedFirstname;
    lastnameField.text = selectedLastname;
    emailField.text = selectedEmail;
    
    [[self tableView] setDelegate:self];
    [[self tableView] setDataSource:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Dealloc method declared in DetailViewController.m
- (void)dealloc {
    [emailField release];
    [firstnameField release];
    [lastnameField release];
    [selectedFirstname release];
    [selectedLastname release];
    [selectedEmail release];
    [_tableView release];
    [_tableView release];
    [vController release];
    [super dealloc];
}

#pragma mark Minh Custome tableView Appearance
///////////////////////////////////////////////////////////////
///tableview custom appearance
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    
    // Make cell unselectable
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
   UITextField* tf = nil ;
            
    switch ( indexPath.row ) {
        case 0: {
            cell.textLabel.text = @"First Name" ;
            tf = firstnameField = [self makeTextField:self.selectedFirstname];
            [cell addSubview:firstnameField];
            break ;
        }
        case 1: {
            cell.textLabel.text = @"Last Name" ;
            tf = lastnameField = [self makeTextField:self.selectedLastname];
            [cell addSubview:lastnameField];
            break ;
        }
        case 2: {
            cell.textLabel.text = @"Email" ;
            tf = emailField = [self makeTextField:self.selectedEmail];
            [cell addSubview:emailField];
            break ;
        }
    }
    // Textfield dimensions
    tf.frame = CGRectMake(120, 12, 170, 30);
    
    // Workaround to dismiss keyboard when Done/Return is tapped
    [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    // We want to handle textFieldDidEndEditing
    tf.delegate = self ;
 
    return cell;
}

#pragma mark Minh - make text field in table cell
-(UITextField*) makeTextField: (NSString*)text  {
	UITextField *tf = [[[UITextField alloc] init] autorelease];
	tf.text = text ;
	tf.autocorrectionType = UITextAutocorrectionTypeNo ;
	tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
	tf.adjustsFontSizeToFitWidth = YES;
	tf.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    tf.enabled = NO;
	return tf ;
}


- (IBAction)btnDone:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btnMailto:(id)sender {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    
    [mailController setMailComposeDelegate:self];
    NSString *email = self.selectedEmail;
    NSArray *emailArray = [[NSArray alloc] initWithObjects:email, nil];
    NSString *message = @"";
    [mailController setMessageBody:message isHTML:YES];
    [mailController setToRecipients:emailArray];
    [mailController setSubject:@"Subject"];
    [self presentViewController:mailController animated:YES completion:nil];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self myTextView] resignFirstResponder];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}@end
