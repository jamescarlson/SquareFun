//
//  ViewController.m
//  AnimationTester
//
//  Created by James Carlson on 6/29/15.
//  Copyright (c) 2015 dimnsionofsound. All rights reserved.
//

#import "ViewController.h"
#import "UIBoxDropBehavior.h"
#import "AnimatedSquareView.h"
#import <CoreMotion/CoreMotion.h>


const CGSize BOX_SIZE = {32, 32};
const CGSize DEATH_SIZE = {64, 64};

@interface ViewController () <UICollisionBehaviorDelegate, UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;

@property (weak, nonatomic) IBOutlet UIView *myView;
@property (strong, nonatomic) NSMutableArray *myBoxes; //Of boxes
@property (strong, nonatomic) AnimatedSquareView *deathBox;

@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UISlider *gravitySlider;
@property (weak, nonatomic) IBOutlet UILabel *gravitySelectLabel;
@property (weak, nonatomic) IBOutlet UISwitch *destroyEnabled;


@property CGFloat currentGravity;
@property CGVector gravityDirection;

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIBoxDropBehavior *dropBehavior;

#define kUpdateFrequency 30.0
@end

@implementation ViewController

- (AnimatedSquareView *)deathBox {
    if (!_deathBox) {
        _deathBox = [[AnimatedSquareView alloc] initWithFrame:CGRectMake(self.myView.bounds.size.width / 2, self.myView.bounds.size.height / 2, DEATH_SIZE.width, DEATH_SIZE.height)];
        _deathBox.backgroundColor = [UIColor colorWithRed:1.0 green:.3 blue:.3 alpha:1.0];
    }
    return _deathBox;
}

- (CMMotionManager *)motionManager {
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    return _motionManager;
}


- (NSMutableArray *)myBoxes {
    if (!_myBoxes) {
        _myBoxes = [[NSMutableArray alloc] init];
    }
    return _myBoxes;
}

- (UIBoxDropBehavior *)dropBehavior {
    if (!_dropBehavior) {
        _dropBehavior = [[UIBoxDropBehavior alloc] initWithGravityStrength:1.0 direction:CGVectorMake(0, 1) delegate:self];
        [self.animator addBehavior:_dropBehavior];
    }
    return _dropBehavior;
}

- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.myView];
        _animator.delegate = self;
    }
    return _animator;
}




#pragma mark - Accelerometer
- (void)setupAccelerometer {
    self.motionManager.accelerometerUpdateInterval = 1.0 / kUpdateFrequency;
    
}


- (void)handleAccelerometerError {
    [self.motionManager stopAccelerometerUpdates];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Accelerometer had trouble initializing"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Collision with death box

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    NSLog(@"Animator paused! ========");
    
}

- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator {
    NSLog(@"Animator will resume! ========, gravity: %.2f", self.dropBehavior.gravity.magnitude);
    for (AnimatedSquareView *sq in self.myBoxes) {
        [self.dropBehavior addItem:sq];
    }
    
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior
      beganContactForItem:(id<UIDynamicItem>)item1
                 withItem:(id<UIDynamicItem>)item2
                  atPoint:(CGPoint)p {
    if (self.destroyEnabled.on) {
        if ([item1 isEqual:self.deathBox]) {
            [self.dropBehavior removeItem:item2];
            AnimatedSquareView *myDeadBox = (AnimatedSquareView *)item2;
            [myDeadBox removeFromSuperview];
            [self.myBoxes removeObject:item2];
            myDeadBox = nil;

        }
        if ([item2 isEqual:self.deathBox]) {
            [self.dropBehavior removeItem:item1];
            AnimatedSquareView *myDeadBox = (AnimatedSquareView *)item1;
            [myDeadBox removeFromSuperview];
            [self.myBoxes removeObject:item1];
            myDeadBox = nil;

        }
    }
}

#pragma mark - Making and breaking boxes

- (IBAction)clearBoxes:(UIButton *)sender {
    for (AnimatedSquareView *box in self.myBoxes) {
        [self.dropBehavior removeItem:box];
    }
    [self.myBoxes makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.myBoxes removeAllObjects];
    
}

- (void)spawnNewBoxWithLocation:(CGPoint)location {
    //NSLog(@"Box spawned at %f, %f", location.x, location.y);
    
    CGRect frame;
    frame.origin = location;
    frame.size = BOX_SIZE;
    
    
    AnimatedSquareView *thisView = [[AnimatedSquareView alloc] initWithFrame:frame];
    
    //UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:thisView action:]
    
    thisView.backgroundColor = [self randomColor];
    [self.myBoxes addObject:thisView];
    [self.myView addSubview:thisView];
    [self.dropBehavior addItem:thisView];
    NSLog(@"Spawned box and added to dropBehavior w/ gravity %.2f, %.2f", self.dropBehavior.gravity.gravityDirection.dx, self.dropBehavior.gravity.gravityDirection.dy);
    
}

- (void)spawnNewBoxRandomLocation {
    [self spawnNewBoxWithLocation:[self randomLocation]];
}

- (UIColor *)randomColor {
    switch (arc4random()%7) {
        case 0: return [UIColor blackColor];
        case 1: return [UIColor redColor];
        case 2: return [UIColor orangeColor];
        case 3: return [UIColor yellowColor];
        case 4: return [UIColor greenColor];
        case 5: return [UIColor blueColor];
        case 6: return [UIColor purpleColor];
    }
    return [UIColor blackColor];
}

- (CGPoint)randomLocation {
    float y = (int)((self.myView.bounds.size.height) / 6);
    float x = (abs((int)arc4random())%(int)(self.myView.bounds.size.width / BOX_SIZE.width)) * BOX_SIZE.width;
    return CGPointMake(x, y);
}

#pragma mark - UI

- (IBAction)screenTapped:(UITapGestureRecognizer *)sender {
    [self spawnNewBoxRandomLocation];
}

- (IBAction)gravitySlider:(UISlider *)sender {
    self.currentGravity = sender.value;
    self.gravitySelectLabel.text = [NSString stringWithFormat:@"Gravity: %.3f", self.currentGravity];
}

- (CGVector)getGravityDirection {
    return CGVectorMake(self.gravityDirection.dx * self.currentGravity, self.gravityDirection.dy * self.currentGravity * -1.0);
    
}

#pragma mark - Normal View stuff


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [self.animator addBehavior:self.dropBehavior];
    [self setupAccelerometer];
    self.currentGravity = self.gravitySlider.value;
    self.gravitySelectLabel.text = [NSString stringWithFormat:@"Gravity: %.3f", self.currentGravity];

    
    [self.myView addSubview:self.deathBox];
    [self.dropBehavior addItem:self.deathBox];
    
    ViewController *weakSelf = self;
    NSOperationQueue *opQueue = [[NSOperationQueue alloc] init];
    opQueue.name = @"accelerometerQueue";
    
    [self.motionManager startAccelerometerUpdatesToQueue:opQueue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        if (error) {
            [weakSelf handleAccelerometerError];
        }
        weakSelf.gravityDirection = CGVectorMake(accelerometerData.acceleration.x, accelerometerData.acceleration.y);
        weakSelf.dropBehavior.gravity.gravityDirection = [weakSelf getGravityDirection];
        //NSLog(@"Gravity update, %.4f, %.4f", weakSelf.dropBehavior.gravity.gravityDirection.dx, weakSelf.dropBehavior.gravity.gravityDirection.dy);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
