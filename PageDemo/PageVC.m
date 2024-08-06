//
//  PageVC.m
//  PageDemo
//
//  Created by agui on 2024/8/6.
//

#import "PageVC.h"

@interface PageVC ()<UITableViewDelegate,UITableViewDataSource>{
    CGFloat _beginDragOffsetY;
    CGFloat _endDragOffsetY;
}

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSIndexPath *currentIndexPath;//当前下标

@property (nonatomic,strong)NSMutableArray <NSString *>* muDataArr;

@end

@implementation PageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self rrDrawUI];
    [self rrLayoutUI];
    [self.tableView reloadData];
    [self performSelector:@selector(beginDisplay) withObject:nil afterDelay:0.25];
}
#pragma mark -operation
- (void)beginDisplay{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:MAX(0, MIN(self.displayIndex, [self.muDataArr count] - 1)) inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self rrDidDisplayCell:cell forRowAtIndexPath:indexPath];
    });
}
#pragma mark - set
- (void)setDataArr:(NSArray<NSString *> *)dataArr{
    _dataArr = dataArr;
    [self.muDataArr addObjectsFromArray:dataArr];
}
#pragma mark -delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.muDataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen mainScreen].bounds.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    videoCell.backgroundColor = [UIColor colorWithRed:(arc4random() % 255) / 255.0 green:(arc4random() % 255) / 255.0 blue:(arc4random() % 255) / 255.0 alpha:1];
    return videoCell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _beginDragOffsetY = scrollView.contentOffset.y;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    _endDragOffsetY = scrollView.contentOffset.y;
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.tableView scrollToRowAtIndexPath:[self displayIndexPath] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSIndexPath *displayIndexpath = [self displayIndexPath];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:displayIndexpath];
    [self rrDidDisplayCell:cell forRowAtIndexPath:displayIndexpath];
}
- (void)rrDidDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {// 换页完成
    if (self.currentIndexPath == indexPath) {
        return;
    }
    if (!cell) {
        return;
    }
    self.currentIndexPath = indexPath;
}

- (NSIndexPath *)displayIndexPath{
    CGFloat dragOffset = _endDragOffsetY - _beginDragOffsetY;
    NSInteger row = self.currentIndexPath.row;
    if (dragOffset >= 50) {
        row += 1;
        row = MIN(row, [self.muDataArr count] - 1);
    }else if(dragOffset <= -50){
        row -= 1;
        row = MAX(row, 0);
    }
    NSArray<NSIndexPath *> *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
    NSIndexPath *selectedIndexPath = nil;
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        if (row == indexPath.row) {
            selectedIndexPath = indexPath;
            break;
        }
    }
    if (nil == selectedIndexPath) {
        selectedIndexPath = [visibleIndexPaths lastObject];
    }
    return selectedIndexPath;
}
#pragma mark -UI
- (void)rrDrawUI{
    [self.view addSubview:self.tableView];
}
- (void)rrLayoutUI{
    self.tableView.frame = [UIScreen mainScreen].bounds;
}

#pragma mark -lazy load
- (UITableView *)tableView{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.pagingEnabled = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        if (@available(iOS 15.0, *)) {
            _tableView.prefetchingEnabled = NO;
        }
    }
    return _tableView;
}
- (NSMutableArray<NSString *> *)muDataArr{
    if (nil == _muDataArr) {
        _muDataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _muDataArr;
}

@end
