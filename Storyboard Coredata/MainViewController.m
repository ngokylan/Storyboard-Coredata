//
//  MainViewController.m
//  Storyboard Coredata
//
//  Created by Ngo Ky on 5/11/12.
//  Copyright (c) 2012 Ngo Ky. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

@interface MainViewController (){
    NSManagedObjectContext *context;
}

@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[self firstnameTextField] setDelegate:self];
    [[self lastnameTextField] setDelegate:self];
    
    //initial app delegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

- (void)dealloc
{
    [_managedObjectContext release];
    [_firstnameTextField release];
    [_lastnameTextField release];
    [_displayLabel release];
    [super dealloc];
}

- (IBAction)AddPerson:(id)sender {
    NSEntityDescription *entittyDesc = [NSEntityDescription entityForName:@"Staff" inManagedObjectContext:context];
    NSManagedObject *newPerson = [[NSManagedObject alloc] initWithEntity:entittyDesc insertIntoManagedObjectContext:context];
    
    [newPerson setValue:self.firstnameTextField.text forKey:@"firstname"];
    [newPerson setValue:self.lastnameTextField.text forKey:@"lastname"];
    
    NSError *error;
    [context save:&error];
    
    self.displayLabel.text = @"Staff Added";
    
    self.firstnameTextField.text = @"";
    self.lastnameTextField.text = @"";
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
@end
