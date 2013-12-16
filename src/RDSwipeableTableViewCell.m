//
//  RDSwipeableTableViewCell.m
//  RhythmDen
//
//  Created by Donelle Sanders Jr on 11/14/13.
//
//

#import "RDSwipeableTableViewCell.h"

typedef enum {
    SwipeDirectionLeft = 1,
    SwipeDirectionRight = 2
}SwipeDirection;

@interface RDSwipeableTableViewCell () <UIGestureRecognizerDelegate>

@property (nonatomic, readonly) UIView * realContentView;
@property (nonatomic, readonly) UIView *contentScrollView;

- (void)setup;
- (void)resetView;
- (void)didReceivePanGesture:(UIPanGestureRecognizer *)gesture;
- (void)handleSwipe:(UIPanGestureRecognizer *)gesture withPoint:(CGPoint)point withVelocity:(CGPoint)velocity withDirection:(RDSwipeableTableViewCellRevealDirection)revealedDirection;


@end

@implementation RDSwipeableTableViewCell
{
    UITableViewCellSelectionStyle _previousSelectionStyle;
}

@synthesize revealView = _revealView;
@synthesize contentScrollView = _contentScrollView;
@synthesize realContentView = _realContentView;
@synthesize revealViewVisible = _revealViewVisible;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) [self setup];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
        [self setup];
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    if (_revealViewVisible)
        [self resetToOriginalState];
}

#pragma mark - Instance Properties

- (UIView *)revealView
{
    if (!_revealView)
        _revealView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    
    return _revealView;
}


- (UIView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        _contentScrollView.backgroundColor = [UIColor clearColor];
    }
    return _contentScrollView;
}

- (UIView *)realContentView
{
    if (!_realContentView) {
        _realContentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        _realContentView.backgroundColor = [UIColor clearColor];
    }
    return _realContentView;
}

- (BOOL)revealViewVisible
{
    return _revealViewVisible;
}

#pragma mark - Gesture recognizer delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] &&
        self.revealDirection != RDSwipeableTableViewCellRevealDirectionNone)
    {
        CGPoint point = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return point.x != 0;
    }
    
    return NO;
}

- (void)didReceivePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer
{
    static SwipeDirection swipeDirection, prevSwipeDirection;
    static RDSwipeableTableViewCellRevealDirection revealDirection;
    
    CGPoint point = [panGestureRecognizer translationInView:panGestureRecognizer.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:panGestureRecognizer.view];
    
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            swipeDirection = point.x < 0 ? SwipeDirectionLeft : SwipeDirectionRight;
            if (self.revealViewVisible) {
                //
                // Make sure we are not swiping in the same direction while we have a revealed view
                // if so just ignore it
                //
                if ((prevSwipeDirection == SwipeDirectionLeft && swipeDirection == SwipeDirectionLeft) ||
                    (prevSwipeDirection == SwipeDirectionRight && swipeDirection == SwipeDirectionRight))
                {
                    return;
                }
                
                if (revealDirection == RDSwipeableTableViewCellRevealDirectionNone)
                    revealDirection = prevSwipeDirection == SwipeDirectionLeft ? RDSwipeableTableViewCellRevealDirectionLeft : RDSwipeableTableViewCellRevealDirectionRight;
            } else {
                //
                // Make sure we requested to handle this kind of swipe
                //
                revealDirection = swipeDirection == SwipeDirectionRight ? RDSwipeableTableViewCellRevealDirectionLeft : RDSwipeableTableViewCellRevealDirectionRight;
                if (revealDirection & self.revealDirection) {
                    prevSwipeDirection = swipeDirection;
                } else {
                    revealDirection = RDSwipeableTableViewCellRevealDirectionNone;
                }
            }
            
            if (revealDirection != RDSwipeableTableViewCellRevealDirectionNone)
                [self handleSwipe:panGestureRecognizer withPoint:point withVelocity:velocity withDirection:revealDirection];
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded:
        {
            if (revealDirection != RDSwipeableTableViewCellRevealDirectionNone)
                [self handleSwipe:panGestureRecognizer withPoint:point withVelocity:velocity withDirection:revealDirection];
            
            break;
        }
            
        default:
            break;
    }
}


#pragma mark - Instance Methods

- (void)setup
{
    _previousSelectionStyle = (UITableViewCellSelectionStyle) -1;
    //
    // Settings
    //
    self.revealDirection = RDSwipeableTableViewCellRevealDirectionNone;
    //
    // Hidden content
    //
    [self.contentView addSubview:self.revealView];
    [self.revealView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    //
    // Animated content
    //
    [self.contentView addSubview:self.contentScrollView];
    [self.contentScrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    //
    // The actual content
    //
    [self.contentScrollView addSubview:self.realContentView];
    [self.realContentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    //
    // The gesture
    //
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didReceivePanGesture:)];
    [panGestureRecognizer setDelegate:self];
    [self addGestureRecognizer:panGestureRecognizer];
}

- (void)resetView
{
    if (_previousSelectionStyle != (UITableViewCellSelectionStyle)-1)
        self.selectionStyle = _previousSelectionStyle;
    
    self.contentScrollView.hidden = YES;
    self.contentScrollView.backgroundColor = [UIColor clearColor];
    self.revealView.hidden = YES;
    //
    // Unpack the contents back into the contentView
    //
    [self.realContentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView * childView = (UIView *)obj;
        [childView removeFromSuperview];
        [self.contentView addSubview:childView];
    }];
}

- (void)resetToOriginalState
{
    [UIView animateWithDuration:.3
                     animations:^{
                         self.contentScrollView.frame = CGRectOffset(self.contentScrollView.bounds, 0, 0);
                         self.realContentView.bounds = CGRectOffset(self.realContentView.bounds, 0, 0);
                     } completion:^(BOOL finished) {
                         [self resetView];
                         if ([self.delegate respondsToSelector:@selector(tableView:didCellReset:)])
                             [self.delegate tableView:self.tableView didCellReset:self];
                         _revealViewVisible = NO;
                     }];
}


- (void)handleSwipe:(UIPanGestureRecognizer *)gesture
          withPoint:(CGPoint)point
       withVelocity:(CGPoint)velocity
      withDirection:(RDSwipeableTableViewCellRevealDirection)revealedDirection
{
    SwipeDirection swipeDirection = point.x < 0 ? SwipeDirectionLeft : SwipeDirectionRight;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (_revealViewVisible) {
            if ([self.delegate respondsToSelector:@selector(tableView:willBeginCellReset:)])
                [self.delegate tableView:self.tableView willBeginCellReset:self];
        } else {
            self.contentScrollView.hidden = NO;
            self.contentScrollView.backgroundColor = self.backgroundColor;
            
            if (self.backgroundView) {
                UIGraphicsBeginImageContext(self.backgroundView.frame.size);
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                [self.backgroundView.layer renderInContext:ctx];
                UIImage * finishImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                self.contentScrollView.backgroundColor = [UIColor colorWithPatternImage:finishImage];
            }
            
            _previousSelectionStyle = self.selectionStyle;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            //
            // empty everything out of the contentView that is not
            // our predefined elements
            //
            [self.contentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                UIView * childView = (UIView *)obj;
                if (![childView isEqual:self.contentScrollView] &&
                    ![childView isEqual:self.revealView] &&
                    ![childView isEqual:self.selectedBackgroundView])
                {
                    [childView removeFromSuperview];
                    [self.realContentView addSubview:childView];
                }
            }];
            
            self.revealView.hidden = NO;
            if ([self.delegate respondsToSelector:@selector(tableView:willBeginCellSwipe:inDirection:)])
                [self.delegate tableView:self.tableView willBeginCellSwipe:self inDirection:revealedDirection];
            //
            // Make sure we always start from origin zero
            //
            self.contentScrollView.frame = CGRectOffset(self.contentScrollView.bounds, 0, 0);
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        float xOffSet = fabs(point.x);
        if (swipeDirection == SwipeDirectionRight) {
            if (revealedDirection == RDSwipeableTableViewCellRevealDirectionLeft) {
                if (xOffSet > self.revealDistance) {
                    xOffSet -= self.revealDistance;
                    //
                    // Reference: http://squareb.wordpress.com/2013/01/06/31/
                    //
                    // What we are doing here is calculating how fast we move
                    // the content view. The formula for this is:
                    //
                    // b = (1.0 – (1.0 / ((x * c / d) + 1.0))) * d
                    //
                    // x = distance from the edge
                    // c = constant value, UIScrollView uses 0.55
                    // d = dimension, either width or height
                    //
                    float width = self.contentScrollView.bounds.size.width;
                    float distance = (1.0f - (1.0f / ((xOffSet * 0.55 / width) + 1.0))) * width;
                    
                    self.realContentView.frame = CGRectOffset(self.realContentView.bounds, distance, 0);
                    self.contentScrollView.frame = CGRectOffset(self.contentScrollView.bounds, self.revealDistance, 0);
                } else if (xOffSet > 0 && !_revealViewVisible) {
                    //
                    // Nope keep scrolling the scrollview
                    //
                    self.contentScrollView.frame = CGRectOffset(self.contentScrollView.bounds, xOffSet, 0);
                }
            } else {
                //
                // This means we are trying to hide the revealed view
                //
                if (self.contentScrollView.frame.origin.x < 0 && _revealViewVisible) {
                    CGRect newFrame = CGRectOffset(self.contentScrollView.bounds, -(self.revealDistance - xOffSet), 0);
                    if (newFrame.origin.x > 0)
                        newFrame = CGRectOffset(self.contentScrollView.bounds, 0, 0);
                    
                    self.contentScrollView.frame = newFrame;
                }
            }
        } else if (swipeDirection == SwipeDirectionLeft) {
            if (revealedDirection == RDSwipeableTableViewCellRevealDirectionRight) {
                if (point.x < -self.revealDistance) {
                    xOffSet -= self.revealDistance;
                    //
                    // Reference: http://squareb.wordpress.com/2013/01/06/31/
                    //
                    // What we are doing here is calculating how fast we move
                    // the content view. The formula for this is:
                    //
                    // b = (1.0 – (1.0 / ((x * c / d) + 1.0))) * d
                    //
                    // x = distance from the edge
                    // c = constant value, UIScrollView uses 0.55
                    // d = dimension, either width or height
                    //
                    float width = self.contentScrollView.bounds.size.width;
                    float distance = (1.0f - (1.0f / ((xOffSet * 0.55 / width) + 1.0))) * width;
                    
                    self.realContentView.frame = CGRectOffset(self.realContentView.bounds, -distance, 0);
                    self.contentScrollView.frame = CGRectOffset(self.contentScrollView.bounds, -self.revealDistance, 0);
                } else if (point.x <= 0 && !_revealViewVisible) {
                    //
                    // Nope keep scrolling the scrollview
                    //
                    self.contentScrollView.frame = CGRectOffset(self.contentScrollView.bounds, point.x, 0);
                }
            } else {
                //
                // This means we are trying to hide the revealed view
                //
                if (self.contentScrollView.frame.origin.x > 0 && _revealViewVisible) {
                    CGRect newFrame = CGRectOffset(self.contentScrollView.bounds, self.revealDistance - xOffSet, 0);
                    if (newFrame.origin.x <= 0)
                        newFrame = CGRectOffset(self.contentScrollView.bounds, 0, 0);
                    
                    self.contentScrollView.frame = newFrame;
                }
            }
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        
        if ((swipeDirection == SwipeDirectionRight && revealedDirection == RDSwipeableTableViewCellRevealDirectionLeft) ||
            (swipeDirection == SwipeDirectionLeft && revealedDirection == RDSwipeableTableViewCellRevealDirectionRight)) {
            
            float xOffSet = fabs(self.contentScrollView.frame.origin.x);
            float xDistance = revealedDirection == RDSwipeableTableViewCellRevealDirectionLeft ? self.revealDistance : -self.revealDistance;
            //
            // Now check to see if the orgin made it to the reveal distance
            //
            if (xOffSet < self.revealDistance) {
                //
                // Before we try to continue expanding lets see if we are aleast over half
                // the distance
                //
                float distance = floorf(self.revealDistance / 2);
                if (xOffSet < distance) {
                    [self resetToOriginalState];
                    return;
                } else {
                    BOOL isSwipingFast = swipeDirection == SwipeDirectionRight ? velocity.x > 600 : velocity.x < -600;
                    if (isSwipingFast) {
                        _revealViewVisible = YES;
                        self.contentScrollView.frame = CGRectOffset(self.contentScrollView.bounds, xDistance, 0);
                        if ([self.delegate respondsToSelector:@selector(tableView:didCellSwipe:inDirection:)])
                            [self.delegate tableView:self.tableView didCellSwipe:self inDirection:revealedDirection];
                        
                        return;
                    }
                }
            }
            //
            // If we have scrolled passed the reveal distance or we aren't swiping very fast
            // then animate our scroll to the appropriate distance
            //
            [UIView animateWithDuration:.2
                             animations:^{
                                 self.contentScrollView.frame = CGRectOffset(self.contentScrollView.bounds, xDistance, 0);
                                 self.realContentView.frame = CGRectOffset(self.bounds, 0, 0);
                             } completion:^(BOOL finished) {
                                 _revealViewVisible = YES;
                                 if ([self.delegate respondsToSelector:@selector(tableView:didCellSwipe:inDirection:)])
                                     [self.delegate tableView:self.tableView didCellSwipe:self inDirection:revealedDirection];
                             }];
            
        } else if ((swipeDirection == SwipeDirectionRight && revealedDirection == RDSwipeableTableViewCellRevealDirectionRight) ||
                   (swipeDirection == SwipeDirectionLeft && revealedDirection == RDSwipeableTableViewCellRevealDirectionLeft)) {

            BOOL isSwipingFast = swipeDirection == SwipeDirectionRight ? velocity.x < -600 : velocity.x > 600 ;
            if (isSwipingFast) {
                self.contentScrollView.frame = self.contentView.frame;
                self.realContentView.bounds = CGRectOffset(self.realContentView.bounds, 0, 0);
                
                [self resetView];
                if ([self.delegate respondsToSelector:@selector(tableView:didCellReset:)])
                    [self.delegate tableView:self.tableView didCellReset:self];
                
                _revealViewVisible = NO;
            } else {
                [self resetToOriginalState];
            }
        }
        
    }
}

@end
