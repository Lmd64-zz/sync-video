//
//  ViewController.h
//  VideoLooper
//
//  Created by Liam Dunne on 10/05/2013.
//  Copyright (c) 2013 Lmd64. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController : UIViewController 

@property (nonatomic,weak) IBOutlet UIButton *changeVideoButton;
@property (nonatomic,strong) AVPlayer *player;

- (IBAction)changeVideoButtonTapped:(id)sender;

@end
