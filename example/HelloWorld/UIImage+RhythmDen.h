//
//  UIImage+RhythmDen.h
//  RhythmDen
//
//  Created by Zhang Jiejing on 12-2-11.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RhythmDen)

- (UIImage *) tintColor:(UIColor *)color;
- (UIImage *) crop:(CGRect)rect;
- (UIImage *) shrink:(CGSize)size;

@end
