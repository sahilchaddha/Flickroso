//
//  DetailViewController.m
//  Flickroso
//
//  Created by Sahil Chaddha on 08/12/16.
//  Copyright © 2016 SahilC. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailCollectionViewCell.h"
#import "AppHelper.h"
#import "FeedPhotoModel.h"
#import "GridViewController.h"
#import "DetailToGridTransition.h"
#import <SafariServices/SafariServices.h>

@interface DetailViewController ()
{
    BOOL isAnimating;
    BOOL isOpen;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self setupCollectionView];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.selectedIndex != 0)
    {
        [self.view layoutIfNeeded];
        [self.detailCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}


- (void)initView
{
    isOpen = false;
    isAnimating = false;
    self.dateView.alpha = 0;
    self.descView.alpha = 0;
    self.menuTopConstraint.constant = -64;
    [self.view layoutIfNeeded];
    [self performSelector:@selector(showDetails) withObject:nil afterDelay:1.5];
}

-(void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.detailCollectionView setPagingEnabled:YES];
    [self.detailCollectionView setCollectionViewLayout:flowLayout];
}

- (void)setupView
{
    self.dateView.layer.masksToBounds = NO;
    self.dateView.layer.cornerRadius = 8;

    self.txtView.linkTextAttributes = @{NSForegroundColorAttributeName: [UIColor orangeColor]};
    [self updateLabels];
}

- (void)updateLabels
{
    if(self.selectedIndex >= 0 && self.selectedIndex < self.photosArray.count)
    {
        NSDate *clickedDate = [[self.photosArray objectAtIndex:self.selectedIndex] clickedDate];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMM dd, YYYY"];
        self.dateLbl.text = [dateFormat stringFromDate:clickedDate];
        self.titleLbl.text = [NSString stringWithFormat:@"Title: %@",[[self.photosArray objectAtIndex:self.selectedIndex] title]];
        self.txtView.attributedText = [[self.photosArray objectAtIndex:self.selectedIndex] desc];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Delegate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photosArray count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.detailCollectionView.frame.size.width, self.detailCollectionView.frame.size.height - 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"detailCell" forIndexPath:indexPath];
    
    
    [AppHelper animateImageView:cell.imgView withUrl:[(FeedPhotoModel*)[self.photosArray objectAtIndex:indexPath.row] imageUrl]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(isOpen)
    {
        [self hideDetails];
    }
    else
    {
        [self showDetails];
    }
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideDetails];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGRect visibleBounds = self.detailCollectionView.bounds;
    NSInteger index = (NSInteger)(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    if (index < 0) index = 0;
    if (index > [_photosArray count] - 1) index = [_photosArray count] - 1;
    
    self.selectedIndex = (int)index;
    if([_delegate respondsToSelector:@selector(selectedIndexChanged:)])
    {
        [_delegate selectedIndexChanged:self.selectedIndex];
    }
    [self updateLabels];
}


#pragma mark - Click Events

- (IBAction)backBtnClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)shareBtnClicked:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Image Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"Save/Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DetailCollectionViewCell *cell = (DetailCollectionViewCell*)[self.detailCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
        FeedPhotoModel *model = [self.photosArray objectAtIndex:self.selectedIndex];
        NSMutableArray *activityItems = [[NSMutableArray alloc]initWithObjects:model.title,model.imageLink, nil];
        if(cell && cell.imgView)
        {
            [activityItems addObject:cell.imgView.image];
        }
        
        UIActivityViewController *activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                          applicationActivities:nil];
        
        [self presentViewController:activityViewController animated:YES completion:nil];

    }];

    UIAlertAction *safari = [UIAlertAction actionWithTitle:@"Open in Safari" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FeedPhotoModel *model = [self.photosArray objectAtIndex:self.selectedIndex];
        if(model.imageLink && [model.imageLink isKindOfClass:[NSURL class]])
        {
            SFSafariViewController *vc = [[SFSafariViewController alloc]initWithURL:model.imageLink];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:alertController completion:nil];
    }];
    
    [alertController addAction:save];
    [alertController addAction:safari];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
#pragma mark - UITextView Delegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    return true;
}

#pragma mark - Animation Functions

- (void)showDetails
{
    if(!isOpen && !isAnimating)
    {
        isAnimating = true;
        [UIView animateWithDuration:0.2 animations:^{
            self.menuTopConstraint.constant = 0;
            [self.view layoutIfNeeded];
            self.dateView.alpha = 1;
            self.descView.alpha = 1;
        } completion:^(BOOL finished) {
                isAnimating = false;
                isOpen = true;
        }];
    }
}
- (void)hideDetails
{
    if(isOpen && !isAnimating)
    {
        isAnimating = true;
        [UIView animateWithDuration:0.2 animations:^{
            self.dateView.alpha = 0;
            self.descView.alpha = 0;
            self.menuTopConstraint.constant = -64;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
                isAnimating = false;
                isOpen = false;
        }];
    }
}

#pragma mark UINavigationControllerDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if (fromVC == self && [toVC isKindOfClass:[GridViewController class]]) {
        return [[DetailToGridTransition alloc] init];
    }
    else {
        return nil;
    }
}



@end
