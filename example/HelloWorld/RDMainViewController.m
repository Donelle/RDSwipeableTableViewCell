//
//  RDMainViewController.m
//  HelloWorld
//
//  Created by Donelle Sanders Jr on 12/14/13.
//  Copyright (c) 2013 Donelle Sanders Jr. All rights reserved.
//

#import "RDMainViewController.h"
#import "RDContainerViewController.h"
#import "RDGlobal.h"

@implementation RDMainViewController
{
    NSMutableArray * _sampleViews;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _sampleViews = [NSMutableArray arrayWithObjects:@"Simple Cell Example",
                                                    @"Custom Cell Example",
                                                    @"Mail App Example", nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sampleViews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [_sampleViews objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ShowSampleView" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RDContainerViewController * sampleViewController = [segue destinationViewController];
    sampleViewController.sampleViewType = (RDSampleViewType)[[self.tableView indexPathForSelectedRow] row] + 1;
}

@end
