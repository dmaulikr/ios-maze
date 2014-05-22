//
//  Model.m
//  Maze
//
//  Created by Abhijit Joshi on 5/21/14.
//  Copyright (c) 2014 Misha software solutions. All rights reserved.
//

#import "Model.h"

@implementation Model

@synthesize nx, ny;
@synthesize LGEO;
@synthesize width, height;
@synthesize x,y,R,ux,uy,ax,ay;
@synthesize COR;

// override superclass implementation of init
-(id) init
{
    self = [super init];
    if (self) {
        nx = 10;
        ny = 10;
        LGEO = [[NSMutableArray alloc] initWithCapacity:nx*ny];
        for (int i = 0; i < nx*ny; i++) {
            int value = 0;
            [LGEO addObject:@(value)];
        }
        COR = 0.5;
    }
    
    return self;
}

- (void) updateBallPosition
{
    // kinematics
    x += 0.5*ux;
    y += -0.5*uy;
    
    // check for collisions with walls
    if (x > width - R) {
        x = width - R;
        ux = -fabsf(ux)*COR;
    }
    if (y > height - R) {
        y = height - R;
        uy = fabsf(uy)*COR;
    }
    if (x < R) {
        x = R;
        ux = fabsf(ux)*COR;
    }
    if (y < R) {
        y = R;
        uy = -fabsf(uy)*COR;
    }
    
    // check for collision with maze blocks
    float dx = width / nx;
    float dy = height / ny;
    
    // find out array location where the ball center is located
    int xIndex = x/dx;
    int yIndex = y/dy;
    
    // center point of the square
    float xCenter = dx/2 + xIndex*dx;
    float yCenter = dy/2 + yIndex*dy;
    
    // ball coordinates relative to the square center
    float xRel = x - xCenter;
    float yRel = y - yCenter;

    int N = (xIndex) + nx*(yIndex);
    
    int val = [[LGEO objectAtIndex:N] intValue];
    
    if (val == 1) {
        // inside a solid block
        if (fabsf(xRel) > fabsf(yRel)) {
            ux = -ux;
            x += ux;
        } else {
            uy = -uy;
            y += -uy;
        }
    }
    
    // dynamics
    ux += 0.2*ax;
    uy += 0.2*ay;
}

@end