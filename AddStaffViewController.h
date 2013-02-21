//
//  AddStaffViewController.h
//  Storyboard Coredata
//
//  Created by Ngo Ky on 6/11/12.
//  Copyright (c) 2012 Ngo Ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AddStaffViewController : UIViewController<UITableViewDelegate>
{
	NSString* firstname_ ;
	NSString* lastname_ ;
	NSString* staffid;
	NSString* email_ ;
    
    NSString* msg_;  //provide feedback when insert action done
	
	UITextField* firstnameField;
	UITextField* lastnameField ;
	UITextField* emailField ;
    
    UILabel* displayMsg;
}

// Creates a textfield with the specified text and placeholder text
-(UITextField*) makeTextField: (NSString*)text
                  placeholder: (NSString*)placeholder  ;

// Handles UIControlEventEditingDidEndOnExit
- (IBAction)textFieldFinished:(id)sender ;

@property (nonatomic,copy) NSString* firstname ;
@property (nonatomic,copy) NSString* lastname ;
@property (nonatomic,copy) NSString* email ;
@property (nonatomic,copy) NSString* msg ;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
