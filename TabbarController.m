//
//  TabbarController.m
//  Storyboard Coredata
//
//  Created by Ngo Ky on 7/11/12.
//  Copyright (c) 2012 Ngo Ky. All rights reserved.
//

#import "TabbarController.h"
#import "AppDelegate.h"

@interface TabbarController ()
{
    NSManagedObjectContext *context;
}

@end

@implementation TabbarController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
