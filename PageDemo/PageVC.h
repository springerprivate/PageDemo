//
//  PageVC.h
//  PageDemo
//
//  Created by agui on 2024/8/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PageVC : UIViewController

/// 显示下标
@property (nonatomic,assign)NSInteger displayIndex;

@property (nonatomic,strong)NSArray <NSString *>*dataArr;

@end

NS_ASSUME_NONNULL_END
