//
//  Utilities.m
//  Matchismo
//
//  Created by Nikita Kukushkin on 06/02/2013.
//  Copyright (c) 2013 Nikita Kukushkin. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

//Resizes images
+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

@end
