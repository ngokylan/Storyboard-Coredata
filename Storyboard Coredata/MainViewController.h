//
//  MainViewController.h
//  Storyboard Coredata
//
//  Created by Ngo Ky on 5/11/12.
//  Copyright (c) 2012 Ngo Ky. All rights reserved.
//

#import "FlipsideViewController.h"

#import <CoreData/CoreData.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
