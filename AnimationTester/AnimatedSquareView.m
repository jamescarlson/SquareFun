//
//  AnimatedSquareView.m
//  AnimationTester
//
//  Created by James Carlson on 6/30/15.
//  Copyright (c) 2015 dimnsionofsound. All rights reserved.
//

#import "AnimatedSquareView.h"
#import "UIBoxDropBehavior.h"

@implementation AnimatedSquareView

- (instancetype)initWithFrame:(CGRect)frame behavior:(UIBoxDropBehavior *)behavior {
    self = [super initWithFrame:frame];
    self.myBehavior = behavior;
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
