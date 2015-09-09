//
//  UIBoxDropBehavior.m
//  AnimationTester
//
//  Created by James Carlson on 6/29/15.
//  Copyright (c) 2015 dimnsionofsound. All rights reserved.
//

#import "UIBoxDropBehavior.h"

@interface UIBoxDropBehavior()

@end

@implementation UIBoxDropBehavior

- (instancetype)init {
    self = [super init];
    [self addChildBehavior:self.gravity];
    [self addChildBehavior:self.collision];
    return self;
}

- (instancetype)initWithGravityStrength:(CGFloat)s direction:(CGVector)d delegate:(id<UICollisionBehaviorDelegate>)delegate{
    self = [super init];
    [self addChildBehavior:self.gravity];
    [self addChildBehavior:self.collision];
    self.gravity.magnitude = s;
    self.gravity.gravityDirection = d;
    self.collision.collisionDelegate = delegate;
    return self;
}

- (UIGravityBehavior *)gravity {
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc] init];
        _gravity.magnitude = .5;
    }
    return _gravity;
}

- (UICollisionBehavior *)collision {
    if (!_collision) {
        _collision = [[UICollisionBehavior alloc] init];
        _collision.translatesReferenceBoundsIntoBoundary = YES;
    }
    return _collision;
}

- (void)addItem:(id <UIDynamicItem>)item {
    [self.collision addItem:item];
    [self.gravity addItem:item];
}


- (void)removeItem:(id <UIDynamicItem>)item {
    [self.collision removeItem:item];
    [self.gravity removeItem:item];
}

@end
