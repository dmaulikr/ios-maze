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
    
    // loop over all neighboring squares
    NSMutableArray* xCenter, *yCenter, *distanceFromCenter;
    NSMutableArray *Nindex, *xIndexNbr, *yIndexNbr;
    xCenter = [[NSMutableArray alloc] initWithCapacity:9];
    yCenter = [[NSMutableArray alloc] initWithCapacity:9];
    distanceFromCenter = [[NSMutableArray alloc] initWithCapacity:9];
    Nindex  = [[NSMutableArray alloc] initWithCapacity:9];
    xIndexNbr = [[NSMutableArray alloc] initWithCapacity:9];
    yIndexNbr = [[NSMutableArray alloc] initWithCapacity:9];
    
    [xCenter insertObject:@(dx/2 + (xIndex-1)*dx) atIndex:0];
    [xCenter insertObject:@(dx/2 + (xIndex)  *dx) atIndex:1];
    [xCenter insertObject:@(dx/2 + (xIndex+1)*dx) atIndex:2];
    [xCenter insertObject:@(dx/2 + (xIndex-1)*dx) atIndex:3];
    [xCenter insertObject:@(dx/2 + (xIndex)  *dx) atIndex:4];
    [xCenter insertObject:@(dx/2 + (xIndex+1)*dx) atIndex:5];
    [xCenter insertObject:@(dx/2 + (xIndex-1)*dx) atIndex:6];
    [xCenter insertObject:@(dx/2 + (xIndex)  *dx) atIndex:7];
    [xCenter insertObject:@(dx/2 + (xIndex+1)*dx) atIndex:8];

    [yCenter insertObject:@(dy/2 + (yIndex-1)*dx) atIndex:0];
    [yCenter insertObject:@(dy/2 + (yIndex-1)*dx) atIndex:1];
    [yCenter insertObject:@(dy/2 + (yIndex-1)*dx) atIndex:2];
    [yCenter insertObject:@(dy/2 + (yIndex)  *dx) atIndex:3];
    [yCenter insertObject:@(dy/2 + (yIndex)  *dx) atIndex:4];
    [yCenter insertObject:@(dy/2 + (yIndex)  *dx) atIndex:5];
    [yCenter insertObject:@(dy/2 + (yIndex+1)*dx) atIndex:6];
    [yCenter insertObject:@(dy/2 + (yIndex+1)*dx) atIndex:7];
    [yCenter insertObject:@(dy/2 + (yIndex+1)*dx) atIndex:8];

    [Nindex insertObject:@((xIndex-1) + nx*(yIndex-1)) atIndex:0];
    [Nindex insertObject:@((xIndex  ) + nx*(yIndex-1)) atIndex:1];
    [Nindex insertObject:@((xIndex+1) + nx*(yIndex-1)) atIndex:2];
    [Nindex insertObject:@((xIndex-1) + nx*(yIndex  )) atIndex:3];
    [Nindex insertObject:@((xIndex  ) + nx*(yIndex  )) atIndex:4];
    [Nindex insertObject:@((xIndex+1) + nx*(yIndex  )) atIndex:5];
    [Nindex insertObject:@((xIndex-1) + nx*(yIndex+1)) atIndex:6];
    [Nindex insertObject:@((xIndex  ) + nx*(yIndex+1)) atIndex:7];
    [Nindex insertObject:@((xIndex+1) + nx*(yIndex+1)) atIndex:8];

    [xIndexNbr insertObject:@(xIndex-1) atIndex:0];
    [xIndexNbr insertObject:@(xIndex  ) atIndex:1];
    [xIndexNbr insertObject:@(xIndex+1) atIndex:2];
    [xIndexNbr insertObject:@(xIndex-1) atIndex:3];
    [xIndexNbr insertObject:@(xIndex  ) atIndex:4];
    [xIndexNbr insertObject:@(xIndex+1) atIndex:5];
    [xIndexNbr insertObject:@(xIndex-1) atIndex:6];
    [xIndexNbr insertObject:@(xIndex  ) atIndex:7];
    [xIndexNbr insertObject:@(xIndex+1) atIndex:8];
    
    // check for possible collision with all applicable neighbors
    for (int index = 0; index < 9; index++) {
        int Nval = [[Nindex objectAtIndex:index] intValue];
        int xNbr = [[xIndexNbr objectAtIndex:index] intValue];
        float xCen = [[xCenter objectAtIndex:index] floatValue];
        float yCen = [[yCenter objectAtIndex:index] floatValue];

        if (xNbr >= 0 && xNbr < nx
              && index != 4
            && fabsf(x-xCen) < (dx/2 + R)
            && fabsf(y-yCen) < (dy/2 + R)
            && Nval >= 0 && Nval < nx*ny) {

            // ball coordinates relative to the square center
            float xRel = x - xCen;
            float yRel = y - yCen;

            int val = [[LGEO objectAtIndex:Nval] intValue];
            
            if (val == 1) {
                
            // hit a solid block
            if (fabsf(xRel) > fabsf(yRel)) {
                ux = -COR*ux;
                x += ux;
            } else {
                uy = -COR*uy;
                y += -uy;
            }
                
            }

        }
    }

    // dynamics
    ux += 0.2*ax;
    uy += 0.2*ay;
}

@end