//
//  RDContainerViewController.m
//  HelloWorld
//
//  Created by Donelle Sanders Jr on 12/14/13.
//  Copyright (c) 2013 Donelle Sanders Jr. All rights reserved.
//

#import "RDContainerViewController.h"

@interface RDContainerViewController ()

@end

@implementation RDContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIViewController * viewController = nil;
    
	switch (self.sampleViewType) {
        case RDSampleViewTypeSimple:
            NSLog(@"Simple Example");
            viewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SimpleViewController"];
            break;
            
        case RDSampleViewTypeCustom:
            NSLog(@"Custom Example");
            viewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"CustomViewController"];
            break;
            
        case RDSampleViewTypeMail:
            NSLog(@"Mail Example");
            viewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"MailViewController"];
            break;
            
        default:
            break;
    }
    
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    [self.view addSubview:viewController.view];
}

@end
