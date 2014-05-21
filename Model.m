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
@synthesize x,y,R,ux,uy,ax,ay;

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
    }
    
    return self;
}

@end