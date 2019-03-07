//
//  LineChartView.m
//  ecmc
//
//  Created by 王文杰 on 16/1/5.
//  Copyright © 2016年 cp9. All rights reserved.
//

#import "LineChartView.h"
@interface LineChartView (){
    
    NSArray     *_pointYArray;
    NSMutableArray  *_pointsArray;
}

@end
@implementation LineChartView
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    
    [self costArray:_valueArray monthArray:_monthArray pitchmonth:_pitchmonth];
}
- (void)costArray:(NSArray *)cost monthArray:(NSArray *)month pitchmonth:(NSString *)pitchmonth {
    
    
    //绘制坐标系
    for (int i=0; i<4; i++) {
        // 创建path
        UIColor *color = [UIColor lightGrayColor];
        [color set]; //设置线条颜色
        UIBezierPath *x = [UIBezierPath bezierPath];
        // 添加路径[1条点(100,100)到点(200,100)的线段]到path
        [x moveToPoint:CGPointMake(20 , i*45+25)];
        [x addLineToPoint:CGPointMake(self.window.bounds.size.width-20, i*45+25)];
        // 将path绘制出来
        [x stroke];
    }
//    for (int i=0; i<6; i++) {
//        // 创建path
//        UIColor *color = [UIColor colorWithRed:198/255.0 green:237/255.0 blue:249/255.0 alpha:1];
//        [color set]; //设置线条颜色
//        
//        UIBezierPath *y = [UIBezierPath bezierPath];
//        // 添加路径[1条点(100,100)到点(200,100)的线段]到path
//        [y moveToPoint:CGPointMake(50+((self.window.bounds.size.width-100)/5)*i , 0)];
//        [y addLineToPoint:CGPointMake(50+((self.window.bounds.size.width-100)/5)*i, 160)];
//        // 将path绘制出来
//        [y stroke];
//    }
    
    //绘制折线走势
    if (cost.count > 0 || month.count > 0) {
        float max = [[cost valueForKeyPath:@"@max.intValue"] floatValue];
        float value = 135/max;
        
        UIBezierPath *Polyline = [UIBezierPath bezierPath];
        NSMutableArray *costArray = [[NSMutableArray alloc] initWithArray:cost];
//        [costArray insertObject:@"0" atIndex:0];
//        [costArray insertObject:@"0" atIndex:0];
        [costArray insertObject:@"0" atIndex:cost.count-1];
        [costArray insertObject:@"0" atIndex:cost.count-1];
        [costArray insertObject:@"0" atIndex:cost.count-1];
        
//        [costArray insertObject:@"0" atIndex:cost.count-1];
        _pointsArray = @[].mutableCopy;
        for (int i = 0; i < cost.count; i++) {
            CGPoint point = CGPointMake(50+((self.window.bounds.size.width-100)/5)*(i), 160-([cost[i] floatValue]*value));
            NSValue *value = [NSValue valueWithCGPoint:CGPointMake(point.x, point.y)];
            [_pointsArray addObject:value];
        }
        NSValue *firstPointValue = [NSValue valueWithCGPoint:CGPointMake(0, (CGRectGetHeight(self.frame)) / 2)];
        [_pointsArray insertObject:firstPointValue atIndex:0];
        NSValue *endPointValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.frame), (CGRectGetHeight(self.frame)) / 2)];
        [_pointsArray addObject:endPointValue];
        
        for (int i = 0; i < cost.count-1; i++) {

            // 添加路径[1条点(100,100)开始增结束减开始和结束总和100到点(200,100)开始增结束减开始和结束总和320的线段]到path
            [Polyline moveToPoint:CGPointMake(50+((self.window.bounds.size.width-100)/5)*i , 160-([cost[i] floatValue]*value))];
            
            CGPoint p1 = [[_pointsArray objectAtIndex:i] CGPointValue];
            CGPoint p2 = [[_pointsArray objectAtIndex:i+1] CGPointValue];
            CGPoint p3 = [[_pointsArray objectAtIndex:i+2] CGPointValue];
            CGPoint p4 = [[_pointsArray objectAtIndex:i+3] CGPointValue];
            [self getControlPointx0:p1.x andy0:p1.y x1:p2.x andy1:p2.y x2:p3.x andy2:p3.y x3:p4.x andy3:p4.y path:Polyline];
            
            //[Polyline addLineToPoint:CGPointMake(50+((self.window.bounds.size.width-100)/5)*(i+1), 160-([cost[i+1] floatValue]*value))];
            
            
            //设置线条宽度
            Polyline.lineWidth = 1;
            //设置颜色
            [[UIColor clearColor] set];
            
            // 将path绘制出来
            [Polyline stroke];
            
        }
        
        
        //添加CAShapeLayer
        CAShapeLayer *shapeLine = [[CAShapeLayer alloc]init];
        //设置颜色
        shapeLine.strokeColor = [UIColor blueColor].CGColor;
        //设置宽度
        shapeLine.fillColor = [[UIColor clearColor] CGColor];
        shapeLine.lineWidth = 2;
        //把CAShapeLayer添加到当前视图CAShapeLayer
        [self.layer addSublayer:shapeLine];
        //把Polyline的路径赋予shapeLine
        shapeLine.path = Polyline.CGPath;
        
        //开始添加动画
        [CATransaction begin];
        //创建一个strokeEnd路径的动画
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        //动画时间
        pathAnimation.duration = 3.0;
        //添加动画样式
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        //动画起点
        pathAnimation.fromValue = @0.0f;
        //动画停止位置
        pathAnimation.toValue   = @1.0f;
        //把动画添加到CAShapeLayer
        [shapeLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        //动画终点
        shapeLine.strokeEnd = 1.0;
        //结束动画
        [CATransaction commit];
        
        for (int i = 0; i<cost.count; i++) {
            //坐标数值;
            UILabel * costValueLb = [[UILabel alloc]initWithFrame:CGRectMake(25+((self.bounds.size.width-100)/5)*i, 135-([cost[i] floatValue]*value), 50, 15)];
            costValueLb.text = [NSString stringWithFormat:@"%@",cost[i]];
            costValueLb.font = [UIFont systemFontOfSize:12];
            costValueLb.textAlignment = NSTextAlignmentCenter;
            [self addSubview:costValueLb];
            costValueLb.hidden = YES;
            
            //坐标圆点;
            UIView * cercle = [[UIView alloc]initWithFrame:CGRectMake(45+((self.bounds.size.width-100)/5)*i, 155-([cost[i] floatValue]*value),10, 10)];
            cercle.layer.cornerRadius = 5;
            [self addSubview:cercle];
            costValueLb.textColor = [UIColor blackColor];
            cercle.backgroundColor = [UIColor colorWithRed:26/255.0 green:181/255.0 blue:232/255.0 alpha:1];
            cercle.hidden = YES;
            //月份;
//            UILabel * monthLb = [[UILabel alloc]initWithFrame:CGRectMake(25+((self.bounds.size.width-100)/5)*i, 170, 50, 20)];
//            monthLb.text = [NSString stringWithFormat:@"%@",month[i]];
//            monthLb.textAlignment = NSTextAlignmentCenter;
//            [self addSubview:monthLb];
//
//            
//            monthLb.textColor = [UIColor blackColor];

        }

    }
}

- (void)getControlPointx0:(CGFloat)x0 andy0:(CGFloat)y0
                       x1:(CGFloat)x1 andy1:(CGFloat)y1
                       x2:(CGFloat)x2 andy2:(CGFloat)y2
                       x3:(CGFloat)x3 andy3:(CGFloat)y3
                     path:(UIBezierPath*) path{
    CGFloat smooth_value =0.6;
    CGFloat ctrl1_x;
    CGFloat ctrl1_y;
    CGFloat ctrl2_x;
    CGFloat ctrl2_y;
    CGFloat xc1 = (x0 + x1) /2.0;
    CGFloat yc1 = (y0 + y1) /2.0;
    CGFloat xc2 = (x1 + x2) /2.0;
    CGFloat yc2 = (y1 + y2) /2.0;
    CGFloat xc3 = (x2 + x3) /2.0;
    CGFloat yc3 = (y2 + y3) /2.0;
    CGFloat len1 = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0));
    CGFloat len2 = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1));
    CGFloat len3 = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2));
    CGFloat k1 = len1 / (len1 + len2);
    CGFloat k2 = len2 / (len2 + len3);
    CGFloat xm1 = xc1 + (xc2 - xc1) * k1;
    CGFloat ym1 = yc1 + (yc2 - yc1) * k1;
    CGFloat xm2 = xc2 + (xc3 - xc2) * k2;
    CGFloat ym2 = yc2 + (yc3 - yc2) * k2;
    ctrl1_x = xm1 + (xc2 - xm1) * smooth_value + x1 - xm1;
    ctrl1_y = ym1 + (yc2 - ym1) * smooth_value + y1 - ym1;
    ctrl2_x = xm2 + (xc2 - xm2) * smooth_value + x2 - xm2;
    ctrl2_y = ym2 + (yc2 - ym2) * smooth_value + y2 - ym2;
    [path addCurveToPoint:CGPointMake(x2, y2) controlPoint1:CGPointMake(ctrl1_x, ctrl1_y) controlPoint2:CGPointMake(ctrl2_x, ctrl2_y)];
}

@end


