//
//  RDCustomViewController.m
//  HelloWorld
//
//  Created by Donelle Sanders Jr on 12/14/13.
//  Copyright (c) 2013 Donelle Sanders Jr. All rights reserved.
//

#import "RDCustomViewController.h"
#import "RDSwipeableTableViewCell.h"
#import "RDAlertView.h"
#import "UIColor+RhythmDen.h"
#import "UIImage+RhythmDen.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

#pragma mark - RDCustomCellBackgroundView Implementation

typedef enum {
    CellPositionTop,
    CellPositionMiddle,
    CellPositionBottom,
    CellPositionSingle
} CellPosition;

@interface RDCustomCellBackgroundView : UIView

@property(assign, nonatomic) CellPosition position;
@property(strong, nonatomic) UIColor *fillColor;

@end


@implementation RDCustomCellBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setPosition:(CellPosition)position
{
    _position = position;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    static const CGFloat kCornerRadius = 5.0;
    CGRect bounds = CGRectInset(self.bounds,
                                0.5 / [UIScreen mainScreen].scale,
                                0.5 / [UIScreen mainScreen].scale);
    UIBezierPath *path;
    if (_position == CellPositionSingle) {
        path = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:kCornerRadius];
    } else if (_position == CellPositionTop) {
        bounds.size.height += 1;
        path = [UIBezierPath bezierPathWithRoundedRect:bounds
                                     byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                           cornerRadii:CGSizeMake(kCornerRadius, kCornerRadius)];
    } else if (_position == CellPositionBottom) {
        path = [UIBezierPath bezierPathWithRoundedRect:bounds
                                     byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                           cornerRadii:CGSizeMake(kCornerRadius, kCornerRadius)];
    } else {
        bounds.size.height += 1;
        path = [UIBezierPath bezierPathWithRect:bounds];
    }
    
    [_fillColor setFill];
    [path fill];
    
}

@end


#pragma mark - RDCustomCellBackgroundView Implementation

@interface RDCustomViewController () <RDSwipeableTableViewCellDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

- (void)setAlertSettingCell:(RDSwipeableTableViewCell *)cell forIndex:(NSIndexPath *)index;
- (void)setDropboxAccountCell:(RDSwipeableTableViewCell *)cell forIndex:(NSIndexPath *)index;
- (void)setTwitterCell:(RDSwipeableTableViewCell *)cell forIndex:(NSIndexPath *)index;
- (void)setFacebookCell:(RDSwipeableTableViewCell *)cell forIndex:(NSIndexPath *)index;
- (void)setAboutCell:(RDSwipeableTableViewCell *)cell forIndex:(NSIndexPath *)index;
- (void)setFeedbackCell:(RDSwipeableTableViewCell *)cell forIndex:(NSIndexPath *)index;
- (void)setShareWithFriendsCell:(RDSwipeableTableViewCell *)cell forIndex:(NSIndexPath *)index;

@end

#define SECTION_CLOUDACCOUNTS 0
#define SECTION_SOCIALNETWORKS 1
#define SECTION_OPTIONS 2
#define SECTION_HELP 3

#define CELL_DROPBOX_TAG 100
#define CELL_FACEBOOK_TAG 101
#define CELL_TWITTER_TAG 102


@implementation RDCustomViewController
{
    UIColor * _cellBackColor, * _cellSelectedBackColor;
    NSString * _dropboxUserId, * _twitterUserId, * _facebookUserId;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _cellBackColor = [UIColor colorWithRed:220.0/255.0 green:141.0/255.0 blue:96.0/255.0 alpha:0.5];
    _cellSelectedBackColor = [_cellBackColor darkerColor];
}


#pragma mark - Instance Methods

- (void)setAlertSettingCell:(RDSwipeableTableViewCell *)cell forIndex:(NSIndexPath *)index
{
    UISwitch * onOff = [[UISwitch alloc] init];
    onOff.on = !onOff.on;
    onOff.backgroundColor = _cellBackColor;
    onOff.onTintColor = [[UIColor greenColor] darkerColor];
    onOff.tintColor = onOff.backgroundColor;
    onOff.layer.cornerRadius = 15.0f;
    onOff.clipsToBounds = YES;
    
    cell.accessoryView = onOff;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"Warn on Cellular Network";
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = nil;
    cell.tag = 0;
}


- (void)setDropboxAccountCell:(RDSwipeableTableViewCell *)cell forIndex:(NSIndexPath *)index
{
    UIColor * tintColor = _dropboxUserId ? [UIColor colorWithRed:0.0 green:126.0/255.0 blue:229.0/255.0 alpha:1.0] : [UIColor whiteColor];
    
    cell.selectionStyle = _dropboxUserId ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = _dropboxUserId ?: @"Add Dropbox Account";
    cell.imageView.image = [[UIImage imageNamed:@"dropbox"] tintColor:tintColor];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.delegate = self;
    cell.revealDirection = _dropboxUserId ? RDSwipeableTableViewCellRevealDirectionRight : RDSwipeableTableViewCellRevealDirectionNone;
    cell.revealDistance = 75.0f;
    cell.accessoryView = nil;
    cell.tag = CELL_DROPBOX_TAG;
}


- (void)setTwitterCell:(RDSwipeableTableViewCell *)cell forIndex:(NSIndexPath *)index
{
    UIColor * tintColor = _twitterUserId ? [UIColor colorWithRed:64.0/255.0 green:153.0/255.0 blue:255.0 alpha:1.0] : [UIColor whiteColor];
    
    cell.selectionStyle = _twitterUserId ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text =  _twitterUserId ?: @"Link Twitter Account";
    cell.accessoryView = nil;
    cell.imageView.image = [[UIImage imageNamed:@"twitter"] tintColor:tintColor];
    cell.delegate = self;
    cell.revealDirection = _twitterUserId ? RDSwipeableTableViewCellRevealDirectionRight : RDSwipeableTableViewCellRevealDirectionNone;
    cell.revealDistance = 75.0f;
    cell.tag = CELL_TWITTER_TAG;
}

- (void)setFacebookCell:(RDSwipeableTableViewCell *)cell forIndex:(NSIndexPath *)index
{
    UIColor * tintColor = _facebookUserId ? [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1.0] : [UIColor whiteColor];
    
    cell.selectionStyle = _facebookUserId ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = _facebookUserId ?: @"Link Facebook Account";
    cell.accessoryView = nil;
    cell.imageView.image = [[UIImage imageNamed:@"facebook"] tintColor:tintColor];
    cell.delegate = self;
    cell.revealDirection = _facebookUserId ? RDSwipeableTableViewCellRevealDirectionRight : RDSwipeableTableViewCellRevealDirectionNone;
    cell.revealDistance = 75.0f;
    cell.tag = CELL_FACEBOOK_TAG;
}

- (void)setAboutCell:(RDSwipeableTableViewCell *)cell forIndex:(NSIndexPath *)index
{
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = @"About Hello World";
    cell.clipsToBounds = YES;
    cell.accessoryView = nil;
    cell.imageView.image = [[UIImage imageNamed:@"about"] tintColor:[UIColor whiteColor]];
    cell.tag = 0;
}

- (void)setFeedbackCell:(RDSwipeableTableViewCell *)cell forIndex:(NSIndexPath *)index
{
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = @"Send Feedback / Get Support";
    cell.imageView.image = [[UIImage imageNamed:@"message"] tintColor:[UIColor whiteColor]];
    cell.clipsToBounds = YES;
    cell.accessoryView = nil;
    cell.tag = 0;
}

- (void)setShareWithFriendsCell:(RDSwipeableTableViewCell *)cell forIndex:(NSIndexPath *)index
{
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = @"Share with Friends";
    cell.imageView.image = [[UIImage imageNamed:@"share"] tintColor:[UIColor whiteColor]];
    cell.accessoryView = nil;
    cell.tag = 0;
}

#pragma mark - MFMailComposeViewControllerDelegate Protocol

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:NO];
}

#pragma mark - MFMessageComposeViewControllerDelegate Protocol

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:NO];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /* Cloud Account, Social Networks, Options, Help */
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SECTION_CLOUDACCOUNTS:
            return 1;
            
        case SECTION_OPTIONS:
            return 1;
            
        case SECTION_SOCIALNETWORKS:
            return 2;
            
        case SECTION_HELP:
            return 3;
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    RDSwipeableTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[RDSwipeableTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.backgroundColor = [UIColor clearColor];
    if (!cell.backgroundView) {
        RDCustomCellBackgroundView * bgView = [[RDCustomCellBackgroundView alloc] initWithFrame:cell.frame];
        bgView.fillColor = _cellBackColor;
        cell.backgroundView = bgView;
    }
    
    if (![cell.selectedBackgroundView isKindOfClass:[RDCustomCellBackgroundView class]]) {
        RDCustomCellBackgroundView * selectionView = [[RDCustomCellBackgroundView alloc] initWithFrame:cell.frame];
        selectionView.fillColor = _cellSelectedBackColor;
        cell.selectedBackgroundView = selectionView;
    }

    switch (indexPath.section) {
        case SECTION_CLOUDACCOUNTS:
        {
            RDCustomCellBackgroundView * bgView = (RDCustomCellBackgroundView *)cell.backgroundView;
            bgView.position = CellPositionSingle;
            RDCustomCellBackgroundView * selectionView = (RDCustomCellBackgroundView *)cell.selectedBackgroundView;
            selectionView.position = bgView.position;
            
            [self setDropboxAccountCell:cell forIndex:indexPath];
            break;
        }
            
        case SECTION_SOCIALNETWORKS:
        {
            RDCustomCellBackgroundView * bgView = (RDCustomCellBackgroundView *)cell.backgroundView;
            if (indexPath.row == 0) {
                bgView.position = CellPositionTop;
                [self setFacebookCell:cell forIndex:indexPath];
            } else {
                bgView.position = CellPositionBottom;
                [self setTwitterCell:cell forIndex:indexPath];
            }
            
            RDCustomCellBackgroundView * selectionView = (RDCustomCellBackgroundView *)cell.selectedBackgroundView;
            selectionView.position = bgView.position;
            break;
        }
            
        case SECTION_OPTIONS:
        {
            RDCustomCellBackgroundView * bgView = (RDCustomCellBackgroundView *)cell.backgroundView;
            bgView.position = CellPositionSingle;
            
            [self setAlertSettingCell:cell forIndex:indexPath];
            break;
        }
            
        case SECTION_HELP:
        {
            RDCustomCellBackgroundView * bgView = (RDCustomCellBackgroundView *)cell.backgroundView;
            if (indexPath.row == 0) {
                bgView.position = CellPositionTop;
                [self setFeedbackCell:cell forIndex:indexPath];
            } else if (indexPath.row == 1) {
                bgView.position = CellPositionMiddle;
                [self setShareWithFriendsCell:cell forIndex:indexPath];
            } else if (indexPath.row == 2) {
                bgView.position = CellPositionBottom;
                [self setAboutCell:cell forIndex:indexPath];
            }
            
            RDCustomCellBackgroundView * selectionView = (RDCustomCellBackgroundView *)cell.selectedBackgroundView;
            selectionView.position = bgView.position;
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate Protocol

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 300, 20)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8];
    label.backgroundColor = [UIColor clearColor];
    label.contentMode = UIViewContentModeTop;
    
    switch (section) {
        case SECTION_CLOUDACCOUNTS:
            label.text = @"Cloud Accounts";
            break;
            
        case SECTION_OPTIONS:
            label.text = @"Options";
            break;
            
        case SECTION_SOCIALNETWORKS:
            label.text = @"Social Networks";
            break;
            
        case SECTION_HELP:
            label.text = @"Help";
            break;
            
        default:
            break;
    }
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    [view addSubview:label];
    
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case SECTION_CLOUDACCOUNTS:
        {
            _dropboxUserId = @"Cap'n Crunch";
            [tableView reloadData];
            break;
        }
            
        case SECTION_SOCIALNETWORKS:
        {
            RDSwipeableTableViewCell * cell = (RDSwipeableTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            if (cell.tag == CELL_FACEBOOK_TAG) {
                _facebookUserId = @"Cap'n Crunch";
                [tableView reloadData];
            } else if (cell.tag == CELL_TWITTER_TAG) {
               _twitterUserId = @"@capncrunchbox";
                [tableView reloadData];
            }
            break;
        }
            
        case SECTION_HELP:
        {
            if (indexPath.row == 0) {
                if ([MFMailComposeViewController canSendMail]) {
                    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                    NSString * build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                    NSString * iOSVersion = [[UIDevice currentDevice] systemVersion];
                    NSString * model = [[UIDevice currentDevice] model];
                    NSString * diagnostics = [NSString stringWithFormat:@"\n\n\n\nDiagnotics Information\n=================\nDevice: %@\niOS Version: %@\nHello World Version: v%@ (Build %@)", model, iOSVersion, version, build];
                    MFMailComposeViewController * mailController = [[MFMailComposeViewController alloc] init];
                    [mailController setSubject:@"Feedback & Support"];
                    [mailController setToRecipients:@[@"support@helloworld.com"]];
                    [mailController setMessageBody:diagnostics isHTML:NO];
                    [mailController setMailComposeDelegate:self];
                    [self presentViewController:mailController animated:YES completion:NO];
                } else {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello World"
                                                                     message:@"Sorry, you must enable Mail in order to use this feature"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                    [alert show];
                }
            } else if (indexPath.row == 1) {
                
                if ([MFMessageComposeViewController canSendText]) {
                    MFMessageComposeViewController * messageController = [[MFMessageComposeViewController alloc] init];
                    [messageController setBody:@"Like Hello World? Try it out!"];
                    [messageController setMessageComposeDelegate:self];
                    [self presentViewController:messageController animated:YES completion:nil];
                } else {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello World"
                                                                     message:@"Sorry, you must enable Text Messaging in order to use this feature"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                    [alert show];
                }
            } else if (indexPath.row == 2) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"About"
                                                                 message:@"Hello World is a fictious mobile app designed to demonstrate blah blah blah blah haha ;-)"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                [alert show];
            }
            
            break;
        }
            
        default:
            break;
    }
}



#pragma mark - RDSwipeableTableViewCell delegate methods

- (void)tableView:(UITableView *)tableView willBeginCellSwipe:(RDSwipeableTableViewCell *)cell inDirection:(RDSwipeableTableViewCellRevealDirection)direction
{
    CGRect cellRect = cell.frame;
    
    UIButton * deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.backgroundColor = [[UIColor redColor] darkerColor];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
    deleteButton.frame = CGRectMake(cellRect.size.width - 75, 0, 75, cellRect.size.height);
    deleteButton.clipsToBounds = YES;
    deleteButton.layer.cornerRadius = 5.0f;
    [deleteButton setImage:[[UIImage imageNamed:@"delete"] tintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    RDCustomCellBackgroundView * containerView = [[RDCustomCellBackgroundView alloc] initWithFrame:(CGRect){0, 0, cellRect.size}];
    containerView.fillColor = [[UIColor redColor] darkerColor];
    [containerView addSubview:deleteButton];
    
    switch (cell.tag) {
        case CELL_DROPBOX_TAG:
        {
            [deleteButton addTarget:self action:@selector(didPressUnlinkDropboxAccount:) forControlEvents:UIControlEventTouchUpInside];
            containerView.position = CellPositionSingle;
            break;
        }
            
        case CELL_FACEBOOK_TAG:
        {
            [deleteButton addTarget:self action:@selector(didPressUnlinkFacebookAccount:) forControlEvents:UIControlEventTouchUpInside];
            containerView.position = CellPositionTop;
            break;
        }
            
        case CELL_TWITTER_TAG:
        {
            [deleteButton addTarget:self action:@selector(didPressUnlinkTwitterAccount:) forControlEvents:UIControlEventTouchUpInside];
            containerView.position = CellPositionBottom;
            break;
        }
            
        default:
            break;
    }
    
    [cell.revealView addSubview:containerView];
}


- (void)tableView:(UITableView *)tableView didCellReset:(RDSwipeableTableViewCell *)cell
{
    [cell.revealView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark - UI Events

- (void)didPressUnlinkDropboxAccount:(id)sender
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
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Remove Account"
                                                     message:@"Are you sure you want to remove your Dropbox Account?"
                                                    delegate:Nil
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"YES", nil];
    if ([RDAlertView show:alert]) {
        _dropboxUserId = nil;
        [self.tableView reloadData];
    } else {
        [cell resetToOriginalState];
    }
}

- (void)didPressUnlinkFacebookAccount:(id)sender
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
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Remove Account"
                                                     message:@"Are you sure you want to remove your Facebook Account?"
                                                    delegate:Nil
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"YES", nil];
    if ([RDAlertView show:alert]) {
        _facebookUserId = nil;
        [self.tableView reloadData];
    } else {
        [cell resetToOriginalState];
    }
}

- (void)didPressUnlinkTwitterAccount:(id)sender
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
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Remove Account"
                                                     message:@"Are you sure you want to remove your Twitter Account?"
                                                    delegate:Nil
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"YES", nil];
    if ([RDAlertView show:alert]) {
        _twitterUserId = nil;
        [self.tableView reloadData];
    } else {
        [cell resetToOriginalState];
    }
}



@end
