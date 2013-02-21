//
//  FormTableController.h
//  TableWithTextField
//
//  Created by Andrew Lim on 4/15/11.
#import <UIKit/UIKit.h>

@interface FormTableController : UITableView<UITextFieldDelegate> {
	NSString* name_ ;
	NSString* address_ ;
	NSString* password_ ;
	NSString* description_ ;	
	
	UITextField* nameField_ ;
	UITextField* addressField_ ;
	UITextField* passwordField_ ;
	UITextField* descriptionField_ ;	
}

// Creates a textfield with the specified text and placeholder text
-(UITextField*) makeTextField: (NSString*)text	
                  placeholder: (NSString*)placeholder  ;

// Handles UIControlEventEditingDidEndOnExit
- (IBAction)textFieldFinished:(id)sender ;

@property (nonatomic,copy) NSString* name ;
@property (nonatomic,copy) NSString* address ;
@property (nonatomic,copy) NSString* password ;
@property (nonatomic,copy) NSString* description ;

@end
