//
//  UIColor+RhythmDen.m
//  RhythmDen
//
//  Created by Donelle Sanders Jr on 10/2/13.
//
//

#import "UIColor+RhythmDen.h"

@implementation UIColor (RhythmDen)

- (UIColor *)lighterColor
{
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:MIN(b * 1.3, 1.0)
                               alpha:a];
    return nil;
}

- (UIColor *)darkerColor
{
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * 0.75
                               alpha:a];
    return nil;
}

- (NSString *)rgbString
{
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a]) {
        return [NSString stringWithFormat:@"{ %u, %u, %u }", (uint8_t)( r * 255.0), (uint8_t)(g * 255.0), (uint8_t)(b * 255.0)];
    }
    
    return nil;
}

- (UIColor *)saturateBy:(double)pixels
{
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s * pixels
                          brightness:b
                               alpha:a];
    return nil;

}

@end
