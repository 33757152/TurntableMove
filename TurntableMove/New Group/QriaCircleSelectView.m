//
//  QriaCircleSelectView.m
//  TurntableMove
//
//  Created by 张锦江 on 2019/11/25.
//  Copyright © 2019 zyy. All rights reserved.
//

#import "QriaCircleSelectView.h"

@interface QriaCircleSelectView ()

@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *controlSender;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, copy) NSMutableArray<CAShapeLayer *> *layerMArray;

@end

@implementation QriaCircleSelectView

- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArray = titleArray;
        [self giveProbabilityArrayDefaultValue];
        self.layer.cornerRadius = self.frame.size.width/2;
        self.clipsToBounds = YES;
        [self addSubview:self.bottomView];
        [self addEveryItems];
    }
    return self;
}

- (void)giveProbabilityArrayDefaultValue {
    NSInteger totalCount = _titleArray.count;
    CGFloat probabilityFloat = 1.0f/totalCount;
    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i<totalCount; i++) {
        [marr addObject:[NSNumber numberWithFloat:probabilityFloat]];
    }
    self.probabilityArray = marr;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return _bottomView;
}

- (UIButton *)controlSender {
    if (!_controlSender) {
        _controlSender = [UIButton buttonWithType:UIButtonTypeCustom];
        _controlSender.backgroundColor = [UIColor grayColor];
        _controlSender.bounds = CGRectMake(0, 0, 70, 70);
        _controlSender.layer.cornerRadius = 70/2;
        _controlSender.clipsToBounds = YES;
        [_controlSender setTitle:@"Start" forState:UIControlStateNormal];
        [_controlSender setTitle:@"Stop" forState:UIControlStateSelected];
        [_controlSender addTarget:self action:@selector(startStopResponse:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _controlSender;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.bounds = CGRectMake(0, 0, 30, 30);
        _arrowImageView.image = [UIImage imageNamed:@"arrow"];
    }
    return _arrowImageView;
}

- (NSMutableArray<CAShapeLayer *> *)layerMArray {
    if (!_layerMArray) {
        _layerMArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _layerMArray;
}

- (void)addEveryItems {
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
    NSInteger totalCount = _titleArray.count;
    for (NSInteger i = 0; i<totalCount; i++) {
        CGFloat everyAngle = 2.0f*M_PI/totalCount;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:centerPoint];
        [bezierPath addArcWithCenter:centerPoint radius:self.frame.size.width/2 startAngle:everyAngle*i endAngle:everyAngle*(i+1) clockwise:YES];
        [bezierPath stroke];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = bezierPath.CGPath;
        shapeLayer.fillColor = [UIColor colorWithRed:arc4random()%256/255.0f green:arc4random()%256/255.0f blue:arc4random()%256/255.0f alpha:1].CGColor;
        shapeLayer.strokeColor = [[UIColor clearColor] CGColor];
        [_bottomView.layer addSublayer:shapeLayer];
        [self.layerMArray addObject:shapeLayer];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = _titleArray[i];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.numberOfLines = 0;
        CGFloat currentAngle_middle = everyAngle*(i + 0.5);
        CGFloat y = sin(currentAngle_middle)*self.frame.size.width/4;
        CGFloat x = cos(currentAngle_middle)*self.frame.size.width/4;
        label.center = CGPointMake(self.frame.size.width/2 + x, self.frame.size.width/2 + y);
        label.bounds = CGRectMake(0, 0, self.frame.size.width/2 - 40, 40);
        label.transform = CGAffineTransformMakeRotation(currentAngle_middle);
        [_bottomView addSubview:label];
    }

    [self addSubview:self.controlSender];
    _controlSender.center = centerPoint;
    
    [self addSubview:self.arrowImageView];
    _arrowImageView.center = CGPointMake(centerPoint.x, centerPoint.y - 35);
}

- (void)setProbabilityArray:(NSArray<NSNumber *> *)probabilityArray {
    if (probabilityArray) {
        float sum = 0.0f;
        for (NSNumber *num in probabilityArray) {
            sum += [num floatValue];
        }
        if (sum <= 1) {
            _probabilityArray = probabilityArray;
        }
    }
}

- (void)setColorArray:(NSArray<UIColor *> *)colorArray {
    if (colorArray && colorArray.count == _titleArray.count) {
        _colorArray = colorArray;
        for (NSInteger i = 0; i<_colorArray.count; i++) {
            CAShapeLayer *shapeLayer = [self.layerMArray objectAtIndex:i];
            shapeLayer.fillColor = [_colorArray[i] CGColor];
        }
    }
}

- (void)startStopResponse:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.keyPath = @"transform.rotation.z";
        animation.fromValue = @(0);
        animation.toValue = @(2.f*M_PI);
        animation.duration = 0.8;
        animation.repeatCount = MAXFLOAT;
        [_bottomView.layer addAnimation:animation forKey:nil];
    } else {
        NSMutableArray *marray = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = 0; i<_probabilityArray.count; i++) {
            int a = [_probabilityArray[i] floatValue] * 100;
            for (NSInteger j = 0; j<a; j++) {
                [marray addObject:@(i)];
            }
        }
        int b = arc4random()%marray.count;
        int i = [marray[b] intValue]+1;
        CGFloat everyAngle = 2.f*M_PI/_titleArray.count;
        CGFloat moveAngle = (i - 1)*everyAngle+everyAngle*0.5+M_PI*0.5;
        _bottomView.transform = CGAffineTransformMakeRotation(-moveAngle);
        [_bottomView.layer removeAllAnimations];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
