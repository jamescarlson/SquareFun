//
//  UIBoxDropBehavior.h
//  AnimationTester
//
//  Created by James Carlson on 6/29/15.
//  Copyright (c) 2015 dimnsionofsound. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBoxDropBehavior : UIDynamicBehavior

@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collision;


- (void)removeItem:(id <UIDynamicItem>)item;
- (void)addItem:(id <UIDynamicItem>)item;
- (instancetype)initWithGravityStrength:(CGFloat)s direction:(CGVector)d delegate:(id<UICollisionBehaviorDelegate>)delegate;

@end
