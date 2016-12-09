//
//  AppHelper.h
//  Flickroso
//
//  Created by Sahil Chaddha on 08/12/16.
//  Copyright © 2016 SahilC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppHelper : NSObject
+(void)animateImageView:(UIImageView*)imgView withUrl:(NSURL*)url;
+(void)animateImageView:(UIImageView*)imageView WithImage:(UIImage*)image;
@end
