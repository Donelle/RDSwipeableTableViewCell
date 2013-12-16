//
//  RDSimpleViewController.m
//  HelloWorld
//
//  Created by Donelle Sanders Jr on 12/14/13.
//  Copyright (c) 2013 Donelle Sanders Jr. All rights reserved.
//

#import "RDSimpleViewController.h"
#import "RDSwipeableTableViewCell.h"

@interface RDSimpleViewController () <RDSwipeableTableViewCellDelegate>
- (void)didPressClickMe:(id)sender;
@end

@implementation RDSimpleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    RDSwipeableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) cell = [[RDSwipeableTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    
    cell.delegate = self;
    cell.tableView = tableView;
    cell.revealDirection = RDSwipeableTableViewCellRevealDirectionLeft | RDSwipeableTableViewCellRevealDirectionRight;
    cell.revealDistance = 75;
    cell.textLabel.text = @"Swipe from either side to see the hidden view";
    cell.textLabel.numberOfLines = 2;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - RDSwipeableTableViewCellDelegate

- (void)tableView:(UITableView *)tableView willBeginCellSwipe:(RDSwipeableTableViewCell *)cell inDirection:(RDSwipeableTableViewCellRevealDirection)direction
{
    CGRect cellRect = cell.frame;
    if (direction == RDSwipeableTableViewCellRevealDirectionLeft) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(5, 0, 65, cellRect.size.height);
        [button setTitle:@"Click Me" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didPressClickMe:) forControlEvents:UIControlEventTouchUpInside];
        [cell.revealView addSubview:button];
        
        cell.revealView.backgroundColor = [UIColor lightGrayColor];
        
    } else if (direction == RDSwipeableTableViewCellRevealDirectionRight) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(cellRect.size.width - 70, 0, 65, cellRect.size.height);
        [button setTitle:@"Click Me" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didPressClickMe:) forControlEvents:UIControlEventTouchUpInside];
        [cell.revealView addSubview:button];
        
        cell.revealView.backgroundColor = [UIColor redColor];
    }
}

- (void)tableView:(UITableView *)tableView didCellReset:(RDSwipeableTableViewCell *)cell
{
    [cell.revealView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark - UI Event

- (void)didPressClickMe:(id)sender
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Simple View"
                                                         message:@"Yay! You clicked me!"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
    [alertView show];
}

@end
