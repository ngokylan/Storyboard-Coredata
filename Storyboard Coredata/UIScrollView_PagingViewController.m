//
//  UIScrollView_PagingViewController.m
//  UIScrollView-Paging
//
//  Created by Costa Walcott on 3/2/11.
//  Copyright 2011 Draconis Software. All rights reserved.
//

#import "UIScrollView_PagingViewController.h"

@implementation UIScrollView_PagingViewController


@synthesize scrollView, pageControl;
@synthesize firstView,secondView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	pageControlBeingUsed = NO;
    
    UIViewController *firstview1 = [[UIViewController alloc] initWithNibName:@"UIScrollView_PagingViewController2" bundle:nil];
        
    UIViewController *secondView1 = [[UIViewController alloc] initWithNibName:@"UIScrollView_PagingViewController3" bundle:nil];

	
	NSArray *colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], nil];
	
	CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * 0;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    
    UIView *subview1 = [[UIView alloc] initWithFrame:frame];
    //subview.backgroundColor = [colors objectAtIndex:i];
    [subview1 addSubview:firstview1.view];
    [self.scrollView addSubview:subview1];
    [subview1 release];
    
    CGRect frame2;
    frame.origin.x = self.scrollView.frame.size.width * 1;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    
    UIView *subview2 = [[UIView alloc] initWithFrame:frame];
    //subview.backgroundColor = [colors objectAtIndex:i];
    [subview2 addSubview:secondView1.view];
    [self.scrollView addSubview:subview2];
    [subview2 release];
	
	
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 2, 600);
	
	self.pageControl.currentPage = 0;
	self.pageControl.numberOfPages = 2;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (!pageControlBeingUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = self.scrollView.frame.size.width;
		int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControl.currentPage = page;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (IBAction)changePage {
	// Update the scroll view to the appropriate page
	CGRect frame;
	frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
	frame.origin.y = 0;
	frame.size = self.scrollView.frame.size;
	[self.scrollView scrollRectToVisible:frame animated:YES];
	
	// Keep track of when scrolls happen in response to the page control
	// value changing. If we don't do this, a noticeable "flashing" occurs
	// as the the scroll delegate will temporarily switch back the page
	// number.
	pageControlBeingUsed = YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.scrollView = nil;
	self.pageControl = nil;
}


- (void)dealloc {
	[scrollView release];
	[pageControl release];
    [firstView release];
    [secondView release];
    [super dealloc];
}

@end
