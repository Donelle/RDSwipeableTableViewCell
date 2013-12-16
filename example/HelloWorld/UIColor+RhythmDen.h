//
//  UIColor+RhythmDen.h
//  RhythmDen
//
//  Created by Donelle Sanders Jr on 10/2/13.
//  Reference: http://stackoverflow.com/questions/11598043/get-slightly-lighter-and-darker-color-from-uicolor
//

#import <UIKit/UIKit.h>

@interface UIColor (RhythmDen)

- (UIColor *)saturateBy:(double)pixels;
- (UIColor *)lighterColor;
- (UIColor *)darkerColor;
- (NSString *)rgbString;


@end
