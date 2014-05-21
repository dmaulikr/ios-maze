//
//  ViewController.m
//  Maze
//
//  Created by Abhijit Joshi on 5/21/14.
//  Copyright (c) 2014 Misha software solutions. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"
#import "DrawMaze.h"
#import "Ball.h"

@interface ViewController ()
@property (strong, nonatomic) Model* model;
@property (strong, nonatomic) Ball* ball;
@property (strong, nonatomic) IBOutlet DrawMaze *blackBox;
@end

@implementation ViewController

@synthesize model;
@synthesize ball;
@synthesize blackBox;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // model
    model = [[Model alloc] init];
    
    float width = blackBox.frame.size.width;
    float height = blackBox.frame.size.height;
    float dx = width / model.nx;
    float dy = height / model.ny;
    
    // initialize Ball object
    CGRect ballRect = CGRectMake(100, 100, dx , dy);
    ball = [[Ball alloc] initWithFrame:ballRect];
    [ball setBackgroundColor:[UIColor clearColor]];
    
    // view
    blackBox.nx = model.nx;
    blackBox.ny = model.ny;
    blackBox.LGEO = model.LGEO;

    [self.view addSubview:blackBox];
    [blackBox addSubview:ball];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* t in touches) {
        CGPoint touchLocation;
        touchLocation = [t locationInView:blackBox];
        float x = touchLocation.x;
        float y = touchLocation.y;

        float width = blackBox.frame.size.width;
        float height = blackBox.frame.size.height;
        
        float dx = width / model.nx;
        float dy = height / model.ny;
        
        // find out array location where finger touches the screen
        int xIndex = x/dx;
        int yIndex = y/dy;
        int N = xIndex + model.nx*yIndex;
        int val = [[model.LGEO objectAtIndex:N] intValue];
        
        // update entry at that location in the model
        [model.LGEO removeObjectAtIndex:N];
        [model.LGEO insertObject:@(1-val) atIndex:N];

        [blackBox.LGEO removeObjectAtIndex:N];
        [blackBox.LGEO insertObject:@(1-val) atIndex:N];
        [blackBox setNeedsDisplay];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
