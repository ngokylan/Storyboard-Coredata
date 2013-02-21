//
//  FormTableController.m
//  TableWithTextField
//
//  Created by Andrew Lim on 4/15/11.
#import "FormTableController.h"

@implementation FormTableController
@synthesize name = name_ ;
@synthesize address = address_ ;
@synthesize password = password_ ;
@synthesize description = description_ ;

#pragma mark -
#pragma mark Initialization

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
	
	self.name        = @"" ;
	self.address     = @"" ;
	self.password    = @"" ;
	self.description = @"" ;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return 4;
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
			cell.textLabel.text = @"Name" ;
			tf = nameField_ = [self makeTextField:self.name placeholder:@"John Appleseed"];
			[cell addSubview:nameField_];
			break ;
		}
		case 1: {
			cell.textLabel.text = @"Address" ;
			tf = addressField_ = [self makeTextField:self.address placeholder:@"example@gmail.com"];
			[cell addSubview:addressField_];
			break ;
		}		
		case 2: {
			cell.textLabel.text = @"Password" ;
			tf = passwordField_ = [self makeTextField:self.password placeholder:@"Required"];
			[cell addSubview:passwordField_];
			break ;
		}	
		case 3: {
			cell.textLabel.text = @"Description" ;
			tf = descriptionField_ = [self makeTextField:self.description placeholder:@"My Gmail Account"];
			[cell addSubview:descriptionField_];
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

#pragma mark -
#pragma mark Table view delegate

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

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

// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
    // [sender resignFirstResponder];
}

// Textfield value changed, store the new value.
- (void)textFieldDidEndEditing:(UITextField *)textField {
	if ( textField == nameField_ ) {
		self.name = textField.text ;
	} else if ( textField == addressField_ ) {
		self.address = textField.text ;
	} else if ( textField == passwordField_ ) {
		self.password = textField.text ;
	} else if ( textField == descriptionField_ ) {
		self.description = textField.text ;		
	}
}

@end

