//
//  RDSwipeableTableViewCell.h
//  RhythmDen
//
//  Created by Donelle Sanders Jr on 11/14/13.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    RDSwipeableTableViewCellRevealDirectionNone = 0,
    RDSwipeableTableViewCellRevealDirectionRight = 1,
    RDSwipeableTableViewCellRevealDirectionLeft = 2,
} RDSwipeableTableViewCellRevealDirection;

@class RDSwipeableTableViewCell;
@protocol RDSwipeableTableViewCellDelegate <NSObject>
@optional
- (void)tableView:(UITableView *)tableView willBeginCellSwipe:(RDSwipeableTableViewCell *)cell inDirection:(RDSwipeableTableViewCellRevealDirection)direction;
- (void)tableView:(UITableView *)tableView didCellSwipe:(RDSwipeableTableViewCell *)cell inDirection:(RDSwipeableTableViewCellRevealDirection)direction;
- (void)tableView:(UITableView *)tableView willBeginCellReset:(RDSwipeableTableViewCell *)cell;
- (void)tableView:(UITableView *)tableView didCellReset:(RDSwipeableTableViewCell *)cell;
@end

@interface RDSwipeableTableViewCell : UITableViewCell

@property (weak, nonatomic) id<RDSwipeableTableViewCellDelegate> delegate;
@property (weak, nonatomic) UITableView * tableView;

@property (readonly, nonatomic) BOOL revealViewVisible;
@property (assign, nonatomic) float revealDistance;
@property (readonly, nonatomic) UIView *revealView;
@property (assign, nonatomic) RDSwipeableTableViewCellRevealDirection revealDirection;

- (void)resetToOriginalState;

@end
