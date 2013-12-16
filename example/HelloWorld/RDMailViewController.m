//
//  RDMailViewController.m
//  HelloWorld
//
//  Created by Donelle Sanders Jr on 12/15/13.
//  Copyright (c) 2013 Donelle Sanders Jr. All rights reserved.
//

#import "RDMailViewController.h"
#import "UIColor+RhythmDen.h"
#import "RDAlertView.h"

@interface RDMailViewCell ()

@property (strong, nonatomic) NSString * title;

@end

@implementation RDMailViewCell
{
    UILabel * _titleLabel;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _titleLabel = [[UILabel alloc] initWithFrame:(CGRect){15, 5, 250, 20}];
        _titleLabel.text = @"Cap'n Crunch";
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self.contentView addSubview:_titleLabel];
        
        UILabel * timestamp = [[UILabel alloc] initWithFrame:(CGRect){self.bounds.size.width - 90, 5, 90, 20}];
        timestamp.text = @"Yesterday";
        timestamp.font = [UIFont systemFontOfSize:16];
        timestamp.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:timestamp];
        
        NSString * filler = @"Cu vim vidit populo. Mea posse etiam erroribus ex, fugit impetus atomorum sit ea, aeterno efficiantur at vis. Mutat tollit iriure eam ut, per ad omnium nonumes dissentias. Est eros movet an, et corpora democritum consectetuer eos.";
        UILabel * headline = [[UILabel alloc] initWithFrame:(CGRect){15, 25, self.bounds.size.width- 30, 20}];
        headline.text = filler;
        headline.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:headline];
        
        UILabel * content = [[UILabel alloc] initWithFrame:(CGRect){15, 40, self.bounds.size.width- 25, 100}];
        content.text = filler;
        content.numberOfLines = 5;
        content.font = [UIFont systemFontOfSize:15];
        content.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:content];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (NSString *)title
{
    return _titleLabel.text;
}

@end

@interface RDMailViewController () <RDSwipeableTableViewCellDelegate>

- (void)didPressDelete:(id)sender;
- (void)didPressMore:(id)sender;

@end

@implementation RDMailViewController
{
    NSMutableArray * _inboxItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(65, 0, 0, 0);
    _inboxItems = [NSMutableArray arrayWithObjects:@"Cap'n Crunch",@"Snap Crackle Pop",@"Trix",@"Fuity Pebbles",@"Pops",@"Crunch Berries",@"Tony Tiger", nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _inboxItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    RDMailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) cell = [[RDMailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.title = [_inboxItems objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.tableView = tableView;
    cell.revealDirection = RDSwipeableTableViewCellRevealDirectionRight;
    
    return cell;
}

#pragma mark - RDSwipeableTableViewCellDelegate

- (void)tableView:(UITableView *)tableView willBeginCellSwipe:(RDSwipeableTableViewCell *)cell inDirection:(RDSwipeableTableViewCellRevealDirection)direction
{
    CGRect cellRect = cell.frame;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(cellRect.size.width - 65, 0, 65, cellRect.size.height);
    button.backgroundColor = [[UIColor redColor] lighterColor];
    [button setTitle:@"Trash" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didPressDelete:) forControlEvents:UIControlEventTouchUpInside];
    [cell.revealView addSubview:button];
    
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(cellRect.size.width - 130, 0, 65, cellRect.size.height);
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitle:@"More" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didPressMore:) forControlEvents:UIControlEventTouchUpInside];
    [cell.revealView addSubview:button];
    
    cell.revealDistance = 130;
}

- (void)tableView:(UITableView *)tableView didCellReset:(RDSwipeableTableViewCell *)cell
{
    [cell.revealView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark - UI Event

- (void)didPressMore:(id)sender
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Mail App View"
                                                         message:@"Yay! You clicked me!"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)didPressDelete:(id)sender
{
    RDSwipeableTableViewCell * cell = nil;
    UIView * superView = [sender superview];
    //
    // Get our parent cell
    //
    do {
        if ([superView isKindOfClass:[RDSwipeableTableViewCell class]]) {
            cell = (RDSwipeableTableViewCell *)superView;
            break;
        }
        superView = [superView superview];
    }while (superView);
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Delete Mail"
                                                     message:@"Are you sure you want to delete this message?"
                                                    delegate:Nil
                                           cancelButtonTitle:@"NO"
                                           otherButtonTitles:@"YES", nil];
    if ([RDAlertView show:alert]) {
        
        NSIndexPath * path = [self.tableView indexPathForCell:cell];
        [_inboxItems removeObjectAtIndex:path.row];
    
        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
    
    } else {
        [cell resetToOriginalState];
    }
}


@end
