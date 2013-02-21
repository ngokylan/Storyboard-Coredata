//
//  DetailStaffView.h
//  Storyboard Coredata
//
//  Created by Ngo Ky on 7/11/12.
//  Copyright (c) 2012 Ngo Ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface DetailStaffView : UIViewController<MFMailComposeViewControllerDelegate>{
    NSString *selectedFirstname;
    NSString *selectedLastname;
    NSString *selectedEmail;
    
    UITextField* firstnameField;
	UITextField* lastnameField ;
	UITextField* emailField ;
}

@property (nonatomic, retain) NSString *selectedFirstname;
@property (nonatomic, retain) NSString *selectedLastname;
@property (nonatomic, retain) NSString *selectedEmail;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UINavigationBar *vController;
- (IBAction)btnDone:(id)sender;
- (IBAction)btnMailto:(id)sender;


@end
