//
//  ViewController.m
//  VideoLooper
//
//  Created by Liam Dunne on 10/05/2013.
//  Copyright (c) 2013 Lmd64. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

static void *PlayerStatusObservationContext = &PlayerStatusObservationContext;

@interface ViewController () {
    NSArray *videoFiles;
    NSInteger indexOfCurrentVideo;
    AVPlayerLayer *_playerLayer;
    AVPlayerItem *_playerItem;
}
@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    videoFiles = @[@"e.mp4",@"b.mp4"];
    indexOfCurrentVideo = 0;
    [self setupAVPlayer];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self startVideo];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupAVPlayer{
    [self.view setContentMode:UIViewContentModeScaleAspectFit];
    
    if (!_player){
        _player = [[AVPlayer alloc] init];
        _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[_player currentItem]];
    }
    
    if (!_playerLayer){
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        [_playerLayer setOpacity:1.0];
        _playerLayer.frame = self.view.bounds;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        _playerLayer.contentsGravity = kCAGravityResizeAspect;
        _playerLayer.contentsRect = self.view.bounds;
        _playerLayer.masksToBounds = YES;
        [self.view.layer insertSublayer:_playerLayer atIndex:1];
        [_player addObserver:self forKeyPath:@"status" options:0 context:PlayerStatusObservationContext];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    _playerLayer.contentsRect = self.view.bounds;
}

#pragma mark -
#pragma KVO methods
- (void)observeValueForKeyPath:(NSString*) path ofObject:(id)object change:(NSDictionary*)change context:(void*)context{
    
    if ([object isKindOfClass:[AVPlayer class]]){
        AVPlayer *p = (AVPlayer*)object;
        if (p.status == AVPlayerStatusReadyToPlay) {
            [p play];
            [p removeObserver:self forKeyPath:@"status" context:PlayerStatusObservationContext];
        }
        return;
    }
    
    [super observeValueForKeyPath:path ofObject:object change:change context:context];
    
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void)viewDidUnload {
    [self setChangeVideoButton:nil];
    [super viewDidUnload];
}
- (IBAction)changeVideoButtonTapped:(id)sender {
    indexOfCurrentVideo++;
    indexOfCurrentVideo = indexOfCurrentVideo % [videoFiles count];
    [self startVideo];
}

- (void)startVideo{
    [_player pause];
    NSString *filename = [videoFiles objectAtIndex:indexOfCurrentVideo];
    NSURL *url = [[NSBundle mainBundle] URLForResource:[filename stringByDeletingPathExtension]
                                         withExtension:[filename pathExtension]];
    _playerItem = [AVPlayerItem playerItemWithURL:url];
    [_player replaceCurrentItemWithPlayerItem:_playerItem];
    [_player play];
}

@end
