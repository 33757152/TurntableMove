//
//  QriaCircleSelectView.h
//  TurntableMove
//
//  Created by 张锦江 on 2019/11/25.
//  Copyright © 2019 zyy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QriaCircleSelectView : UIView

- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleArray;

/// 决定每格盘出现的概率，如果不传，默认为均等概率
/// 传输格式: @[@0.10, @0.20...]
@property (nonatomic, copy) NSArray<NSNumber *> *probabilityArray;

/// 颜色数组
@property (nonatomic, copy) NSArray<UIColor *> *colorArray;

@end

NS_ASSUME_NONNULL_END
