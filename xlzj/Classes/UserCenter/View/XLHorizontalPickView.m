//
//  XLHorizontalPickView.m
//  xlzj
//
//  Created by zhouxg on 16/5/9.
//  Copyright © 2016年 zhouxg. All rights reserved.
//

#define CELL_ID @"MBCell"
#define LAYOUT_ITEM_OFFSET  20

#import "XLHorizontalPickView.h"

@interface XLCollectionLayout : UICollectionViewFlowLayout

@end

@interface XLCollectionCell : UICollectionViewCell
@property (nonatomic ,strong) UILabel *nameLabel;
@end

@interface XLHorizontalPickView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    UIButton *confirmBtn;
    UICollectionView *mainCollectionView;
    XLCollectionLayout *collectionLayout;
}
@end

@implementation XLCollectionLayout
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumInteritemSpacing = LAYOUT_ITEM_OFFSET * 2;
    }
    return self;
}
/**
 *  重新布局
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

static CGFloat const ActiveDistance = 80;
static CGFloat const ScaleFactor = 0.2;


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
    
    for (UICollectionViewLayoutAttributes *attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            attributes.alpha = 0.5;
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x; // 距离屏幕中心点位置
            CGFloat normalizedDistance = distance / ActiveDistance;
            if (ABS(distance) < ActiveDistance) {
                CGFloat zoom = 1 + ScaleFactor * (1 - ABS(normalizedDistance));  // 放大
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = 1;
                attributes.alpha = 1.0;
            }
        }
    }
    return array;
}

/**
 *  将所选条目移动到中心点位置
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    //  |-------[-------]-------|
    //  |滑动偏移|可视区域 |剩余区域|
    //是整个collectionView在滑动偏移后的当前可见区域的中点
    CGFloat centerX = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    //    CGFloat centerX = self.collectionView.center.x; //这个中点始终是屏幕中点
    // 输出的是屏幕大小，但实际上宽度肯定超出屏幕的
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    for (UICollectionViewLayoutAttributes *layoutAttr in array) {
        CGFloat itemCenterX = layoutAttr.center.x;
        if (ABS(itemCenterX - centerX) < ABS(offsetAdjustment)) { // 找出最小的offset 也就是最中间的item 偏移量
            offsetAdjustment = itemCenterX - centerX;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}
@end

@implementation XLCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(nonnull NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    NSLog(@"cell inited");
    self.layer.doubleSided = NO;
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.origin.x, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    _nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_nameLabel];
}
@end

@implementation XLHorizontalPickView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self initView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initView];
    }
    return self;
}
- (void)initData
{
    _acuteScroll = YES;
    _showIndicator = NO;
    
    collectionLayout = [[XLCollectionLayout alloc] init];
    mainCollectionView = nil;
}
- (void)initView
{
    CGRect rect = self.bounds;
    
    if (mainCollectionView) {
        [mainCollectionView removeFromSuperview];
        mainCollectionView = nil;
    }
    
    //IndoorNavigation
    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:@"确    定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:20.0];
    confirmBtn.backgroundColor = [UIColor blueColor];
    [self addSubview:confirmBtn];
    [confirmBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(CGRectGetHeight(rect) - 60, 0, 0, 0) excludingEdge:ALEdgeBottom];
    [confirmBtn autoSetDimension:ALDimensionHeight toSize:60.0];
    
    mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, CGRectGetHeight(rect) - 60.0) collectionViewLayout:collectionLayout];
    mainCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mainCollectionView.showsHorizontalScrollIndicator = _showIndicator;
    mainCollectionView.decelerationRate = _acuteScroll ? UIScrollViewDecelerationRateNormal : UIScrollViewDecelerationRateFast;
    mainCollectionView.backgroundColor = [UIColor clearColor];
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
    [mainCollectionView registerClass:[XLCollectionCell class] forCellWithReuseIdentifier:CELL_ID];
    [self addSubview:mainCollectionView];
    
}
- (NSInteger)getCenterCellIndex
{
    CGFloat x = (CGRectGetWidth(mainCollectionView.bounds) / 2.) + mainCollectionView.contentOffset.x;
    CGFloat y = mainCollectionView.center.y;
    CGPoint point = CGPointMake(x, y);
    
    NSIndexPath *indexPath = [mainCollectionView indexPathForItemAtPoint:point];
    if (indexPath != nil) {
        return indexPath.row;
    } else {
        return -1;
    }
}

- (void)confirmBtnClicked
{
    XLAppDelegate *appDelegate = (XLAppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.canSoundPlay)
    {
        // 开始播放\继续播放
        [appDelegate.player play];
        [ECMusicTool stopMusic:appDelegate.songs[1]];
        [ECMusicTool playMusic:appDelegate.songs[1]];
    }
    
    self.superview.hidden = YES;
    NSInteger index = [self getCenterCellIndex];
    if (index < 0) {
        return;
    }
    
    BOOL isChanged = false;
    if (_centerIndex != index) {
        _centerIndex = index;
        isChanged = YES;
        NSIndexPath *selection = [NSIndexPath indexPathForItem:_centerIndex inSection:0];
        [mainCollectionView scrollToItemAtIndexPath:selection atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectItemAtIndex:isChanged:)]) {
        [_delegate selectItemAtIndex:_centerIndex isChanged:isChanged];
    }
}

#pragma mark - CollectionViewDataSource
#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _itemTitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XLCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    cell.nameLabel.text = _itemTitles[indexPath.row];
    return cell;
}

#pragma mark - CollectionViewDelegate
#pragma mark -
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 选中 item
    [mainCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    // 滚到中心点
    [mainCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - CollectionViewFlowLayoutDelegate
#pragma mark -
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = 60.0;
    
    // [item0]-offset-|-offset-[item1]-offset-|-offset-[item2]
    
    // set the height equal to collection to ensure all items stay in one line
    return CGSizeMake(itemWidth + 2 * LAYOUT_ITEM_OFFSET, collectionView.bounds.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    NSInteger itemCount = [self collectionView:collectionView numberOfItemsInSection:section];
    
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    CGSize firstItemSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:firstIndexPath];
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:itemCount - 1 inSection:section];
    CGSize lastItemSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:lastIndexPath];
    
    return UIEdgeInsetsMake(0, (collectionView.bounds.size.width - firstItemSize.width) / 2,
                            0, (collectionView.bounds.size.width - lastItemSize.width) / 2);
}

#pragma mark - ScrollViewDelegate
#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSInteger index = [self getCenterCellIndex];
//    if (index < 0) {
//        return;
//    }
//    
//    if (centerIndex == index) {
//        return;
//    }
//    
//    centerIndex = index;
    
//    if (_delegate && [_delegate respondsToSelector:@selector(selectItemAtIndex:)]) {
//        [_delegate selectItemAtIndex:centerIndex];
//    }
    
//    [mainCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:centerIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

#pragma mark - public func
#pragma mark -
- (void)scrollToHead
{
    [mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)scrollToCenter
{
    [mainCollectionView reloadData];
    NSIndexPath *selection = [NSIndexPath indexPathForItem:(NSInteger)floor([self.itemTitles count] / 2.0) inSection:0];
    [mainCollectionView scrollToItemAtIndexPath:selection atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)scrollToTail
{
    [mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_itemTitles.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)updateData
{
    [self initView];
    [self scrollToCenter];
}
@end
