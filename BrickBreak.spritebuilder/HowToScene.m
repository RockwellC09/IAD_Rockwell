//
//  HowToScene.m
//  BrickBreak
//
//  Created by Christopher Rockwell on 8/28/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "HowToScene.h"
#import "IntroScene.h"


@implementation HowToScene
CCSprite *_player;
CCSprite *_cannonBase;
CCSprite *_brick;
CCSprite *_ball;
int height;
int width;

+ (HowToScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // get screen size
    CGSize s = [[CCDirector sharedDirector] viewSize];
    width = s.width;
    height = s.height;
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Brick Break label
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"How To Play" fontName:@"American Typewriter" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor whiteColor];
    label.position = ccp(0.5f, 0.8f);
    [self addChild:label];
    
    // add how to label
    CCLabelTTF *howToLabel = [CCLabelTTF labelWithString:@"The object of the game is to aim the cannon at the brick and tap the screen in order to shoot a cannonball to Break the Brick. You have 5 lives to rack up as many points a you can. Enjoy!" fontName:@"American Typewriter" fontSize:14.0f dimensions:CGSizeMake(400,100)];
    
    howToLabel.positionType = CCPositionTypeNormalized;
    howToLabel.color = [CCColor whiteColor];
    howToLabel.position = ccp(0.5f, 0.55f);
    [self addChild:howToLabel];
    
    // add player sprites
    _player = [CCSprite spriteWithImageNamed:@"cannon_barrel.png"];
    _player.position  = ccp(width/2,50);
    _player.rotation = -90.0f;
    _player.scale = 0.6f;
    [self addChild:_player];
    
    
    // add cannon base
    _cannonBase = [CCSprite spriteWithImageNamed:@"cannon_base.png"];
    _cannonBase.position = ccp(width/2 + 7,20);
    _cannonBase.scale = 0.6;
    [self addChild:_cannonBase];
    
    // add brick
    _brick = [CCSprite spriteWithImageNamed:@"brick.png"];
    _brick.position  = ccp(width/2+5, _player.position.y + 90);
    _brick.scale = 0.7f;
    [self addChild:_brick];
    
    // add ball sprite
    _ball = [CCSprite spriteWithImageNamed:@"ball.png"];
    _ball.scale = .5f;
    _ball.position  = ccp(width / 2 + 6, _player.position.y + 60);
    [self addChild:_ball];
    
    // back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ back ]" fontName:@"Verdana-Bold" fontSize:16.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.10f, 0.9f);
    [backButton setTarget:self selector:@selector(back:)];
    [self addChild:backButton];
    
    
    return self;
}

// back button method to go back to the main menu
- (void)back:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]];
}

@end
