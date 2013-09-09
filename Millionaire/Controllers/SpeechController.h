//
//  SpeechAPI.h
//  Millionaire
//
//  Created by Biranchi on 8/31/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@protocol SpeechControllerDelegate <NSObject>
@optional
-(void)speechDidFinishPlaying:(BOOL)val;
@end


@interface SpeechController : NSObject <AVAudioPlayerDelegate>{
  
}

@property (nonatomic, strong) AVAudioPlayer  *audioPlayer;
@property (nonatomic, weak) id <SpeechControllerDelegate> speechControllerDelegate;
@property (nonatomic, strong) NSMutableArray *audioFileArr;

+(SpeechController *)sharedInstance;
-(void)downloadAndPlayAudioFile:(NSString *)fileName forText:(NSString *)aText;
-(void)removeAudioFile : (NSString *)fileName;
-(void)startPlaying : (NSString *)fileName  isBundleFile:(BOOL)isBundleFile;
-(void)stopPlaying;


@end
