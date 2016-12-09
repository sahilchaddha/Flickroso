//
//  DetailViewController.h
//  Flickroso
//
//  Created by Sahil Chaddha on 08/12/16.
//  Copyright © 2016 SahilC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailViewControllerDelegate <NSObject>
@optional
- (void)selectedIndexChanged:(int)selectedIndex;
@end



@interface DetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate,UITextViewDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *detailCollectionView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *descView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UITextView *txtView;
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuTopConstraint;
@property (nonatomic,weak) id<DetailViewControllerDelegate> delegate;

@property (strong, nonatomic) NSArray *photosArray;
@property (nonatomic) int selectedIndex;


- (IBAction)backBtnClicked:(id)sender;
- (IBAction)shareBtnClicked:(id)sender;
- (void)showDetails;
- (void)hideDetails;
@end
