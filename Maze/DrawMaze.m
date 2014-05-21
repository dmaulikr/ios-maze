//
//  DrawMaze.m
//  Maze
//
//  Created by Abhijit Joshi on 5/21/14.
//  Copyright (c) 2014 Misha software solutions. All rights reserved.
//

#import "DrawMaze.h"

@implementation DrawMaze
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

    LGEO = [[NSMutableArray alloc] initWithCapacity:16];
    for (int i = 0; i < nx*ny; i++) {
        int value = 0;
        if (i>4 && i<10) value = 1;
        [LGEO addObject:@(value)];
    }

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
                [[UIColor whiteColor] setFill];
            }
            [[UIColor yellowColor] setStroke];
            CGContextDrawPath(context, kCGPathFillStroke);
        }
    }
}

@end
