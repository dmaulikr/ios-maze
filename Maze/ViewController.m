//
//  ViewController.m
//  Maze
//
//  Created by Abhijit Joshi on 5/21/14.
//  Copyright (c) 2014 Misha software solutions. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "Model.h"
#import "Maze.h"
#import "Ball.h"

@interface ViewController ()
@property (nonatomic, strong) CMMotionManager* motionManager;
@property (strong, nonatomic) NSTimer* timer;
@property (strong, nonatomic) Model* model;
@property (strong, nonatomic) Ball* ball;
@property (strong, nonatomic) IBOutlet UIView *blackBox;
@property (strong, nonatomic) Maze* maze;
- (IBAction)clearAllBlocks:(id)sender;
@end

@implementation ViewController

@synthesize motionManager;
@synthesize timer;
@synthesize model;
@synthesize ball;
@synthesize blackBox;
@synthesize maze;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // model
    model = [[Model alloc] init];
    
    float width = blackBox.frame.size.width;
    float height = blackBox.frame.size.height;
    model.width = width;
    model.height = height;
    float dx = width / model.nx;
    float dy = height / model.ny;
    model.R = dx/3.0;
    model.x = width/2.0;
    model.y = height/2.0;
    model.ux = 0.0;
    model.uy = 0.0;
    
    // initialize Ball object
    CGRect ballRect = CGRectMake(100, 100, dx , dy);
    ball = [[Ball alloc] initWithFrame:ballRect];
    [ball setBackgroundColor:[UIColor clearColor]];
    
    // initialize maze object
    CGRect mazeRect = CGRectMake(0, 0, model.width , model.height);
    maze = [[Maze alloc] initWithFrame:mazeRect];
    maze.nx = model.nx;
    maze.ny = model.ny;
    maze.LGEO = model.LGEO;

    // initialize motion manager
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = 1.0/120.0;
    
    if ([motionManager isAccelerometerAvailable]) {
        
        [self startGameLoop];
        
    } else {
        
        NSLog(@"No accelerometer! You may be running on the iOS simulator...");
    }
    
    [blackBox addSubview:maze];
    [blackBox addSubview:ball];
}

- (void) startGameLoop
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // acceleration components (X, Y and Z)
            model.ax = accelerometerData.acceleration.x;
            model.ay = accelerometerData.acceleration.y;
        });
    }];
    
    // begin animation
    timer = [NSTimer timerWithTimeInterval:1.0/120.0
                                    target:self
                                  selector:@selector(update)
                                  userInfo:nil
                                   repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

// update model parameters and plot the ball using the view
- (void) update
{
    // update maze
    [blackBox addSubview:maze];
    [maze setNeedsDisplay];
    
    // update ball position
    [model updateBallPosition];
    
    // draw the ball at the new location
    float x = model.x;
    float y = model.y;
    float R = model.R;

    ball.frame = CGRectMake(x-R, y-R, 2*R, 2*R);
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
        
        // if touch is within array bounds, toggle LGEO value
        if (xIndex >=0 && xIndex < model.nx && yIndex >=0 && yIndex < model.ny) {
            int val = [[model.LGEO objectAtIndex:N] intValue];
            
            // update entry at that location in the model
            [model.LGEO removeObjectAtIndex:N];
            [model.LGEO insertObject:@(1-val) atIndex:N];

            [maze.LGEO removeObjectAtIndex:N];
            [maze.LGEO insertObject:@(1-val) atIndex:N];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearAllBlocks:(id)sender {
    for (int i = 0; i < model.nx*model.ny; i++) {
        [model.LGEO removeObjectAtIndex:i];
        [model.LGEO insertObject:@(0) atIndex:i];
    }
}

@end