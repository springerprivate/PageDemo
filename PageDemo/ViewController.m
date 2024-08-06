//
//  ViewController.m
//  PageDemo
//
//  Created by agui on 2024/8/6.
//

#import "ViewController.h"

#import "PageVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 50);
    btn.center = self.view.center;
    [btn setTitle:@"分页界面" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)onBtnClicked{
    NSMutableArray *dataList = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger index = 0; index < 40; index ++) {
        [dataList addObject:@(index).stringValue];
    }
    PageVC *page = [[PageVC alloc] init];
    page.dataArr = [dataList copy];
    page.displayIndex = 20;
    [self.navigationController pushViewController:page animated:YES];
}


@end
