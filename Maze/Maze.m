//
//  Maze.m
//  Maze
//
//  Created by Abhijit Joshi on 5/21/14.
//  Copyright (c) 2014 Misha software solutions. All rights reserved.
//

#import "Maze.h"

@implementation Maze
@synthesize nx, ny;
@synthesize LGEO;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // get the current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // context size in pixels
    size_t WIDTH = CGBitmapContextGetWidth(context);
    size_t HEIGHT = CGBitmapContextGetHeight(context);
    
    // for retina display, 1 point = 2 pixels
    // context size in screen points
    float width = WIDTH/2.0;
    float height = HEIGHT/2.0;
    
    float dx = width/nx;
    float dy = height/ny;
    
    UIColor *mazeColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    
    for (int i = 0; i < nx; i++) {
        for (int j = 0; j < ny; j++) {
            int N = i + j*nx;
            int val = [[LGEO objectAtIndex:N] intValue];
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, i*dx, j*dy);
            CGContextAddLineToPoint(context, (i+1)*dx, j*dy);
            CGContextAddLineToPoint(context, (i+1)*dx, (j+1)*dy);
            CGContextAddLineToPoint(context, i*dx, (j+1)*dy);
            CGContextClosePath(context);
            
            if (val == 0) {
                [[UIColor blackColor] setFill];
            }
            else {
                [mazeColor setFill];
            }
            [[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0] setStroke];
            CGContextDrawPath(context, kCGPathFillStroke);
        }
    }
}

@end
