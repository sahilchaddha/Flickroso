//
//  FeedPhotoModel.m
//  Flickroso
//
//  Created by Sahil Chaddha on 08/12/16.
//  Copyright © 2016 SahilC. All rights reserved.
//

#import "FeedPhotoModel.h"

@implementation FeedPhotoModel

- (id) initWithDictionary:(NSDictionary*)dictionary
{
    self=[super init];
    if(self)
    {
        
        self.title = ([dictionary valueForKey:@"title"]?[dictionary valueForKey:@"title"]:@"");
        self.imageLink =[NSURL URLWithString:([dictionary valueForKey:@"link"]?[dictionary valueForKey:@"link"]:@"")];
        
        if([dictionary valueForKey:@"media"] && [[dictionary valueForKey:@"media"] valueForKey:@"m"])
        {
            self.imageUrl = [NSURL URLWithString:[[dictionary valueForKey:@"media"] valueForKey:@"m"]];
        }
        
        if([dictionary valueForKey:@"date_taken"])
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
            [dateFormatter setLocale:enUSPOSIXLocale];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
            self.clickedDate = [dateFormatter dateFromString:[dictionary valueForKey:@"date_taken"]];
        }
        
        if([dictionary valueForKey:@"description"])
        {
            NSString *html = [dictionary valueForKey:@"description"];
            //Adding CSS for image Size
            html = [NSString stringWithFormat:@"<style>.container img {width:60px !important;height:60px !important;object-fit:cover;} .container p{color:#ffffff;font-size:16px;}</style><div class='container'>%@</div>",html];

            NSAttributedString *attrString = [[NSAttributedString alloc]
                                                    initWithData: [html dataUsingEncoding:NSUnicodeStringEncoding]
                                                    options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                    documentAttributes: nil
                                                    error: nil
                                                    ];
            
        
            self.desc = attrString;
        }
        
    }
    return self;
}

@end
