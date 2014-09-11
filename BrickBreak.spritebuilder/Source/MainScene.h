//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface MainScene : CCScene <CCPhysicsCollisionDelegate>

+ (MainScene *)scene;
@property (nonatomic, strong) CCSprite *shoot;
@property (nonatomic, strong) CCAction *shootAction;
@end
