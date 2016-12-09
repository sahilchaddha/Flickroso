//
//  WebServiceClient.m
//  Flickroso
//
//  Created by Sahil Chaddha on 08/12/16.
//  Copyright © 2016 SahilC. All rights reserved.
//

#import "WebServiceClient.h"
#define API_URL @"https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
#import "FeedPhotoModel.h"
#define SERVICE_TIMEOUT_INTERVAL 20.0


@implementation WebServiceClient

+ (id)sharedInstance
{
    static WebServiceClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


+(void) getPhotosWithSuccess:(void (^)(NSArray *photos))successBlock failure:(void (^)(NSError *error))failureBlock
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:API_URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:SERVICE_TIMEOUT_INTERVAL];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];

    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError = nil;
        NSDictionary *results = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        
        if(data==nil || error || jsonError || results == nil)
        {
            failureBlock(error);
        }
        else
        {
            if([results valueForKey:@"items"] && [[results valueForKey:@"items"] isKindOfClass:[NSArray class]] && [(NSArray*)[results valueForKey:@"items"] count] > 0)
            {
                NSMutableArray *photoModels = [[NSMutableArray alloc]init];
                
                for(int i=0;i<[(NSArray*)[results valueForKey:@"items"] count];i++)
                {
                    FeedPhotoModel *model = [[FeedPhotoModel alloc] initWithDictionary:[[results valueForKey:@"items"] objectAtIndex:i]];
                    [photoModels addObject:model];
                }
                
                successBlock(photoModels);
            }
        }

    }];
    
    [postDataTask resume];
}

- (void)downloadImage:(NSURL*)imageUrl WithSuccess:(void (^)(UIImage *img))successBlock;
{
    if(self.imageCache == nil)
    {
        self.imageCache = [[NSMutableDictionary alloc]init];
    }
    
    if([self.imageCache objectForKey:[imageUrl absoluteString]])
    {
        successBlock([self.imageCache objectForKey:[imageUrl absoluteString]]);
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            
            UIImage* image = [[UIImage alloc] initWithData:imageData];
            if (image) {
                [self.imageCache setObject:image forKey:[imageUrl absoluteString]];
                successBlock(image);
            }
        });
    }
}
@end
