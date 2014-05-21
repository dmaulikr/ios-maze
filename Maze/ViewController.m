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

@interface ViewController ()
@property (strong, nonatomic) Model* model;
@property (strong, nonatomic) IBOutlet DrawMaze *blackBox;
@end

@implementation ViewController

@synthesize model;
@synthesize blackBox;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // model
    model = [[Model alloc] init];
    model.nx = 20;
    model.ny = 20;
    
    // view
    blackBox.nx = model.nx;
    blackBox.ny = model.ny;

    [self.view addSubview:blackBox];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
