//
//  FlipsideViewController.h
//  Storyboard Coredata
//
//  Created by Ngo Ky on 5/11/12.
//  Copyright (c) 2012 Ngo Ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (assign, nonatomic) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
