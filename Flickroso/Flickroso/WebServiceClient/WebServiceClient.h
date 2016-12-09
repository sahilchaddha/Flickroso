//
//  WebServiceClient.h
//  Flickroso
//
//  Created by Sahil Chaddha on 08/12/16.
//  Copyright © 2016 SahilC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WebServiceClient : NSObject
@property (strong, nonatomic) NSMutableDictionary *imageCache;
+ (id)sharedInstance;
+(void) getPhotosWithSuccess:(void (^)(NSArray *photos))successBlock failure:(void (^)(NSError *error))failureBlock;
- (void)downloadImage:(NSURL*)imageUrl WithSuccess:(void (^)(UIImage *img))successBlock;
@end
