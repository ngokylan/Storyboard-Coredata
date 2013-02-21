//
//  AddStaffViewController.m
//  Storyboard Coredata
//
//  Created by Ngo Ky on 6/11/12.
//  Copyright (c) 2012 Ngo Ky. All rights reserved.
//

#import "AddStaffViewController.h"
#import "FormTableController.h"
#import "AppDelegate.h"

@interface AddStaffViewController (){
    NSManagedObjectContext *context;
}

@end

@implementation AddStaffViewController
@synthesize tableView;
@synthesize firstname = firstname_;
@synthesize lastname = lastname_;
@synthesize msg = msg_;

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
    
	self.firstname        = @"" ;
	self.lastname     = @"" ;
	self.email    = @"" ;
	staffid = @"" ;
    self.msg = @"";
    
    [[self tableView] setDelegate:self];
    [[self tableView] setDataSource:self];
    
    //initial app delegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [tableView release];
    [super dealloc];
}


#pragma mark Minh Custome tableView Appearance
///////////////////////////////////////////////////////////////
///tableview custom appearance
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section == 0)
        return 3;
    if(section == 1)
        return 1;
    if(section == 2)
        return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    
    // Make cell unselectable
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section)
    {
        case 0:{   // first section in table
            UITextField* tf = nil ;
            
            switch ( indexPath.row ) {
                case 0: {
                    cell.textLabel.text = @"First Name" ;
                    tf = firstnameField = [self makeTextField:self.firstname placeholder:@"John"];
                    [cell addSubview:firstnameField];
                    break ;
                }
                case 1: {
                    cell.textLabel.text = @"Last Name" ;
                    tf = lastnameField = [self makeTextField:self.lastname placeholder:@"Appleed"];
                    [cell addSubview:lastnameField];
                    break ;
                }
                case 2: {
                    cell.textLabel.text = @"Email" ;
                    tf = emailField = [self makeTextField:self.email placeholder:@"example@gmail.com"];
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
            
            break;
        }
        case 1: {   //second section in table for display submit button
            UIButton *btn = nil;
            cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
            CGPoint centerPoint = CGPointMake([cell bounds].size.width / 2.0, [cell bounds].size.height / 2.0);
            switch ( indexPath.row ) {
                case 0: {
                    btn  = [self makeButton:@"Add" centerpoint:&centerPoint];
                    [cell addSubview:btn];
                    break ;
                }
            }
            break;
        }
        case 2:{    //third section in table for display submit resul
            UILabel *lbl = nil;
            cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
            CGPoint centerPoint = CGPointMake([cell bounds].size.width / 2.0, [cell bounds].size.height / 2.0);
            switch ( indexPath.row ) {
                case 0: {
                    lbl  = [self makeLabel:@"" centerPoint:&centerPoint];
                    [cell addSubview:lbl];
                    break ;
                }
            }

            break;
        }
        default:
            break;
    } 
    return cell;
}

-(UILabel*)makeLabel:(NSString*)text centerPoint:(CGPoint *)point{
    UILabel *label =  [[UILabel alloc] initWithFrame: CGRectMake(20, 20, 200, 44)];
    label.text = text;
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [label setCenter:*point];
    return  label;
}

#pragma mark Minh - make text field in table cell
-(UITextField*) makeTextField: (NSString*)text
                  placeholder: (NSString*)placeholder  {
	UITextField *tf = [[[UITextField alloc] init] autorelease];
	tf.placeholder = placeholder ;
	tf.text = text ;
	tf.autocorrectionType = UITextAutocorrectionTypeNo ;
	tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
	tf.adjustsFontSizeToFitWidth = YES;
	tf.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
	return tf ;
}

#pragma mark Minh - make button in table cell
-(UIButton* ) makeButton: (NSString *)text centerpoint:(CGPoint*) point{
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    myButton.frame = CGRectMake(20, 20, 200, 44); // position in the parent view and set the size of the button
    [myButton setTitle:text forState:UIControlStateNormal];
    // add targets and actions
    [myButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [myButton setCenter:*point];
    return myButton;
}

#pragma mark Minh - catch button clicked event at button in table cell
-(IBAction)buttonClicked:(id)sender{
    //check duplicate insert by searching in current database
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Staff" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email = %@", self.email];
    [request setPredicate:predicate];
    
    NSError *error;
    NSMutableArray *matchingArr = [[context executeFetchRequest:request error:&error] mutableCopy];
    
    UIAlertView *theAlert;
    
    if(matchingArr.count > 0)
    {
        NSString *message = [NSString stringWithFormat:@"\"%@\" already existed!",self.email];
        theAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [theAlert show];
        [theAlert release];
    }
    else{   // insert if not exist in database
        NSManagedObject *newPerson = [[NSManagedObject alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:context];
        
        //initial unique staff id
        NSDate *currentTime = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYYMMDDhhmm"];
        NSString *staffid = [[NSString alloc] initWithFormat:@"%@",[dateFormatter stringFromDate: currentTime]];
        
        [newPerson setValue:staffid forKey:@"staff_id"];
        [newPerson setValue:self.firstname forKey:@"firstname"];
        [newPerson setValue:self.lastname forKey:@"lastname"];
        [newPerson setValue:self.email forKey:@"email"];
        
        NSLog(@"%@ %@ %@ %@",staffid, self.firstname, self.lastname, self.email);
        
        NSError *error;
        [context save:&error];
        
        firstnameField.text = @"";
        lastnameField.text = @"";
        emailField.text = @"";
        
        NSString *message = [NSString stringWithFormat:@"Staff Added",self.email];
        theAlert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [theAlert show];
        [theAlert release];

    }
}

// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
    // [sender resignFirstResponder];
}

// Textfield value changed, store the new value.
- (void)textFieldDidEndEditing:(UITextField *)textField {
	if ( textField == firstnameField ) {
		self.firstname = textField.text ;
	} else if ( textField == lastnameField ) {
		self.lastname = textField.text ;
	} else if ( textField == emailField ) {
		self.email = textField.text ;
	}
    self.msg = displayMsg.text;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

@end
