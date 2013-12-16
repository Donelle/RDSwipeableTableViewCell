//
//  UIImage+RhythmDen.m
//  RhythmDen
//
//  Created by Donelle Sanders on 9/29/13.
//
//

#import "UIImage+RhythmDen.h"

@implementation UIImage (RhythmDen)

- (UIImage *)tintColor:(UIColor *)color
{
    UIImage *finishImage;
    CGImageRef alphaImage = CGImageRetain(self.CGImage);
    CGColorRef colorref = CGColorRetain(color.CGColor);
    
    UIGraphicsBeginImageContext(self.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect imageArea = CGRectMake (0, 0, self.size.width, self.size.height);
    
    CGFloat height = self.size.height;
    CGContextTranslateCTM(ctx, 0.0, height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CGContextClipToMask(ctx, imageArea , alphaImage);
    
    CGContextSetFillColorWithColor(ctx, colorref);
    CGContextFillRect(ctx, imageArea);
    CGImageRelease(alphaImage);
    CGColorRelease(colorref);
    
    finishImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finishImage;
}

- (UIImage *)crop:(CGRect)rect
{
    UIImage * cropImage = nil;
    rect = CGRectMake(rect.origin.x*self.scale,
                      rect.origin.y*self.scale,
                      rect.size.width*self.scale,
                      rect.size.height*self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    cropImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    return cropImage;
}

- (UIImage *)shrink:(CGSize)size
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, size.width * 4, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage);
    
    CGImageRef refImage = CGBitmapContextCreateImage(context);
    UIImage * newImage = [UIImage imageWithCGImage:refImage];
   
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CGImageRelease(refImage);
    
    return newImage;
}


@end
