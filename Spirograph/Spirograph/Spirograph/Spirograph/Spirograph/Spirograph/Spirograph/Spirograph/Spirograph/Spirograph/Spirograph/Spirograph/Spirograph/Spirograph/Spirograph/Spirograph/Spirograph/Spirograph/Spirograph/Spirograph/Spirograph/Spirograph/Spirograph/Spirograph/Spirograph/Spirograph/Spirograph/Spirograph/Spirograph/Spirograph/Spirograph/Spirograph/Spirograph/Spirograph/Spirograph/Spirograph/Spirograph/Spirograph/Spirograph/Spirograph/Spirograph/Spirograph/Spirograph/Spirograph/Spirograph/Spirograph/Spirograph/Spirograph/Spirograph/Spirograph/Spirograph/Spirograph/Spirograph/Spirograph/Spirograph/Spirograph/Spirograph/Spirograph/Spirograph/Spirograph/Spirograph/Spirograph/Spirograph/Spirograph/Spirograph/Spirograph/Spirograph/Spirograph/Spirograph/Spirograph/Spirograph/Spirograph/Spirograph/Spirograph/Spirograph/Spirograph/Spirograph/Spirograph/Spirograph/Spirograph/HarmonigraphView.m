//
//  HarmonigraphView.m
//  Spirograph
//
//  Created by Michael Toth on 2/20/14.
//  Copyright (c) 2014 Michael Toth. All rights reserved.
//

#import "HarmonigraphView.h"

@implementation HarmonigraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGFloat x,y;
    UIBezierPath *bz = [[UIBezierPath alloc] init];
    CGFloat t=0.0;
    CGFloat K=70;
    CGFloat e=2.718;
    CGFloat f1 = 1.0+(arc4random()%9);
    CGFloat f2 = 1.0+(arc4random()%9);
    CGFloat f3 = 1.0+(arc4random()%9);
    CGFloat f4 = 1.0+(arc4random()%9);
    int p1 = arc4random()%360;
    int p2 = arc4random()%360;
    int p3 = arc4random()%360;
    int p4 = arc4random()%360;
    x=140+K*pow(e,-0.00015*t)*(sin(f1*t+p1)+sin(f2*t+p2));
    y=140+K*pow(e,-0.00015*t)*(sin(f3*t+p3)+sin(f4*t+p4));
    CGPoint p=CGPointMake(x, y);
    [bz moveToPoint:p];
    for (t=0; t<100; t=t+.01) {
        x=140+K*pow(e,-0.00015*t)*(sin(f1*t+p1)+sin(f2*t+p2));
        y=140+K*pow(e,-0.00015*t)*(sin(f3*t+p3)+sin(f4*t+p4));
        p=CGPointMake(x, y);
        [bz addLineToPoint:p];
    }
    [bz stroke];

}


@end
