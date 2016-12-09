//
//  FeedPhotoModel.h
//  Flickroso
//
//  Created by Sahil Chaddha on 08/12/16.
//  Copyright © 2016 SahilC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FeedPhotoModel : NSObject
@property (strong, nonatomic) NSDate *clickedDate;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) NSURL *imageLink;
@property (strong, nonatomic) NSAttributedString *desc;
- (id) initWithDictionary:(NSDictionary*)dictionary;
@end
