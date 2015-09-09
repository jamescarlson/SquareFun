//
//  AnimatedSquareView.h
//  AnimationTester
//
//  Created by James Carlson on 6/30/15.
//  Copyright (c) 2015 dimnsionofsound. All rights reserved.
//

#import "UIBoxDropBehavior.h"
#import <UIKit/UIKit.h>

@interface AnimatedSquareView : UIView

@property (nonatomic, strong) UIBoxDropBehavior *myBehavior;

- (instancetype)initWithFrame:(CGRect)frame behavior:(UIBoxDropBehavior *)behavior;
@end
