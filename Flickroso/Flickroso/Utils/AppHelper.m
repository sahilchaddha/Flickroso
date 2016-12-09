//
//  AppHelper.m
//  Flickroso
//
//  Created by Sahil Chaddha on 08/12/16.
//  Copyright © 2016 SahilC. All rights reserved.
//

#import "AppHelper.h"
#import "WebServiceClient.h"

@implementation AppHelper
+ (void)animateImageView:(UIImageView*)imgView withUrl:(NSURL*)url
{
    __weak UIImageView *weakImageView = imgView;
    weakImageView.image = nil;
    weakImageView.image = [UIImage imageNamed:@"default-thumbnail.jpg"];
    [[WebServiceClient sharedInstance] downloadImage:url WithSuccess:^(UIImage *img) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(weakImageView)
                [AppHelper animateImageView:weakImageView WithImage:img];
        });
    }];
}

+(void)animateImageView:(UIImageView*)imageView WithImage:(UIImage*)image
{
    [UIView transitionWithView:imageView duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^
     {
         imageView.image = image;
     }
                    completion:nil];
}

@end
