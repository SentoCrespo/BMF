//
//  ExampleEditViewController.m
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 04/04/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import "ExampleEditViewController.h"

#import "BMFBackgroundTapStopsEditingBehavior.h"

@interface ExampleEditViewController ()

@end

@implementation ExampleEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	BMFBackgroundTapStopsEditingBehavior *behavior = [BMFBackgroundTapStopsEditingBehavior new];
	[self addBehavior:behavior];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
